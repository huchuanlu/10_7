function matchNum = calculatePyramidMatching(histogramPyramid1, histogramPyramid2)
%% function matchNum = calculatePyramidMatching(histogramPyramid1, histogramPyramid2)
%% Calculate Pyramid Matching
%% Input:
%%        histogramPyramid1:  Histogram Pyramid 1
%%        histogramPyramid2:  Histogram Pyramid 2
%% Output:
%%        matchNum: match number
%%
%% DUT-IIAU-Dong Wang-2010,01,13
matchNum_0 = histogramIntersection(histogramPyramid1.level_0, histogramPyramid2.level_0);
matchNum_1 = histogramIntersection(histogramPyramid1.level_1, histogramPyramid2.level_1);
matchNum_2 = histogramIntersection(histogramPyramid1.level_2, histogramPyramid2.level_2);
matchNum   = histogramPyramid1.weightLevel_0*matchNum_0 + ...
             histogramPyramid1.weightLevel_1*matchNum_1 + ...
             histogramPyramid1.weightLevel_2*matchNum_2;
