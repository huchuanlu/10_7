function [ valueMap indexMap ] = hog(im, angle, bins)
%% function [ valueMap indexMap ] = hog(im, angle, bins, T )
%% obtains gradient map of magnitude and  oriented gradient map
%% Input£º
%%      im      : image matrix
%%      angle   : angle range
%%       bins   : quantification bin number
%% Output£º
%%   valueMap   : gradient map of magnitude
%%   indexMap   : oriented gradient map
%%
%% DUT-IIAU-Dong Wang-2009.06.01
%%

if size(im,3) == 3
    imG = rgb2gray(im);
else
    imG = im;
end

[gradientX,gradientY] = gradient(double(imG));                             
valueMap = sqrt((gradientX.*gradientX)+(gradientY.*gradientY));            
index = (gradientX==0); gradientX(index) = 1e-5;                           
YX = gradientY./gradientX;                                                 

if angle == 180, angleMap = ((atan(YX)+(pi/2))*180)/pi; end                   
if angle == 360, angleMap = ((atan2(gradientY,gradientX)+pi)*180)/pi; end  
                          
nAngle = angle/bins;                                                     

indexMap = fix((angleMap-1e-5)/nAngle) + 1;                                
