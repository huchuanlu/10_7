function result = integralHistogram(valueMap,indexMap,binsIndex)
%% function result = integralHistogram(valueMap,indexMap,binsIndex)
%% Integral Histogram
%%
%% DUT-IIAU-Dong Wang-2010,01,13
%% 
bins = size(binsIndex,2);
sz   = size(indexMap);
if valueMap == 0
   clear valueMap;
   valueMap = ones(sz);
end

layerMap = zeros(sz(1),sz(2));
result   = zeros(sz(1),sz(2),bins);

for i = 1:bins
    temp = zeros(sz(1),sz(2));
    temp(find(indexMap==binsIndex(i))) = 1;
    layerMap = valueMap.*temp; 
    result(:,:,i) = integralImage(layerMap);    
end
    


