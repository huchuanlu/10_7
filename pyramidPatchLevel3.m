function patchParam = pyramidPatchLevel3(targetWindow, dataWindow)
%% function patchParam = pyramidPatchLevel3(targetWindow, dataWindow)
%% 
%% Input:
%%          targetWindow = [ targetWindow(1) targetWindow(2)
%%                           targetWindow(3) targetWindow(4) ];
%%          dataWindow = [ dataWindow(1) dataWindow(2)
%%                         dataWindow(3) dataWindow(4) ];
%% Output:
%%          patchParam 
%%
%% DUT-IIAU-Dong Wang-2010,01,13
%%
rMin = targetWindow(1) - dataWindow(1) + 1;
rMax = targetWindow(2) - dataWindow(1) + 1;
cMin = targetWindow(3) - dataWindow(3) + 1;
cMax = targetWindow(4) - dataWindow(3) + 1;

patchParam = [];

rPatchNum  = 4;                         
cPatchNum  = 4;                        
rSize      = rMax - rMin + 1;             
cSize      = cMax - cMin + 1;        
rInterval  = round(rSize/rPatchNum);    
cInterval  = round(cSize/cPatchNum);    

%% Mesh Parameters
rGridParam = zeros(1,rPatchNum+1);  
rGridParam(1) = rMin;
for ii = 2:rPatchNum
    rGridParam(ii) = rMin + (ii-1)*rInterval; 
end
rGridParam(rPatchNum+1) = rMax;

cGridParam = zeros(1,cPatchNum+1);  
cGridParam(1) = cMin;
for ii = 2:cPatchNum
    cGridParam(ii) = cMin + (ii-1)*cInterval; 
end
cGridParam(cPatchNum+1) = cMax;

%% First Level
patchParam.level_0 = zeros(rPatchNum*cPatchNum, 4);
for rr = 1:rPatchNum
    for cc = 1:cPatchNum
        num   = (rr-1)*cPatchNum+cc;
        patchParam.level_0(num,1) = rGridParam(rr);
        patchParam.level_0(num,2) = rGridParam(rr+1);
        patchParam.level_0(num,3) = cGridParam (cc);
        patchParam.level_0(num,4) = cGridParam (cc+1);
    end
end

%% Second Level
rGridParam = rGridParam(1:2:end);
cGridParam = cGridParam(1:2:end);
rPatchNum = rPatchNum/2;
cPatchNum = cPatchNum/2;
patchParam.level_1 = zeros(rPatchNum*cPatchNum, 4);
for rr = 1:rPatchNum
    for cc = 1:cPatchNum
        num   = (rr-1)*cPatchNum+cc;
        patchParam.level_1(num,1) = rGridParam(rr);
        patchParam.level_1(num,2) = rGridParam(rr+1);
        patchParam.level_1(num,3) = cGridParam (cc);
        patchParam.level_1(num,4) = cGridParam (cc+1);
    end
end

%% Third Level
rGridParam = rGridParam(1:2:end);
cGridParam = cGridParam(1:2:end);
rPatchNum = rPatchNum/2;
cPatchNum = cPatchNum/2;
patchParam.level_2 = zeros(rPatchNum*cPatchNum, 4);
for rr = 1:rPatchNum
    for cc = 1:cPatchNum
        num   = (rr-1)*cPatchNum+cc;
        patchParam.level_2(num,1) = rGridParam(rr);
        patchParam.level_2(num,2) = rGridParam(rr+1);
        patchParam.level_2(num,3) = cGridParam (cc);
        patchParam.level_2(num,4) = cGridParam (cc+1);
    end
end

%% Weights for different Level
patchParam.weightLevel_0 = 0.5;
patchParam.weightLevel_1 = 0.25;
patchParam.weightLevel_2 = 0.25;

