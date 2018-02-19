% FUNCTION: Used to detect cases where the bottle cap is missing
function result = CheckIfBottleCapMissing(image)
    % Convert to greyscale
    image = rgb2gray(image);
    
    % Extract the ROI for the bottle cap 
    roi = ExtractROI(image, 5, 150, 45, 200);
    
    % Convert to a binary image using a greyscale threshold of '150' 
    roiBinary = imbinarize(roi, double(150/256));

    % Calculate the percentage of black pixels in the binary image
    blackPercentage = 100 * (sum(roiBinary(:) == 0) / numel(roiBinary(:)));
    
    % Fault detected if % black pixels is less than 25%
    result = blackPercentage < 25;
end
