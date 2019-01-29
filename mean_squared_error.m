function error = mean_squared_error(originalImage, compressedImage, num)
% Original function
% This function calculates Mean Squared Error through 2 different approaches    
mseSize = size(originalImage) ;  % Size of image    
   
% Vectorized version of vanilla Mean Squared Error
if (num == 0)
    error = 1/(mseSize(1)*mseSize(2))*sum(sum((originalImage - compressedImage).^2));
end

% Vectorized version of Mean Squared Error utilizing the 1-Norm
if (num == 1)
    error = 1/(mseSize(1)*mseSize(2)) * norm((originalImage - compressedImage), 1);
end
end
