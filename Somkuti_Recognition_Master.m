% Master Facial Recognition Script
% Michael Somkuti

% Find and set up our training sets
% Would improve by also returning array of original image sizes
training_sets = setup();
dims = [73 58];  % Default image dimensions
K = 20;          % Number of sing values

% Create face spaces and find each respective one's mean face
% Compression also occurs
% Would improve by making preprocessing only happen once
[face_spaces, mean_faces, max_dists, least_likes] = space_creator(training_sets, K, dims); 

% Facial recognition
new = 'zzzz.JPG';                               % Set input image
new = preProcessing(new, 1, dims, 0);           % Preprocess
input_image = double(svdPartialSum(new, K));    % Compress
MSE = mean_squared_error(new, input_image, 0);  % Gauge error 


% Perform recognition
[min_info, max_info, s_index] = recognition(face_spaces, mean_faces, input_image, K);

% Calculate confidence of match
% Ratio of distance(input to match) / distance(match to furthest in set)
distance_ratio = min_info(1) / max_dists{s_index}(min_info(2)); 
confidence = (1 - distance_ratio) * 100;

% Find file name of match and image least like / furthest from the match
[~,name,~] = fileparts(training_sets{s_index, min_info(2)});
least_like = least_likes{s_index}(min_info(2));  % Index of furthest image
[~,furthest_name,~] = fileparts(training_sets{s_index,least_like});

% Ouput results
fprintf(['The input was matched with -> ', name, ' <- \nThe match has a confidence of ', num2str(confidence), '%%.\n'])
fprintf(['The input is least similar to -> ', furthest_name, ' <- \n'])
