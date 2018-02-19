% FUNCTION: Used to detect cases where the label is missing
function result = CheckIfLabelMissing(image)
    % Convert to greyscale
    image = rgb2gray(image);
    
    % Extract the ROI for the label
    roi = ExtractROI(image, 180, 110, 280, 240);
    
    % Convert to a binary image using a greyscale threshold of '50' 
    roiBinary = imbinarize(roi, double(50/256));
    
    % Calculate the percentage of black pixels in the binary image
    blackPercentage = 100 * (sum(roiBinary(:) == 0) / numel(roiBinary(:)));
    
    % Fault detected if % black pixels is greater than 50%
    result = blackPercentage > 50;
end
