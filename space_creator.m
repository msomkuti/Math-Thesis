function [face_spaces, mean_faces, max_dists, least_likes] = space_creator(training_sets, K)
% Function that built off of setup and some of Cao's code to make a new 
% Original function that is dynamic.

face_spaces = cell(size(training_sets, 1), 1);  % Cell array to hold sub spaces
mean_faces = cell(size(training_sets, 1), 1); % Hold mean faces
num_images = zeros(size(training_sets, 1), 1);  % Hold num ims in each training set
mean_images = cell(size(training_sets, 1), 1);  % Hold mean face images

dims = [73 58];  % All images will be resized to these dims for consistency
plot_count = 1;

num_ts = size(training_sets, 1); % Num of training sets

for i = 1:num_ts
    len = length(training_sets);
    mean_face_image = zeros(73,58);

    im_count = 0;  % Count num training images in each set
    for j = 1:len
        if training_sets(i,j) ~= ""
           im_count = im_count + 1;
        else
            continue
        end
    end
    num_images(i) = im_count;
    S = zeros(dims(1) * dims(2), im_count);  
                                          % Preallocate array to be have
                                          % num rows = dims of images when
                                          % transformed to col vectors and,
                                          % num cols = num of images                                          
    
    s_plot = subplot(size(training_sets, 1), 2, plot_count); 
    
    % Create facespace
    for j = 1:im_count
        fileName = char(training_sets(i,j));  % Read our new image
        tempIm = preProcessing(fileName, 1, dims, 0);
        tempIm = double(svdPartialSum(tempIm, K));  % Compress our images

        mean_face_image = mean_face_image + tempIm;  % Add to mean face image
        
        columnf = tempIm(:);  % Turn image into column vector
       
        % Plot face space
        hold on
        scatter(s_plot,1:length(columnf),columnf, '.'); 
        axis([0 length(columnf) 0 255])
        hold off
        
        S(:,j) = columnf;  % Append our column
    end
    plot_count = plot_count + 1;  % Adv plot indx
    
    fBar = sum(S,2) / im_count; % Calculate the mean face
    mean_faces{i} = fBar;  % Append mean face to cell array
    s = size(S,2);

    fBarMat = repmat(fBar,[1,s]); % Create matrix full of mean face col vectors

    A = S - fBarMat; % Vectorized version of (19) in cao paper
    face_spaces{i} = A;  % Append our face space to set of training images
    
    % Scale mfi by num images in training set and append to set
    mean_images{i} = mean_face_image ./ im_count; 
    
    % Plot mean face for each training set
    s_plot = subplot(size(training_sets, 1),2, plot_count);
    scatter(s_plot,1:length(fBar),fBar, '.'); 
    axis([0 length(columnf) 0 255])
    plot_count = plot_count + 1; % Adv plot indx
end

% Get average faces and display them
for i = 1:num_ts
    mean_face_test = uint8(mean_images{i});
    figure
    imshow(mean_face_test)
    %TITLE THIS HERE
end

max_dists = cell(size(training_sets, 1), 1);  % Max distances
least_likes = cell(size(training_sets, 1), 1); % Least likes

for i = 1:num_ts
    maxDistFromOther = zeros(1, num_images(i));  % Used to find maximum threshhold, hold distances from 
                    % input image to one least like it in the training set
                    
    leastLike = zeros(1, num_images(i)); % For each im in training set, which other im is least like it in the set
    
    for j = 1:num_images(i)
        disp(training_sets)
        fileName = char(training_sets(i,j));
        tempIm = preProcessing(fileName, 1, [73 58], 0);
        tempImComp = double(svdPartialSum(tempIm, K));  % Compress our images
        [~, max_info] = simpleRecognition(face_spaces{i}, K, mean_faces{i}, tempImComp);  % Facial recognition
        max_dist = max_info(1) + mean_squared_error(tempIm, tempImComp, 0); 
        maxDistFromOther(j) = max_dist;
        leastLike(j) = max_info(2);
    end
    max_dists{i} = maxDistFromOther;
    least_likes{i} = leastLike;
end
end