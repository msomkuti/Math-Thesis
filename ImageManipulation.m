% 10/31/2018
% Original exploration for thesis

% I3 = 'eric.jpg'; %Import the image

% whos I %See how image data is stored in the workplace

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Contrast Adjustment, Resizing an image

% figure; imhist(I); %View histogram of color values of image

%I2 = preProcessing(I2, 0, 0.9, 1); %Improve the contrast, resize the image
% figure; imshow(I2);
% figure; imhist(I2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grayscale an image, Saving an image

%  I3 = preProcessing(I3, 1, 1, 0); %grayscale our original image
% imwrite(I3,'ericg.jpg')
% figure; imshow(I3); I3; %calling an image will show its value 

% I3 = I3 * 2.5; %able to affect the values of the image directly
% imshow(I3);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Compression

%  oSize = size(I3,2);
%  K = 120; %The # of sing. values to be used, rank of compressed img
%  compressedImage = double(svdPartialSum(I3, K)); %compress our image using SVD


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculating Error

% Cao writes her own function for mean squared error(MSE), but there is also one 
% built into matlab

%  errorImage = double(I3);
%  MSE = immse(compressedImage,I3) % built in Matlab function

% MSE = mean_squared_error(errorImage, compressedImage, 0);

                                          
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate our compression ratio

% original = imfinfo(I3);  % Original gray scaled image
% osize = original.FileSize;  % Size of original

% compressed = imfinfo('compressed.jpg');  % Compressed version
% csize = compressed.FileSize;  % Size of compressed 

% comp_ratio = csize / osize;  % Calculate compression ratio


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simple SVD Facial Recognition
% FIRST WE WILL USE THE MAP FROM CAO's PAPER TO BUILD OWN CODE(Pg.6)

% Find our training set
% images = dir('*/*.jpg'); %find all of our training images in subfolder

images = dir('*.jpg');
numImages = length(images);
dims = [73 58];  % All images will be resized to these dims for consistency
S = zeros(dims(1) * dims(2), numImages-1);  % Preallocate array to be have
                                          % num rows = dims of images when
                                          % transformed to col vectors and,
                                          % num cols = num of images

% Create our facespace
for i = 1:numImages - 1
    fileName = images(i).name;  % Read our new image
    tempIm = preProcessing(fileName, 1, dims, 0);
    K = 50;
    tempIm = double(svdPartialSum(tempIm, K));  % Compress our images
    columnf = tempIm(:);  % Turn image into column vector
    S(:,i) = columnf;  % Append our column
end
    
fBar = sum(S,2) / numImages; % calculate the mean face

s = size(S,2); % size of S

fBarMat = repmat(fBar,[1,s]); % create matrix full of mean face col vectors

A = S - fBarMat; % vectorized version of (19) in cao paper

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simple recognition in set
% ADDED ON: FINDING MAX DISTANCE

images = dir('*.jpg');
numImages = length(images);

maxDistFromTraining = zeros(1, numImages);  % Used to find maximum threshhold, hold distances from 
                    % input image to one least like it in the training set
                    
leastLike = zeros(1, numImages); % For each im in training set, which other im is least like it in the set
for i = 1:numImages - 1
    fileName = images(i).name;  %Read our new image
    tempIm = preProcessing(fileName, 1, [73 58], 0);
    K = 50;
    tempImComp = double(svdPartialSum(tempIm, K));  % Compress our images
    [~, max_info] = simpleRecognition(A, K, fBar, tempImComp);  % Facial recognition
    max_dist = max_info(1) + mean_squared_error(tempIm, tempImComp, 0);  % Should I add mse??
    maxDistFromTraining(i) = max_dist;
    leastLike(i) = max_info(2);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% What is the maximum distance that is possible to be in the training set?

new = 'kris.JPG'
new = preProcessing(new, 1, [73 58], 0);
K = 50;
newImComp = double(svdPartialSum(new, K));  % Compress our images
min_info = simpleRecognition(A, K, fBar, newImComp);  % Facial recognition


% Relationship between distance from input image to match, and 
% distance between match and image least like it
relation_to_furthest = min_info(1) / maxDistFromTraining(min_info(2)); 
confidence = (1 - relation_to_furthest) * 100;  % Calc confidence of match

match = images(min_info(2)).name;
furthest = images(leastLike(min_info(2))).name;
% match_name = strtok(match,'.jpg')  % erase .jpg from filename

% Print our match and percent confidence
fprintf(['The input was matched with -> ', match, ' <- \nThe match has a confidence of ', num2str(confidence), '%%.\n'])
fprintf(['The input is least similar to ', furthest, '\n'])  % COULD I ADD SOMETHING HERE FOR FURTHEST
