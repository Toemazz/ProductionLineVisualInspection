% FUNCTION: Used to detect cases where the label is not straight
function result = CheckIfLabelNotStraight(image)
    % Convert to greyscale
    image = rgb2gray(image);
    image = imadjust(image);
 
    % Extract the ROI for the top of the bottle label
    roiHorizontal = ExtractROI(image, 170, 110, 195, 250);
    
    % Carry out edge detection on the ROI
    [~, t] = edge(roiHorizontal, 'Sobel');
    roiEdge = edge(roiHorizontal, t*0.75);
    
    % Find connected components and get info 'measurements' about each one
    cc = bwconncomp(roiEdge);
    measurements = regionprops(cc, 'BoundingBox'); 
    maxWidth = 0; maxHeight = 0;
   
    % Loop over all bounding boxes discovered
    for k = 1 : length(measurements)
        BB = measurements(k).BoundingBox;
        
        % Calculate the 'maxWidth' of all bounding boxes
        if BB(3) > maxWidth
            maxWidth = BB(3);
        end
        
        % Calculate the 'maxHeight' of all bounding boxes
        if BB(4) > maxHeight
            maxHeight = BB(4);
        end
    end
    
    % Extract the ROI for the top half of the label
    roiLabel = ExtractROI(image, 180, 110, 230, 250);
    
    % Convert ROI to binary using a greyscale threshold of '50'
    roiLabelBinary = imbinarize(roiLabel, double(50/256));
    
    % Calculate the % of black pixels in the ROI
    blackPercentage = 100 * (sum(roiLabelBinary(:) == 0) / numel(roiLabelBinary(:)));
    
    % Condition 01: Check if the (white) horizontal line (at the top of the
    % label) is within limits
    horizontalResult = maxWidth <= 100 || maxHeight >= 10;
    
    % Condition 02: Check the # of black pixels on the label
    blackPercentageResult = blackPercentage >= 13;
    
    result = horizontalResult && blackPercentageResult;
end
