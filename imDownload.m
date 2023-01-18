function imDownload(data,iMLabel ,location, pathName)
    iM = {};
    if(exist(path,"file"))
        delete(fullFileName);
    end
    for i = 1:numel(location)
        iM = {iM; data(location{i})};
    end
    for j = 1:numel(iM)
        imwrite(data, strcat(pathName,"\",iMLabel, j, ".png"))
    end
end

