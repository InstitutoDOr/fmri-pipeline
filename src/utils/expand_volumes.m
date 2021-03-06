function spm_scans = expand_volumes( bids_dir, filter, prefix )

if nargin < 2 || isempty(filter), filter = 'sub-'; end
if nargin < 3, prefix = ''; end

if isdir( bids_dir{1} )
    scans = neuro.bids.get_scans( bids_dir, filter );
else
    scans = bids_dir;
end

spm_scans = {};
for ns = 1:length(scans)
    nframes = get_num_frames( scans{ns} );
    spm_scans = [spm_scans; spm_volumes(scans{ns}, nframes, prefix)];
end

end

