function success = xPort(fileName, results, header, include)  
    
    %trim data
    results = results(:,include);
    header = header(include);

    %convert    
    tblRaw = cell2table(results,"VariableNames",header);
    sheetName = string(datetime('now','TimeZone','local','Format','d_MMM_y_HH_mm_ss'));
    
    %export
    writecell(results,fileName)
    
    open(fileName)
    %clear("column","row","i","j","sheetName")
end


