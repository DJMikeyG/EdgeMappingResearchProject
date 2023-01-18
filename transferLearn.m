function [myNet, testImages] = transferLearn(parentFolderName,numLayers)
    
    % Load Training Images
    allImages = imageDatastore(parentFolderName, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
    
    
    % Split data into training and test sets 
    [trainingImages, testImages] = splitEachLabel(allImages, 0.99, 'randomize');
     
    % Load Pre-trained Network (AlexNet)
    alex = alexnet; 
    
    % Review Network Architecture 
    layers = alex.Layers;
    
    % Modify Pre-trained Network 

    layers(23) = fullyConnectedLayer(numLayers); % change this based on # of classes
    layers(25) = classificationLayer;

    % Perform Transfer Learning
    opts = trainingOptions('sgdm', 'InitialLearnRate', 0.0001, 'MaxEpochs', 100, 'MiniBatchSize', 64, 'Plots','training-progress','ValidationFrequency',50);
    
    % Set custom read function 
    trainingImages.ReadFcn = @readFunctionTrain;
    
    % Train the Network 
    myNet = trainNetwork(trainingImages, layers, opts);
end