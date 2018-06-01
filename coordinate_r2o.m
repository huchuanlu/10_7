function center_O = coordinate_r2o(dataWindow, center_R)
%% function center_O = coordinate_r2o(dataWindow, center_R)
%% Relative Position --> Original Position
%% Input:
%%         dataWindow: [ rmin rmax cmin cmax ]
%%         center_R:   [ center_R(1) center_R(2) ]
%% Output:
%%         center_O:   [ center_O(1) center_O(2) ]
%%
%% DUT-IIAU-Dong Wang-2010,01,13

center_O    = [ 0 0 ];
center_O(1) = center_R(1) + dataWindow(1) - 1;
center_O(2) = center_R(2) + dataWindow(3) - 1; 