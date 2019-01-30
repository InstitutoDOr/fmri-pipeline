function [ funcs ] = temp_nii( funcs, destination )
%TEMP_NII Summary of this function goes here
%   Detailed explanation goes here

% Extracting gzip, if necessary
for r=1:length(funcs)
    if regexp(funcs{r}, '\.gz$') > 0
        img_basename = utils.path.basename(funcs{r}, 0);
        scans_dir = utils.mkdir( fullfile( destination, '.tmp_scans' ) );
        if ~exist(fullfile(scans_dir, img_basename), 'file')
            funcs{r} = utils.file.copy_gunzip_file(funcs{r}, scans_dir);
        else
            funcs{r} = fullfile(scans_dir, img_basename);
        end
    end
end

end

