function procIm = preProcessing(Image, gray, resize, contrast)
% Preprocessing done for almost all images

    procIm = imread(Image);
    
    if gray == 1  % convert to grayscale if necessary
         procIm = double(rgb2gray(procIm));
    end
    
    if contrast == 1
            procIm = histeq(procIm);
    end
    
    procIm = double(imresize(procIm, resize));  % scale image
end