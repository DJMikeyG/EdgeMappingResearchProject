% MICHAEL GROSS
% FALL 2022
% MAT 499

%% Setup Workspace

clear,clc
format compact
path_init();

% exist RESTOREDEFAULTPATH_EXECUTED var
% if(~ans) 
%     restoredefaultpath 
% end
% clc,clear ans

%% Setup Struct for Matrix Operators

mtrxOp.label = ["Prewitt", "Sobel", "Roberts Cross"];
mtrxOp.x = {([1,0,-1; 1,0,-1; 1,0,-1])
            ([-1,0,1;-2,0,2;-1,0,1])
            ([1,0;0,-1])};
mtrxOp.x = mtrxOp.x.';

mtrxOp.y = {([1,1,1; 0,0,0 ; -1,-1,-1])
            ([1,2,1;0,0,0;-1,-2,-1])
            ([0,-1;1,0])};
mtrxOp.y = mtrxOp.y.';

%% Apply Operators

%Initialize struct for image data
[iM.Count, iM.label, iM.path] = imLoad('EM Images', 'name');

% Create struct for holding results
iM.BW=[];
iM.RGB =[];

results=[];
results.raw={};
% Edgemapping Function for each image and operator combination
for n = 1: iM.Count % number of images
    data.temp={};
    for k = 1:size(mtrxOp.label,2) % number of matrix operators
        R = eMap(iM.label{n}, iM.path{n},mtrxOp.label{k},mtrxOp.x{k}, mtrxOp.y{k}, true, [227 227]);
        data.temp = [data.temp; R]; % storing data for each image
        results.raw = [results.raw; R]; %storing all data
    end
    results.(genvarname(iM.label{n})) = data.temp;
    iM.RGB = [iM.RGB, data.temp(1,1)];
    iM.BW = [iM.BW, data.temp(1,6)];
    
end
clear("k","n","R","data")

%% Object Detection Training

%Run training data if it doesn't already exist
oD.parentPath = "D:\Michael Gross\Documents\MAT499 Images\";
oD.oldPath = "Raw Images";
oD.newPath = "Training Data";
oD.catNames = ["bicycle","car", "pedestrian","street sign","trailer truck"];

oD.pAdd = oD.parentPath + [oD.oldPath; oD.newPath] + "\" + oD.catNames;
for i = 1:numel(oD.pAdd)
    addpath(oD.pAdd{i})
end

if(~(exist("myNet.mat", "file")>0))
    [oD.catCount] = imLoad(oD.parentPath + oD.oldPath, 'folder');
    
    for i = 1:numel(oD.catNames)
        [oD.parentPath,oD.newPath] = trimData(oD.parentPath, oD.oldPath ,oD.catNames(i), oD.newPath, 5000);
    end

    [oD.myNet, oD.testiM]  = transferLearn(oD.parentPath + oD.newPath, oD.catCount);
    
    myNet = oD.myNet;
    save("myNet.mat", "myNet");
else
    oD.myNet = load("myNet.mat","myNet");
end

clear i
%% Test/Record Confidence Rating

% oD.store = imageDatastore("EMaps\",'IncludeSubfolders', true, 'LabelSource', 'foldernames');
% oD.labCount = countEachLabel(oD.store);
% for c = 1:oD.catCount
%     oD.split{c} = splitEachLabel(oD.store,sum(oD.store.Labels==oD.catNames(c)),"Include",oD.catNames(c));
% end
idx = 1;
for i = 1:numel(oD.catNames)
    if i==1
        oD.conRat = [];
        oD.reSize = [];
    end
    oD.eMiM = [results.(genvarname(iM.label{i}))(1,6); results.(genvarname(iM.label{i}))(1:numel(mtrxOp.x),9)]; %BW + Gradient Images

    for j = 1:numel(oD.eMiM)
        imwrite(oD.eMiM{j},strcat("ExportedPictures\EMaps\",iM.label(i),string(j),".png"))

        [temp_predictedLabel, temp_confidence, temp_accuracy]  = confidenceRating(@readFunctionTrain, oD.myNet.myNet, readFunctionTrain("",oD.eMiM{j}), oD.catNames(i));
        results.(genvarname(iM.label{i}))(j,11:13) = [{string(temp_predictedLabel)},{max(temp_confidence)},{temp_accuracy}];
        if j > 1
            results.raw(idx,11:13) = [{string(temp_predictedLabel)},{max(temp_confidence)},{temp_accuracy}];
            idx = idx+1;
        end
    end
    
%     oD.reSize = readFunctionTrain("",oD.eMiM);
    clear temp_predictedLabel temp_confidence temp_accuracy
end
clear i c j 

%% Plot subplot results
% passes in results for each image
for m = 1:iM.Count
    sPlot(iM.label{m}, iM.RGB{m}, iM.BW{m}, mtrxOp.label, results.(genvarname(iM.label{m}))); %passes in image (label,RGB, BW), operator labels, and results
    pause
end
clear m

%% Save data

results.header = ["Original Image", "Width","Height","Total Size","Operator","B/W Image","Horizontal Gradient","Vertical Gradient","EMap Gradient","Time","Classification","Confidence Rating","Correct"];

save finalResults.mat
%images cannot export to excel, save instead

% for m = 1:iM.Count
%     locations = [{[1,1]},{[1,9]},{[2,9]},{[3,9]}]; %BW + Grad Image result Locations
%     
%     imDownload(results.(genvarname(iM.label{m})), iM.label{m},locations, "ExportedImages")
% end

xPort("EdgeMapResults.xlsx", results.raw, results.header, [2:5,10:13])