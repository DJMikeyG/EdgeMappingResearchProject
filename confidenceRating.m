function [predictedLabel, confidence, accuracy] = confidenceRating(functionName,myNet,testImages,varargin)
    %% Test Network Performance
    if(nargin==3)
        testImages.ReadFcn = functionName;
    end

    [predictedLabel,confidence] = classify(myNet, testImages);
    
    if(nargin==3)
        accuracy = mean(predictedLabel == testImages.Label);
    else
        accuracy = mean(predictedLabel == varargin{1});
    end
end

