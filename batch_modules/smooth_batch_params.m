function matlabbatch = smooth_batch_params( cfg )

%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
%%
matlabbatch{1}.spm.spatial.smooth.data = get_scans_concatenated( cfg.preproc_dir, cfg.nrun, cfg.nvol, [cfg.file_prefix cfg.run_file_prefix], cfg.run_file_suffix );
matlabbatch{1}.spm.spatial.smooth.fwhm = cfg.smooth;
matlabbatch{1}.spm.spatial.smooth.dtype = 0;
matlabbatch{1}.spm.spatial.smooth.im = 0;
matlabbatch{1}.spm.spatial.smooth.prefix = 's';

if any( cfg.smooth ~= 6 )
    if sum( diff(cfg.smooth) ) == 0
        matlabbatch{1}.spm.spatial.smooth.prefix = ['s' cfg.smooth(1)];
    else
        matlabbatch{1}.spm.spatial.smooth.prefix = ['s' cfg.smooth(1) cfg.smooth(2) cfg.smooth(3)];
    end
end