%% Edgemapping Function Definition

% Arguments: Color Image, X direction Operator, Y direction Operator
% Return: Time elapsed, B/W image, Edgemap Image
function R = eMap(iMLabel, iM, opLabel, opX, opY, printOut,outSize)
    % Read Images, Resize, and Convert to B/W
    M = imread(iM);
    M = imresize(M, outSize);
    %Grayscale image and convert to double
    M_BW=double(im2gray(M));
    
    % use for loops to apply the operators given above to build two edge maps (Horizontal + Vertical)

    % Initialize Edge matrixes to size of original image
    edge_h = zeros(size(M_BW));
    edge_v = zeros(size(M_BW));
    range = size(opX,1) - 2; % change depending on 2x2(0) or 3x3(1)

    tic
        % Apply matrix operator at every 3x3 array of M_gray
        for i = 2:size(M_BW, 1) - range
            for j = 2:size(M_BW, 2) - range
        
                % Matrix Element-Wise Convolution
                edge_h(i,j) = abs(sum(sum(opX .* M_BW(i-1:i+range, j-1:j+range))) );
                edge_v(i,j) = abs(sum(sum(opY .* M_BW(i-1:i+range, j-1:j+range))) );
      
            end
        end
    
    % Record Time for each operator
    tRun = toc;
    
    clear('i','j')

    % Gradient of H and V
    M_EM = sqrt(edge_h.^2 + edge_v.^2);
    
    [w,h] = size(M_BW); %width and height
    tS = w*h; % total size

    if(printOut) 
        fprintf("Run Time: %s with %s Operator: %f sec\n",iMLabel,opLabel,tRun)
    end
    R = [{M},w,h,tS,opLabel,{uint8(M_BW)},{uint8(edge_h)},{uint8(edge_v)},{uint8(M_EM)},tRun];

end