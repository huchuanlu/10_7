function matchNum = histogramIntersection(hst1, hst2)
%% function matchNum = histogramIntersection(hst1, hst2)
%% Histogram Intersection
%% Input:
%%      hst1:       histogram 1
%%      hst2:       hsitogram 2
%% Output:
%%      matchNum:   Match Number
%% DUT-IIAU-Dong Wang-2010,01,13
matchNum = sum(min(hst1,hst2));