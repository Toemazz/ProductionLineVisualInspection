% FUNCTION: Used to detect cases where the label is not printed
function result = CheckIfLabelNotPrinted(image)
    % Convert to greyscale
    image = rgb2gray(image);
    
    % Extract the ROI for the label
    roi = ExtractROI(image, 180, 110, 280, 240);
    
    % Convert to a binary image using a greyscale threshold of '150' 
    roiBinary = imbinarize(roi, double(150/256));

    % Calculate the percentage of black pixels in the binary image
    blackPercentage = 100 * (sum(roiBinary(:) == 0) / numel(roiBinary(:)));
    
    % Fault detected if % black pixels is less than 50%
    result = blackPercentage < 50;
end
