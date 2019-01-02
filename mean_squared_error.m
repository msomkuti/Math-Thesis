function error = mean_squared_error(errorImage, compressedImage, num)
    mseSize = size(errorImage) ;  % Get the size of image
    
    if (num == 0)
        % MSE, STATE WHY FASTER THAN CAO
        error = 1/(mseSize(1)*mseSize(2))*sum(sum((errorImage - compressedImage).^2));
    end
    
    if (num == 1)
        % MSE 1 (using norm)
        error = 1/(mseSize(1)*mseSize(2)) * norm((errorImage - compressedImage), 1); %1 norm as error
    end
end