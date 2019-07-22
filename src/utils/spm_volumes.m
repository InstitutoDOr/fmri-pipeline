function [ volumes ] = spm_volumes( filename, nvols, prefix )
%SPM_VOLUMES - Fill the number of volumes
%   returns an cell like: {'img.nii,1', .., 'img.nii,150'}
if nargin < 3, prefix = ''; end

volumes = cell(nvols, 1);
[directory, filename, ext] = fileparts(filename);
fullpath = fullfile(directory, sprintf('%s%s%s', prefix, filename, ext));

for n=1:nvols
    volumes{n, 1} = sprintf('%s,%d', fullpath, n);
end

end

