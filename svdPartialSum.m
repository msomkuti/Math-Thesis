function AK = svdPartialSum(A,K)
A = double(A); % here we convert our grayscale values in double ints
[u,s,v]=svd(A); % perform our svd and output it into the 3 matrices
AK = u(:,1:K)*s(1:K,1:K)*v(:,1:K)'; % compression takes place
                                     % here we are cutting off the smallest
                                     % sv's, while also ensuring that our
                                     % matrices are of the correct
                                     % dimension

                                     
% HISTOGRAM OUR SING VALUES FOR THE IMAGE                                    
s1= s(1:K,1:K);
s2 = s1(:);
n = size(s2,1);
singValues = [];
for i = 1:n
    if s2(i) ~= 0
        singValues = [singValues; s2(i)];
    end
end
numBins = size(singValues,1);
% hist(singValues,numBins)  % histogram sing values
%END HISTOGRAM
% figure
AK = uint8(AK);  % convert our array back into the image format
% imshow(AK)
% figure; imshow(AK)  % display the converted image
end