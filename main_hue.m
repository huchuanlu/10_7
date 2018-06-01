clear all;
clc;
%%******************************************************************%%
dataPath = '.\camera1_1\';
title = 'camera1_1';
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
%%******************************************************************%%

% % %%******************************************************************%%
% dataPath = '.\face_sequence\';
% title = 'face_sequence';
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
% % %%******************************************************************%%

result = [];
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
fprintf('Press Any Key To Continue...');

imageRGB = imread([dataPath int2str(1) dataType]);
imageHSI = rgb2hsi(imageRGB);
imageHue = 255*imageHSI(:,:,1);
axes(axes('position', [0 0 1.0 1.0]));
imagesc(imageRGB, [0,1]); 
hold on;     
text(5, 18, 'pyramid', 'Color','r', 'FontWeight','bold', 'FontSize',15);
text(5, 36, num2str(1), 'Color','r', 'FontWeight','bold', 'FontSize',15);
temp = importdata([dataPath int2str(1) '.txt']);
drawBoundingBox(temp(1,1),temp(1,2),temp(1,3),temp(1,4),'r');
targetWindowSize = [ abs(temp(1,2)-temp(1,1)+1),abs(temp(1,4)-temp(1,3)+1) ]; 
targetLocation   = [ round((temp(1,1)+temp(1,2))/2),round((temp(1,3)+temp(1,4))/2) ];
targetWindowHF   = [ floor(targetWindowSize(1)/2) floor(targetWindowSize(2)/2) ];      
[ dataWindow searchWindow targetWindow ] = calculateWindow(targetLocation, targetWindowHF, searchWindowHF, imageSize); 
data = imageHue(dataWindow(1):dataWindow(2),dataWindow(3):dataWindow(4));
[ indexMap binsIndex ] = rgbQuantification(data, hueBins, 0);
hueIH = integralHistogram(0,indexMap,binsIndex);
targetLocationT = coordinate_o2r(dataWindow, targetLocation);
[ dataWindowT searchWindowT targetWindowT ] = calculateWindow(targetLocationT, targetWindowHF, searchWindowHF, imageSize);
patchParam = pyramidPatchLevel3(targetWindowT, dataWindowT);

objectHistogramPyramid = calculatePyramidFeatures_IH(hueIH, patchParam, hueBins);
maxMatchNum = calculatePyramidMatching(objectHistogramPyramid, objectHistogramPyramid);
targetLocation = coordinate_r2o(dataWindow, targetLocationT);
axis equal tight off;
hold off;
drawnow;
result = [ result ; targetLocation ];


for num = trainFrameNumber+1:endFrameNumber  
    imageRGB = imread([dataPath int2str(num) dataType]);
    image(imageRGB);
    axes(axes('position', [0 0 1.0 1.0]));
    imagesc(imageRGB, [0,1]); 
    hold on; 
    text(5, 18, 'pyramid', 'Color','r', 'FontWeight','bold', 'FontSize',15);
    text(5, 36, num2str(num), 'Color','r', 'FontWeight','bold', 'FontSize',15);
    
    imageHSI = rgb2hsi(imageRGB);
    imageHue = 255*imageHSI(:,:,1);
    data = imageHue(dataWindow(1):dataWindow(2),dataWindow(3):dataWindow(4));
    [ indexMap binsIndex ] = rgbQuantification(data, hueBins, 0);
    hueIH = integralHistogram(0,indexMap,binsIndex);
    targetLocationT = coordinate_o2r(dataWindow, targetLocation);
    [ dataWindowT searchWindowT targetWindowT ] = calculateWindow(targetLocationT, targetWindowHF, searchWindowHF, imageSize);
    targetLocationT = coordinate_o2r(searchWindow, targetLocation);
    confidenceHue = zeros(searchWindowT(2)-searchWindowT(1)+1, searchWindowT(4)-searchWindowT(3)+1);
    for rr = searchWindowT(1):searchWindowT(2)
        for cc = searchWindowT(3):searchWindowT(4)
            candidataWindowT = [ round(rr-targetWindowHF(1)), round(rr+targetWindowHF(1)),...
                                 round(cc-targetWindowHF(2)), round(cc+targetWindowHF(2)) ];
            patchParam = pyramidPatchLevel3(candidataWindowT, dataWindowT);
            candidateHistogramPyramid = calculatePyramidFeatures_IH(hueIH, patchParam, hueBins);
            confidenceHue(rr-searchWindowT(1)+1,cc-searchWindowT(3)+1) = calculatePyramidMatching(objectHistogramPyramid, candidateHistogramPyramid)/maxMatchNum;
        end
    end
    confidenceHue = exp(sigmaHue*confidenceHue);
    confidenceHue = confidenceHue./max(max(confidenceHue));

    temp = zeros(size(confidenceHue));
    for rr = 1+halfMW:size(temp,1)-halfMW
        for cc = 1+halfMW:size(temp,2)-halfMW
            temp(rr,cc) = sum(sum(confidenceHue(rr-halfsz:rr+halfsz,cc-halfsz:cc+halfsz)));
        end
    end
    [ a b ] = find(temp == max(max(temp)));
    targetLocationT(1) = round(mean(a));
    targetLocationT(2) = round(mean(b));
    targetLocation = coordinate_r2o(searchWindow, targetLocationT);
    [ dataWindow searchWindow targetWindow ] = calculateWindow(targetLocation, targetWindowHF, searchWindowHF, imageSize);
    drawBoundingBox(targetWindow(1),targetWindow(2),targetWindow(3),targetWindow(4),'r');   
    axis equal tight off;
    hold off;
    drawnow;
    clf;
    result = [ result ; targetLocation ];
end
save result.mat result