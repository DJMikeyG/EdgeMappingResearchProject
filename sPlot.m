function sPlot(label,iM_RGB,iM_BW, opL, results) %image (label,RGB, BW), operator labels, and results
    subR = 1+size(opL,2); %subplot rows (3 op = 4 rows)
    subC = 5; %subplot columns

    %Show original Image
    subplot(subR,subC,1)
    imshow(iM_RGB)
    
    %Title
    sgtitle(label + ": Edge Mapping Analysis");

    
    %Show B/W image
    subplot(subR,subC,2)
    imshow(uint8(iM_BW))
    
    %Show time Elapsed
    subplot(subR,subC,3)
    Y = cell2mat(results(1:subR-1,10).');
    base = min(Y)-range(Y)/size(opL,2);
  
    %X = cell2mat(op{1:subR-1});
    X = opL;

    b = bar(Y,'BaseValue', base); title("Elapsed Time(sec)");
    %text(b.XEndPoints,b.YEndPoints,string(b.YData),'HorizontalAlignment','center','VerticalAlignment','bottom')
    set(gca, 'XTickLabel',X, 'XTick',1:numel(X))
    
    %Edgemap Images
    eM_labels = ["Horizontal Edgemap", "Vertical Edgemap", "Gradient"];
    for j = 1:size(opL,2) % each operator row
        for k = 1:3 % each category column (x,y,grad)

            subplot(subR,subC,(subC*j)+k)
            imshow(results{j,k+6}); 
            title(opL(j) + " " + eM_labels(k));

        end
    end

    % Histogram for Pixel intensity distribution
    %original image
    subplot(subR,subC,4)
    histogram(iM_BW); 
    %each operator
    for  m = 1:size(opL,2) % each operator row
            subplot(subR,subC,(subC*m)+4)
            histogram(results{m,9}); 
            title(opL(m) + " Pixel Freq.");
    end

    % Histogram for ML confidence Rating
    idx = [];
    for i = 1:subR*subC
        if mod(i,subC)==0
            idx = [idx,i];
        end
    end
    subplot(subR,subC,idx)

    data = cell2mat(results(1:subR,12))*100;  
    base = min(data)-range(data)/numel(data);
    bar(data,'BaseValue', base); title("Object Recognition Confidence Rating (%)");
    set(gca, 'XTickLabel',["B/W", X], 'XTick',1:numel(X)+1)

end