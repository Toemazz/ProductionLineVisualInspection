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
