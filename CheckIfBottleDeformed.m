% FUNCTION: Used to detect cases where the bottle is deformed
function result = CheckIfBottleDeformed(image)
    % Extract the red channel and apply contrast adjustment
    imageR = image(:, :, 1);
    imageR = imadjust(imageR);
    
    % Extract the ROI of the label area on the bottle
    roiR = ExtractROI(imageR, 190, 100, 280, 260);

    % Binarize the red channel using a greyscale threshold of '200'
    maskR = imbinarize(roiR, double(200/256));
    subplot(121), imshow(
    
    % Find bounding boxes surrounding connected components in the mask
    cc = bwconncomp(maskR, 4);
    measurements = regionprops(cc, 'BoundingBox');
    
    maxArea = 0; maxAreaW = 0;
   
    % Loop over all bounding boxes discovered
    for k = 1 : length(measurements)
        BB = measurements(k).BoundingBox;
        BBArea = BB(3)*BB(4);
        
        % Find the bounding box with the largest area
        if BBArea > maxArea
            maxArea = BBArea;
            maxAreaW = BB(3);
            maxAreaH = BB(4);
        end
    end
    
    % Ensure the area, width and height are within defined limits
    maxAreaResult = (maxArea >= 9800) && (maxArea <= 12000);
    maxAreaWResult = (maxAreaW >= 110) && (maxAreaW <= 130);
    maxAreaHResult = (maxAreaH >= 80) && (maxAreaH <= 100);
    
    % If all conditions are not true, bottle is deformed
    result = ~(maxAreaResult && maxAreaWResult && maxAreaHResult);
end
