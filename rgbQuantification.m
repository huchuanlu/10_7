function [ indexMap binsIndex ] = rgbQuantification(image,bins,color)
%% function [ indexMap binsIndex ] = rgbQuantification(image,bins,color)
%% obtains RGB quantification map
%% Input：
%%      image：      image matrix
%%      bins：       quantification bin number
%%      color：      if color==0，quantize gray image
%%                   if color==1，quantize color image
%% Output：       
%%      indexMap：   RGB quantification map
%%      binsIndex：  index range
%%
%% DUT-IIAU-Dong Wang-2009,05,13
%%

sz = size(image);
indexMap = zeros(sz(1),sz(2));
if color == 0   %%对于灰度图量化
   for i = 1:sz(1)
       for j = 1:sz(2)
           indexMap(i,j) = floor(double(image(i,j))*bins/256) + 1;  %%灰度图等间隔量化bins
       end
   end
   binsIndex = [ 1: bins ];
end

if color == 1   %%对于彩色图量化
   for i = 1:sz(1)
       for j = 1:sz(2)
           rn = floor(double(image(i,j,1))*bins/256);           %%R等间隔量化bins
           gn = floor(double(image(i,j,2))*bins/256);           %%G等间隔量化bins
           bn = floor(double(image(i,j,3))*bins/256);           %%B等间隔量化bins
           indexMap(i,j) = rn*bins*bins + gn*bins + bn + 1;     %%分配索引号 1：bins*bins*bins
       end
   end
   binsIndex = [ 1: bins*bins*bins ];
end