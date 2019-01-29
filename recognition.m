function [min_info, max_info, s_index] = recognition(face_spaces, mean_faces, input_im, K)
% Recognition function 

dist_space = zeros(1, size(face_spaces, 1));
x_mats = cell(size(face_spaces, 1), 1);
X_mats = cell(size(face_spaces, 1), 1);  

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This section of code builds on Lije Cao's code on facial recognition from her
% paper "Singular value decomposition applied to digital image processing."

for i = 1:size(face_spaces, 1)

    colTemp = input_im(:);         % Vectorize input image
    [U,~,~] = svd(face_spaces{i}); % SVD our matrix of faces

    Ur = U(:, 1:K);            % Compressed basis of face space
    X = Ur' * face_spaces{i};  % Coordinate matrix of face space
    size(X)
    f0 = double((colTemp - mean_faces{i}));  %Shift input by mean face
    x = Ur' * f0;        % Find coordinate vector of f0
                         % projected onto basis of face space
                         
    fp = Ur * x;         % Find projection of input onto face space
    ef = norm(f0 - fp);  % Calculate max distance between face and new ones
    
    dist_space(i) = ef;  % Append distance from input to face space
    x_mats{i} = x;       %        coordinate vector of input
    X_mats{i} = X;       %        coordinate maxtix of face space 
end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

[~, s_index] = min(dist_space);  % Find closest face space

% for i = 1:size(face_spaces, 1)  % Uncomment and replace s_index with i 
                                  % and add an end, to check for all 
                                  % face spaces

% Calculate magnitude of distance between input and faces in face space. 
% Take norm of difference between coordinate matrices
D = X_mats{s_index} - x_mats{s_index}*ones(1, size(X_mats{s_index},2));
d = sqrt(diag(D' * D));  

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Plot distances between input image and faces in training set
figure
for i=1:length(d)
    hold on
    plot([0 i],[0 d(i)], '--o') % Plot points and dashed line
    hold off
end
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

[dmin, indx] = min(d);   % dmin is actual distance from face
min_info = [dmin, indx]; % Return the info about the closest match

[dmax, indx] = max(d);  % Find the maximum between input images, and all
                        % other images in the training set

max_info = [dmax, indx];  % Which face in the facespace is most unlike the
                          % match to the input image                      
% end
end
