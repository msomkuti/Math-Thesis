function [min_info, max_info] = simpleRecognition(A, K, fBar, input_im)
% NEED TO IMPROVE THIS AND CITE CAO
colTemp = input_im(:); % This is the image we will check to see if in the set

[U,~,~] = svd(A); % SVD our matrix of faces, ERROR THAT MATRIX IS TOO BIG

Ur = U(:, 1:K);
X = Ur' * A;
f0 = double((colTemp - fBar));
x = Ur' * f0;  % Equation 23 in Cao
fp = Ur * x;  % Projection of f - fbar onto face space
ef = norm(f0 - fp);  % Calculate max distance between face and new ones
e0 = 300;  % Max distance a tempIm can be from a face for it to be a match
            % MAKE THIS DYNAMIC
            
% SPLIT FUNCTION HERE, RETURN ef for all training sets and take minimum
% THEN CONTINUE TO RECOGNITION WITH MINIMUM DISTANCE FIRST

D = X - x*ones(1, size(X,2));
d = sqrt(diag(D' * D));
[dmin, indx] = min(d);  % dmin is actual distance from face
min_info = [dmin, indx]; % Return the info about the closest match

if dmin < e0
%      fprintf(['The image is face#',num2str(indx),' ef = ',num2str(ef), ' dmin = ', num2str(dmin)])
end
        
[dmax, indx] = max(d);  % Find the maximum between input images, and all
                        % other images in the training set
                        
max_info = [dmax, indx];  % Which face in the facespace is most unlike the
                         % match to the input image
end
