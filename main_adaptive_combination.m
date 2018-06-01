clear all;
clc;
% %%******************************************************************%%
% dataPath = '.\camera1_1\';
% title = 'camera1_1';
% searchWindowHF = [ 15 15 ];
% grayBins = 8;
% hogAngle = 180;    
% hogBins = 8;
% hueBins = 8;
% displayFlag = 1;
% halfMW    = 7;
% template = calculateGuassianTemplate([15 15],[6 6]);
% halfsz    = 1;
% sigmaGray = 5;
% sigmaHue  = 5;
% sigmaHoG  = 5;
% dataType = '.jpg';
% %%******************************************************************%%

% %%******************************************************************%%
dataPath = '.\face_sequence\';
title = 'face_sequence';
searchWindowHF = [ 15 15 ];
grayBins = 8;
hogAngle = 180;    
hogBins = 8;
hueBins = 8;
displayFlag = 1;
halfMW    = 7;
template = calculateGuassianTemplate([15 15],[6 6]);
halfsz    = 1;
sigmaGray = 5;
sigmaHue  = 5;
sigmaHoG  = 5;
dataType = '.jpg';
% %%******************************************************************%%



result = [];
weightSet = [];
temp = importdata([dataPath 'datainfo.txt']);           
frameNumber = temp(3);  rows = temp(2); cols = temp(1);     
trainFrameNumber = 1;                                       
endFrameNumber   = frameNumber;                             
%%******************************************************************%%


tic;
imageSize = [ rows cols ];
figure('position',[ 0 0 imageSize(2) imageSize(1) ]); 
set(gcf,'DoubleBuffer','on','MenuBar','none');
pause;
fprintf('Press Any Key to Continue...');

imageRGB = imread([dataPath int2str(1) dataType]);
%%Gray
imageGray = rgb2gray(imageRGB);
%%HSI
imageHSI = rgb2hsi(imageRGB);
imageHue = 255*imageHSI(:,:,1);
axes(axes('position', [0 0 1.0 1.0]));
imagesc(imageRGB, [0,1]); 
hold on;     
text(5, 18, 'pyramid', 'Color','r', 'FontWeight','bold', 'FontSize',15);
text(5, 36, num2str(1), 'Color','r', 'FontWeight','bold', 'FontSize',15);
temp = importdata([dataPath int2str(1) '.txt']);
%%Draw Target Window
drawBoundingBox(temp(1,1),temp(1,2),temp(1,3),temp(1,4),'r');
%%Obtain the Target Size
targetWindowSize = [ abs(temp(1,2)-temp(1,1)+1),abs(temp(1,4)-temp(1,3)+1) ]; 
%%Obtain the Target Position
targetLocation   = [ round((temp(1,1)+temp(1,2))/2),round((temp(1,3)+temp(1,4))/2) ];
targetWindowHF   = [ floor(targetWindowSize(1)/2) floor(targetWindowSize(2)/2) ];      
[ dataWindow searchWindow targetWindow ] = calculateWindow(targetLocation, targetWindowHF,...
                                                            searchWindowHF, imageSize); 
                                                        
%% Compute Local Intergal Histogram
data = imageGray(dataWindow(1):dataWindow(2),dataWindow(3):dataWindow(4));
%%Gray
[ indexMap binsIndex ] = rgbQuantification(data, grayBins, 0);
grayIH = integralHistogram(0,indexMap,binsIndex);
%%HOG
[ valueMap indexMap ] = hog(data, hogAngle, hogBins);
hogIH = integralHistogram(valueMap, indexMap, 1:hogBins);
%%HSI
data = imageHue(dataWindow(1):dataWindow(2),dataWindow(3):dataWindow(4));
[ indexMap binsIndex ] = rgbQuantification(data, hueBins, 0);
hueIH = integralHistogram(0,indexMap,binsIndex);

targetLocationT = coordinate_o2r(dataWindow, targetLocation);
[ dataWindowT searchWindowT targetWindowT ] = calculateWindow(targetLocationT, targetWindowHF, ....
                                                               searchWindowHF, imageSize);
patchParam = pyramidPatchLevel3(targetWindowT, dataWindowT);
objectHP_Gray = calculatePyramidFeatures_IH(grayIH, patchParam, grayBins);
maxMatchNumGray = calculatePyramidMatching(objectHP_Gray, objectHP_Gray);
objectHP_HOG = calculatePyramidFeatures_IH(hogIH, patchParam, grayBins);
maxMatchNumHOG = calculatePyramidMatching(objectHP_HOG, objectHP_HOG);
objectHP_Hue = calculatePyramidFeatures_IH(hueIH, patchParam, grayBins);
maxMatchNumHue = calculatePyramidMatching(objectHP_Hue, objectHP_Hue);
targetLocation = coordinate_r2o(dataWindow, targetLocationT);
axis equal tight off;
hold off;
drawnow;
result = [ result ; targetLocation ];

