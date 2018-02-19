% FUNCTION: Used to detect cases where the bottle is underfilled
function result = CheckIfBottleUnderfilled(image)
    % Convert to greyscale
    image = rgb2gray(image);
    
    % Extract the ROI just under the ideal liquid level in the bottle
    roi = ExtractROI(image, 130, 140, 170, 220);
    
    % Convert to a binary image using a greyscale threshold of '150' 
    roiBinary = imbinarize(roi, double(150/256));
    
    % Calculate the percentage of black pixels in the binary image
    blackPercentage = 100 * (sum(roiBinary(:) == 0) / numel(roiBinary(:)));

    % Fault detected if % black pixels is less than 25%
    result = blackPercentage < 25;
end
