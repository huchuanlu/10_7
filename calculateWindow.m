function [ dataWindow searchWindow targetWindow ] = calculateWindow(targetLocation, targetWindowHF, searchWindowHF, imageSize)
%% function [ dataWindow searchWindow targetWindow ] = calculateWindow(targetLocation, targetWindowHF, searchWindowHF, imageSize)
%% Calculate Windows: dataWindow searchWindow targetWindow
%% Input:
%%      targetLocation = [ targetLocation(1) targetLocation(2) ];
%%      targetWindowHF = [ targetWindowHF(1) targetWindowHF(2) ];
%%      searchWindowHF = [ searchWindowHF(1) searchWindowHF(2) ];
%%      imageSize      = [ imageSize(1) imageSize(2) ];
%% Output:
%%      dataWindow     = [ dataWindow(1) dataWindow(2) 
%%                         dataWindow(3) dataWindow(4) ];
%%      searchWindow   = [ searchWindow(1) searchWindow(2)
%%                         searchWindow(3) searchWindow(4) ];
%%      targetWindow   = [ targetWindow(1) targetWindow(2)
%%                         targetWindow(3) targetWindow(4) ];
%%
%% DUT-IIAU-Dong Wang-2010,01,13

searchWindow    = zeros(1,4);
searchWindow(1) = max(targetLocation(1)-searchWindowHF(1), 1);
searchWindow(2) = min(targetLocation(1)+searchWindowHF(1), imageSize(1));
searchWindow(3) = max(targetLocation(2)-searchWindowHF(2), 1);
searchWindow(4) = min(targetLocation(2)+searchWindowHF(2), imageSize(2));

dataWindow    = zeros(1,4);
dataWindow(1) = max(searchWindow(1)-targetWindowHF(1), 1);
dataWindow(2) = min(searchWindow(2)+targetWindowHF(1), imageSize(1));
dataWindow(3) = max(searchWindow(3)-targetWindowHF(2), 1);
dataWindow(4) = min(searchWindow(4)+targetWindowHF(2), imageSize(2));

searchWindow(1) = dataWindow(1) + targetWindowHF(1);
searchWindow(2) = dataWindow(2) - targetWindowHF(1);
searchWindow(3) = dataWindow(3) + targetWindowHF(2);
searchWindow(4) = dataWindow(4) - targetWindowHF(2);

targetWindow  = [ targetLocation(1)-targetWindowHF(1) targetLocation(1)+targetWindowHF(1)...
                  targetLocation(2)-targetWindowHF(2) targetLocation(2)+targetWindowHF(2) ];