weights = [ 1/3 1/3 1/3 ]';
weightSet = [ weightSet ; weights' ];
N = 300;
sigma = 5;

%%Start Tracking
for num = trainFrameNumber+1:endFrameNumber  
    num
    imageRGB = imread([dataPath int2str(num) dataType]);
    image(imageRGB);
    axes(axes('position', [0 0 1.0 1.0]));
    imagesc(imageRGB, [0,1]); 
    hold on; 
    text(5, 18, 'pyramid', 'Color','r', 'FontWeight','bold', 'FontSize',15);
    text(5, 36, num2str(num), 'Color','r', 'FontWeight','bold', 'FontSize',15);
    
    %%Gray
    imageGray = rgb2gray(imageRGB);
    %%HSI
    imageHSI = rgb2hsi(imageRGB);
    imageHue = 255*imageHSI(:,:,1);
    
    %% Compute Local Intergal Histogram
    data = imageGray(dataWindow(1):dataWindow(2),dataWindow(3):dataWindow(4));
    [ indexMap binsIndex ] = rgbQuantification(data, grayBins, 0);
    grayIH = integralHistogram(0,indexMap,binsIndex);
    %%Gray
    [ indexMap binsIndex ] = rgbQuantification(data, grayBins, 0);
    grayIH = integralHistogram(0,indexMap,binsIndex);
    %%HOG
    [ valueMap indexMap ] = hog(data, hogAngle, hogBins);
    hogIH = integralHistogram(valueMap, indexMap, 1:hogBins);
    %%HSI
    data = imageHue(dataWindow(1):dataWindow(2),dataWindow(3):dataWindow(4));
    [ indexMap binsIndex ] = rgbQuantification(data, hueBins, 0);
    hueIH = integralHistogram(0,indexMap,binsIndex);
    
    targetLocationT = coordinate_o2r(dataWindow, targetLocation);
    [ dataWindowT searchWindowT targetWindowT ] = calculateWindow(targetLocationT, targetWindowHF, searchWindowHF, imageSize);
     targetLocationT = coordinate_o2r(searchWindow, targetLocation);
     
    %% Compute Confidence Maps
    confidenceGray = zeros(searchWindowT(2)-searchWindowT(1)+1, searchWindowT(4)-searchWindowT(3)+1);
    confidenceHOG  = zeros(searchWindowT(2)-searchWindowT(1)+1, searchWindowT(4)-searchWindowT(3)+1);
    confidenceHue  = zeros(searchWindowT(2)-searchWindowT(1)+1, searchWindowT(4)-searchWindowT(3)+1);
    for rr = searchWindowT(1):searchWindowT(2)
        for cc = searchWindowT(3):searchWindowT(4)
            candidataWindowT = [ round(rr-targetWindowHF(1)), round(rr+targetWindowHF(1)),...
                                 round(cc-targetWindowHF(2)), round(cc+targetWindowHF(2)) ];
            patchParam = pyramidPatchLevel3(candidataWindowT, dataWindowT);
            candidateHP_Gray = calculatePyramidFeatures_IH(grayIH, patchParam, grayBins);
            candidateHP_Hue  = calculatePyramidFeatures_IH(hueIH, patchParam, hueBins);
            candidateHP_HOG  = calculatePyramidFeatures_IH(hogIH, patchParam, hogBins);
            confidenceGray(rr-searchWindowT(1)+1,cc-searchWindowT(3)+1) = calculatePyramidMatching(objectHP_Gray, candidateHP_Gray)/maxMatchNumGray;
            confidenceHue(rr-searchWindowT(1)+1,cc-searchWindowT(3)+1)  = calculatePyramidMatching(objectHP_Hue, candidateHP_Hue)/maxMatchNumHue;
            confidenceHOG(rr-searchWindowT(1)+1,cc-searchWindowT(3)+1)  = calculatePyramidMatching(objectHP_HOG, candidateHP_HOG)/maxMatchNumHOG;
        end
    end
    
    %% Combination Confidence Map
    confidence = weights(1)*confidenceGray + weights(2)*confidenceHue + weights(3)*confidenceHOG;
    confidence = exp(sigma*confidence);
    confidence = confidence./max(max(confidence));
    
    temp = zeros(size(confidence));
    for rr = 1+halfMW:size(temp,1)-halfMW
        for cc = 1+halfMW:size(temp,2)-halfMW
            temp(rr,cc) = sum(sum(confidence(rr-halfsz:rr+halfsz,cc-halfsz:cc+halfsz)));
        end
    end
    [ a b ] = find(temp == max(max(temp)));
    targetLocationT(1) = round(mean(a));
    targetLocationT(2) = round(mean(b));
    
    %% Update Weights (Simple Sampling technique instead of PSO)
    confidenceGrayT = confidenceGray(targetLocationT(1)-halfMW:targetLocationT(1)+halfMW, targetLocationT(2)-halfMW:targetLocationT(2)+halfMW);
    confidenceHueT  = confidenceHue(targetLocationT(1)-halfMW:targetLocationT(1)+halfMW, targetLocationT(2)-halfMW:targetLocationT(2)+halfMW);
    confidenceHOGT  = confidenceHOG(targetLocationT(1)-halfMW:targetLocationT(1)+halfMW, targetLocationT(2)-halfMW:targetLocationT(2)+halfMW);
    weightsT = repmat(weights, [ 1 N ]) + abs(0.2*randn(3,N));
    costVaule = zeros(1,N);
    for ii = 1:N
        weightsT(:,ii) = weightsT(:,ii)./sum(weightsT(:,ii));
        temp = weightsT(1,ii)*confidenceGrayT + weightsT(2,ii)*confidenceHueT + weightsT(3,ii)*confidenceHOGT;
        temp = exp(sigma*temp);
        temp = temp/temp(halfMW+1,halfMW+1);
        temp = temp - template;
        temp(find(temp<0)) = 0;
        costValue(ii) = sum(sum(temp));
    end
    [ value index ] = min(costValue);
    weights = weightsT(:,index);
    weightSet = [ weightSet ; weights' ];
    %%
    
    targetLocation = coordinate_r2o(searchWindow, targetLocationT);
    result = [ result ; targetLocation ];
    [ dataWindow searchWindow targetWindow ] = calculateWindow(targetLocation, targetWindowHF, searchWindowHF, imageSize);
    drawBoundingBox(targetWindow(1),targetWindow(2),targetWindow(3),targetWindow(4),'r');  
    axis equal tight off;
    hold off;
    drawnow;
    clf;
end
save result.mat result
save weightSet.mat weightSet
