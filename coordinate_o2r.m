function center_R = coordinate_o2r(dataWindow, center_O)
%% function center_R = coordinate_o2r(dataWindow, center_O)
%% Original Position --> Relative Position
%% Input:
%%         dataWindow: [ rmin rmax cmin cmax ]
%%         center_O:   [ center_O(1) center_O(2) ]
%% Output:
%%         center_R:   [ center_R(1) center_R(2) ]
%%
%% DUT-IIAU-Dong Wang-2010,01,13

center_R    = [ 0 0 ];
center_R(1) = center_O(1) - dataWindow(1) + 1;
center_R(2) = center_O(2) - dataWindow(3) + 1; 