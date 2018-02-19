%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SCRIPT: Main Program
clear; clc; close all;

% Define path to directory containing the test images
imagesDir = 'images/All/';
% imagesDir = 'images/BottleCapMissing/';
% imagesDir = 'images/BottleDeformed/';
% imagesDir = 'images/BottleMissing/';
% imagesDir = 'images/BottleOverfilled/';
% imagesDir = 'images/BottleUnderfilled/';
% imagesDir = 'images/LabelMissing/';
% imagesDir = 'images/LabelNotPrinted/';
% imagesDir = 'images/LabelNotStraight/';
% imagesDir = 'images/MultipleFaults';
% imagesDir = 'images/Normal/';

% Get information about the images in the specified directory
fileData = GetFileDataFromDirectory(imagesDir);

% Add file paths to a string array
for i = 1:length(fileData)
    % Get file name and file path
    fileName = fileData(i).name;
    filePath = fullfile(imagesDir, fileName);
    
    % Set 'baseOutput' to 'fileName'
    baseOutput = fprintf('%s: ', fileName);
    
    % Load image (Size: 288, 352, 3)
    image = imread(filePath);
    
    % Check if bottle is missing
    bottleMissing = CheckIfBottleMissing(image);
    
    if bottleMissing
        % Add 'bottle missing' to the output
        output = baseOutput + fprintf('No Faults Detected (Bottle Missing)');
    else
        output = baseOutput;
        
        % Check if the cap is missing
        bottleCapMissing = CheckIfBottleCapMissing(image);
        
        if bottleCapMissing
            % Add 'bottle cap missing' to the output
            output = output + fprintf('Bottle Cap Missing, ');
        end

        % Check if the bottle is underfilled
        bottleUnderfilled = CheckIfBottleUnderfilled(image);
        
        if bottleUnderfilled
            % Add 'bottle underfilled' to the output
            output = output + fprintf('Bottle Underfilled, ');
        end

        % Check if the label is missing
        labelMissing = CheckIfLabelMissing(image);
        
        if labelMissing
            % Add 'label missing' to the output
            output = output + fprintf('Label Missing, ');
        else
            % Check if the label is printed
            labelNotPrinted = CheckIfLabelNotPrinted(image);
            
            if labelNotPrinted
                % Add 'label not printed' to the output
                output = output + fprintf('Label Not Printed, ');
            else        
                % Check if the label is not straight
                labelNotStraight = CheckIfLabelNotStraight(image);
                
                if labelNotStraight
                    % Add 'label not straight' to the output
                    output = output + fprintf('Label Not Straight, ');
                end
                
                % Check if the bottle is deformed
                bottleDeformed = CheckIfBottleDeformed(image);
            end
        end
        
        % Check if the bottle is overfilled
        bottleOverfilled = CheckIfBottleOverfilled(image);
        
        % If any of these faults happen, the bottle is not deformed
        if bottleUnderfilled || labelMissing || labelNotPrinted || labelNotStraight
            bottleDeformed = 0;
        end
        
        if bottleDeformed
            % Add 'bottle deformed' to the output
            output = output + fprintf('Bottle Deformed, ');
            % If bottle is deformed, the bottle should not be detected as
            % overfilled
            bottleOverfilled = 0;
        end  
        
        if bottleOverfilled
            % Add 'bottle overfilled' to the output
            output = output + fprintf('Bottle Overfilled, ');
        end
    end
    
    if output == baseOutput
        % Add 'no faults detected' to the output
        output = output + fprintf('No Faults Detected');
    end
    
    % Add newline to the end of the output for display purposes
    fprintf('\n');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION: Used to load images from a specified directory
function fileData = GetFileDataFromDirectory(dirPath)
% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isdir(dirPath)
    errorMessage = sprintf('[ERROR]: The following folder does not exist:\n%s', dirPath);
    uiwait(warndlg(errorMessage));
    return;
end

% Get a list of all '.jpg' files in the directory
filePattern = fullfile(dirPath, '*.jpg');
fileData = dir(filePattern);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION: Used to extract a ROI (Region of Interest) from an image
function imageOut = ExtractROI(imageIn, y1, x1, y2, x2)
% Check if any of the points are '0'
if x1 == 0 || x2 == 0 || y1 == 0 || y2 == 0
    errorMessage = sprintf('[ERROR]: Ooops you forgot MATLAB indices start at 1!\n');
    uiwait(warndlg(errorMessage));
    return;
end

% Get image dimensions
[h, w, ~] = size(imageIn);

if x1 > w || x2 > w || y1 > h || y2 > h
    errorMessage = sprintf('[ERROR]: Images dimensions (%d, %d) exceeded!\n', h, w);
    uiwait(warndlg(errorMessage));
    return;
end

imageOut = imageIn(y1:y2, x1:x2, :);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION: Used to detect cases where the bottle is deformed
function result = CheckIfBottleDeformed(image)
    % Extract the red channel and apply contrast adjustment
    imageR = image(:, :, 1);
    imageR = imadjust(imageR);
    
    % Extract the ROI of the label area on the bottle
    roiR = ExtractROI(imageR, 190, 100, 280, 260);

    % Binarize the red channel using a greyscale threshold of '200'
    maskR = imbinarize(roiR, double(200/256));
    
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
