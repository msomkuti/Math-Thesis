function [min_info, max_info] = simpleRecognition(A, K, fBar, input_im)
% CITE CAO
% Would improve by implementing e0 --> max distance a face can be

colTemp = input_im(:); % Vectorize input image

[U,~,~] = svd(A); % SVD our matrix of faces

Ur = U(:, 1:K);
X = Ur' * A;
f0 = double((colTemp - fBar));
x = Ur' * f0;        % Equation 23 in Cao
fp = Ur * x;         % Projection of f - fbar onto face space
% ef = norm(f0 - fp);  % Calculate max distance between face and new ones

D = X - x*ones(1, size(X,2));
d = sqrt(diag(D' * D));
[dmin, indx] = min(d);   % dmin is actual distance from face
min_info = [dmin, indx]; % Return the info about the closest match

[dmax, indx] = max(d);  % Find the maximum between input images, and all
                        % other images in the training set
                        
max_info = [dmax, indx];  % Which face in the facespace is most unlike the
                          % match to the input image
end
