function procIm = preProcessing(Image, gray, resize, contrast)
% Preprocess input image
    procIm = imread(Image);  % Read image data
    
    % Convert to grayscale
    if gray == 1  
         procIm = double(rgb2gray(procIm));
    end
    
    % Equalize contrast
    if contrast == 1
            procIm = histeq(procIm);
    end
    
    procIm = double(imresize(procIm, resize));  % Scale the image
end
