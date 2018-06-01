function template = calculateGuassianTemplate(windowSize,sigma)
%% function template = calculateGuassianTemplate(windowSize,sigma)
%%          Calculate Guassian Template
%% Input:
%%          windowSize:     [windowSize(1) windowSize(2)]
%%          sigma£º         [sigma(1) sigma(2)]
%% Output:
%%          template£º      2D Guassian Template£»
%%
%% DUT-IIAU-Dong Wang-2010,01,13

template = zeros(size(windowSize));
meanX    = (windowSize(1)+1)/2.0;
meanY    = (windowSize(2)+1)/2.0;
for xx = 1:windowSize(1)
    for yy = 1:windowSize(2)
        template(xx,yy) = exp(-(xx-meanX)^2/(2*sigma(1)^2)-(yy-meanY)^2/(2*sigma(2)^2));
    end
end