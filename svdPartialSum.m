function AK = svdPartialSum(A,K)
% CITE CAO
A = double(A);                       % Convert image data
[u,s,v]=svd(A);                      % Perform SVD 

AK = u(:,1:K)*s(1:K,1:K)*v(:,1:K)';  % Compression takes place
                                     % Cutting off r - k singular values
                                     % U and V' scaled as well
                                    
% Histogram the image's singular values                                  
s1= s(1:K,1:K);
s2 = s1(:);
n = size(s2,1);
singValues = [];  % Array of singular values
for i = 1:n
    if s2(i) ~= 0
        singValues = [singValues; s2(i)];
    end
end
numBins = size(singValues,1);

% figure; hist(singValues,numBins); % Display histogram

AK = uint8(AK);     % Convert back to the image data
% figure; imshow(AK)  % Display the converted image
end