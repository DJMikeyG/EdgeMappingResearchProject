function [fullPath,newFolderName] = trimData(fullPath,workingFolder,catName, newFolderName, dataSize)
    
    p = strcat(fullPath,"\",workingFolder,"\",catName);
    direct = dir(p);
    
    if(direct(1).name == "." && direct(2).name == "..")
        direct = direct(4:end);
    end
    
    if numel(direct) > dataSize %more than specified images
        idx = randi(numel(direct),[dataSize,1]);
    else
        idx = 1:numel(direct); %less than specified images
    end
    
    %rewrite max # data to new file
    for i = 1:numel(idx)
        data = imread(strcat(direct(idx(i)).folder,"\",direct(idx(i)).name));
        
        %"D:\Michael Gross\Documents\MAT499 Images\, Training Data\, catName, FileName###.png
        imwrite(data,strcat(fullPath,newFolderName,"\",catName,"\",catName,string(i),".png")) 
    end
end

