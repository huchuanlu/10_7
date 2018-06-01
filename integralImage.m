function ii = integralImage(image)
%% function result = integralImage(image)
%% Integral Image
%%
%% DUT-IIAU-Dong Wang-2010,01,13
%% 
s = cumsum(image')';     
ii = cumsum(s);         
