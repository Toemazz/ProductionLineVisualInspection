% FUNCTION: Used to detect cases where the bottle is overfilled
function result = CheckIfBottleOverfilled(image)
    % Convert to greyscale
    image = rgb2gray(image);
    
    % Extract the ROI just over the ideal liquid level in the bottle
    roi = ExtractROI(image, 110, 140, 140, 220);
    
    % Convert to a binary image using a greyscale threshold of '150' 
    roiBinary = imbinarize(roi, double(150/256));
    
    % Calculate the percentage of black pixels in the binary image
    blackPercentage = 100 * (sum(roiBinary(:) == 0) / numel(roiBinary(:)));

    % Fault detected if % black pixels is greater than 40%
    result = blackPercentage > 40; 
end
