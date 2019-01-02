function [min_info, max_info, s_index] = recognition(face_spaces, mean_faces, input_im, K, max_dists, least_likes)
% NEED TO IMPROVE THIS AND CITE CAO

dist_space = zeros(1, size(face_spaces, 1));
e_zero =  zeros(1, size(face_spaces, 1));  % FIX THIS
x_mats = cell(size(face_spaces, 1), 1);
X_mats = cell(size(face_spaces, 1), 1);  

for i = 1:size(face_spaces, 1)

    colTemp = input_im(:); % This is the image we will check to see if in the set
    [U,~,~] = svd(face_spaces{i}); % SVD our matrix of faces, ERROR THAT MATRIX IS TOO BIG

    Ur = U(:, 1:K);
    X = Ur' * face_spaces{i};
    
    f0 = double((colTemp - mean_faces{i}));
    x = Ur' * f0;  % Equation 23 in Cao
    fp = Ur * x;  % Projection of f - fbar onto face space
    
    ef = norm(f0 - fp);  % Calculate max distance between face and new ones
    
    dist_space(i) = ef;
    x_mats{i} = x;
    X_mats{i} = X; 
end

[dist, s_index] = min(dist_space);  % Find closest face space

e0 = 300;  % Max distance a tempIm can be from a face for it to be a match
           % MAKE THIS DYNAMIC

% for i = 1:size(face_spaces, 1)  % Uncomment and replace s_index with i 
                                  % and add an end, to check for all 
                                  % face spaces

D = X_mats{s_index} - x_mats{s_index}*ones(1, size(X_mats{s_index},2));
d = sqrt(diag(D' * D));  % THIS IS TAKING EUCLIDEAN DISTANCE IN RELATION TO INPUT FACE

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Plot distances between input image and faces in training set
figure
for i=1:length(d)
    hold on
    plot([0 i],[0 d(i)], '--o') % Plot points and dashed line
    hold off
end
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


[dmin, indx] = min(d);  % dmin is actual distance from face
min_info = [dmin, indx]; % Return the info about the closest match

if dmin < 10000  % CHANGE THIS
%      fprintf(['The image is face#',num2str(indx),' ef = ',num2str(ef), ' dmin = ', num2str(dmin)])
end

[dmax, indx] = max(d);  % Find the maximum between input images, and all
                        % other images in the training set

max_info = [dmax, indx];  % Which face in the facespace is most unlike the
                          % match to the input image                      
% end
end
