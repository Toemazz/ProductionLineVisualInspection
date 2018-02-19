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
