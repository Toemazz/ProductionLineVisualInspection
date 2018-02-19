% FUNCTION: Used to detect cases where the center bottle is missing
function result = CheckIfBottleMissing(image)
    % Convert to greyscale
    image = rgb2gray(image);
    
    % Extract the ROI including the top of the label
    roi = ExtractROI(image, 1, 135, 250, 225);
    
    % Convert to a binary image using a greyscale threshold of '150' 
    roiBinary = imbinarize(roi, double(150/256));
    
    % Calculate the percentage of black pixels in the binary image
    blackPercentage = 100 * (sum(roiBinary(:) == 0) / numel(roiBinary(:)));
    
    % Center bottle missing if % black pixels is less than 20%
    result = blackPercentage < 10;
end
