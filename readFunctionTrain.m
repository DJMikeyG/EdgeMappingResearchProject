function I = readFunctionTrain(filename,varargin)
    % Resize the flowers images to the size required by the network.

    if (nargin == 1)
        I = imread(filename);
    else
        I = varargin{1};
    end
    
    I = imresize(I, [227 227]);

    if (nargin == 1)
    I = edge(im2gray(I), 'prewitt');
    end
    
    I = cat(3,I,I,I)*255;
    
