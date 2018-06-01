function histogramPyramid = calculatePyramidFeatures_IH(integralHistogram, patchParam, bins) 
%% function histogramPyramid = calculatePyramidFeatures_IH(integralHistogram, patchParam, bins) 
%% Obtain Histogram Pyramid
%% Input:   integralHistogram: Intergral Histogram
%%          patchParam:        Patch Number
%% Output:  
%%          histogramPyramid:  Histogram Pyramid
%%
%% DUT-IIAU-Dong Wang-2010,01,13
%%
histogramPyramid = [];
histogramPyramid.level_0 = zeros(size(patchParam.level_0,1)*bins,1);
histogramPyramid.level_1 = zeros(size(patchParam.level_1,1)*bins,1);
histogramPyramid.level_2 = zeros(size(patchParam.level_2,1)*bins,1);

for num = 1:size(patchParam.level_0,1)
    rMin = patchParam.level_0(num,1);
    rMax = patchParam.level_0(num,2);
    cMin = patchParam.level_0(num,3);
    cMax = patchParam.level_0(num,4);
    %%右上
    if  rMin ~= 1
        b =  reshape(integralHistogram(rMin-1,cMax,:), bins, 1);
    else
        b = zeros(bins,1);
    end
    %%左下
    if  cMin ~= 1
        c =  reshape(integralHistogram(rMax,cMin-1,:), bins, 1);
    else
        c = zeros(bins,1);
    end
    %%左上
    if  (rMin~=1) && (cMin~=1)
        a =  reshape(integralHistogram(rMin-1,cMin-1,:), bins, 1);
    else
        a = zeros(bins,1);
    end
    %%右下
    d = reshape(integralHistogram(rMax,cMax,:), bins, 1);
    histogramPyramid.level_0((1+(num-1)*bins):num*bins,1) = a + d - b - c;       
end

for num = 1:size(patchParam.level_1,1)
    rMin = patchParam.level_1(num,1);
    rMax = patchParam.level_1(num,2);
    cMin = patchParam.level_1(num,3);
    cMax = patchParam.level_1(num,4);
    %%右上
    if  rMin ~= 1
        b =  reshape(integralHistogram(rMin-1,cMax,:), bins, 1);
    else
        b = zeros(bins,1);
    end
    %%左下
    if  cMin ~= 1
        c =  reshape(integralHistogram(rMax,cMin-1,:), bins, 1);
      else
        c = zeros(bins,1);      
    end
    %%左上
    if  (rMin~=1) && (cMin~=1)
        a =  reshape(integralHistogram(rMin-1,cMin-1,:), bins, 1);
    else
        a = zeros(bins,1);
    end
    %%右下
    d = reshape(integralHistogram(rMax,cMax,:), bins, 1);
    histogramPyramid.level_1((1+(num-1)*bins):num*bins,1) = a + d - b - c;      
end

for num = 1:size(patchParam.level_2,1)
    rMin = patchParam.level_2(num,1);
    rMax = patchParam.level_2(num,2);
    cMin = patchParam.level_2(num,3);
    cMax = patchParam.level_2(num,4);
    %%右上
    if  rMin ~= 1
        b =  reshape(integralHistogram(rMin-1,cMax,:), bins, 1);
    else
        b = zeros(bins,1);
    end
    %%左下
    if  cMin ~= 1
        c =  reshape(integralHistogram(rMax,cMin-1,:), bins, 1);
    else
        c = zeros(bins,1);
    end
    %%左上
    if  (rMin~=1) && (cMin~=1)
        a =  reshape(integralHistogram(rMin-1,cMin-1,:), bins, 1);
    else
        a = zeros(bins,1);
    end
    %%右下
    d = reshape(integralHistogram(rMax,cMax,:), bins, 1);
    histogramPyramid.level_2((1+(num-1)*bins):num*bins,1) = a + d - b - c;  
end

histogramPyramid.weightLevel_0 = patchParam.weightLevel_0;
histogramPyramid.weightLevel_1 = patchParam.weightLevel_1;
histogramPyramid.weightLevel_2 = patchParam.weightLevel_2;
