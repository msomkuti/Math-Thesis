% Master Facial Recognition Script
% THIS IS MY BEST SCRIPT!!!

% Find and set up our training sets
training_sets = setup(); % ALSO RETURN ORIGINAL SIZE OF IMAGES

% Create our face spaces and find each respective one's mean face, compress
K = 58;  % Number of sing values
[face_spaces, mean_faces, max_dists, least_likes] = space_creator(training_sets, K); 

% SET INPUT IMAGE
new = 'liam.JPG';
new = preProcessing(new, 1, [73 58], 0);
input_image = double(svdPartialSum(new, K));  % Compress our images
[min_info, max_info, s_index] = recognition(face_spaces, mean_faces, input_image, K, max_dists, least_likes);

% Results
relation_to_furthest = min_info(1) / max_dists{s_index}(min_info(2)); 
confidence = (1 - relation_to_furthest) * 100;  % Calc confidence of match
[~,name,~] = fileparts(training_sets{s_index, min_info(2)}); % Get match name
least_like = least_likes{s_index}(min_info(2));
[~,furthest,~] = fileparts(training_sets{s_index,least_like}); % Get match name

fprintf(['The input was matched with -> ', name, ' <- \nThe match has a confidence of ', num2str(confidence), '%%.\n'])
fprintf(['The input is least similar to -> ', furthest, ' <- \n'])
