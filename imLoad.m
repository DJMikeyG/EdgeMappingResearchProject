function [Count, label, iM] = imLoad(dirPath,cat)
    
    %Direct to folder holding images
    direct = dir(dirPath);
    
    direct = direct(4:end,:);
    Count = size(direct,1);

    %Initialize struct for holding images
    iM = strings(1,Count);
    label = [];
    
    % Import Images
    for c = 1:Count
        iM(c) = direct(c,:).(genvarname(cat));
        temp = iM{c};
        label = [label, string(temp(1:end-4))];  %remove file extension for labeling
    end
    
    iM= strcat(cd,"\",dirPath, "\", iM); %re-add file path
end
