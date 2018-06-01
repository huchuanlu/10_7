function costValue = calcucateCostValue(weights, confidenceMaps, guassianTemplate)
%% function costValue = calcucateCostValue(weights, confidenceMaps, guassianTemplate)
%%      Calcucate Cost Value
%% Input: 
%%      weights£º            The weights of different confidence maps
%%      confidenceMaps£º     Confidence Maps
%%      guassianTemplate£º   Guassian Template
%% Output:
%%      costValue:           cost value
%%
%% DUT-IIAU-Dong Wang-2010,01,13

num = size(weights, 2);
optionalPosition = [ median(1:size(confidenceMaps,1)) median(1:size(confidenceMaps,2)) ];

sumConfidenceMap = zeros(size(confidenceMaps,1), size(confidenceMaps,2));
for  ii = 1:num
     sumConfidenceMap = sumConfidenceMap + weights(ii)*confidenceMaps(:,:,ii);
end

sumConfidenceMap = sumConfidenceMap./sumConfidence(optionalPosition(1),optionalPosition(2));
costValueMatrix = sumConfidenceMap - guassianTemplate;
costValueMatrix(find(costValueMatrix<0)) = 0;
costValue = sum(sum(costValueMatrix));