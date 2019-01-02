function training_sets = setup()
% I created this function

%Find all images in subfolders with .jpg extension.
image_files = dir ('**/*.jpg');
num_files = length(image_files);

% Find num of folders by locating where all images are in the Matlab
% root directory.

all_folders = strings(0,0);  % Pre-allocate string array
folder_old = '';
j = 1;

for i = 1:num_files  % Check folder that each file is in
    folder = string(image_files(i).folder);
    if folder ~= folder_old
        all_folders(j,1) = folder;
        folder_old = folder;
        j = j+1;  % Advance folders
    end
end

num_folders = length(all_folders);

% Create string array that will hold paths of all images, each row is new
% training set. Images must be sorted beforehand
training_sets = strings(num_folders, num_files);  
                                                                              
folder_old = image_files(1).folder;     % Get path of our first training set
j = 1;  % Which training set paths belong in
k = 1;  % Which column image paths should be placed in

for i = 1:num_files
    folder = string(image_files(i).folder);
    if folder == folder_old
        image = strcat(image_files(i).folder,'\',image_files(i).name);  % Get full path
        training_sets(j,k) = image;  % Append path
        k = k+1; 
    else
        j = j+1;  % Move to next row / training set
        k = 1;  % Reset our index to first column        
        image = strcat(image_files(i).folder,'\',image_files(i).name);
        training_sets(j,k) = image;  % Append path
        k = k+1; 
        folder_old = folder;  % Update training set folder
    end
end
