function mean_fMRI = get_mean_fMRI( preproc_dir, run_file_prefix, run_file_suffix )

r=1;
mean_fMRI = fullfile( preproc_dir, sprintf( 'RUN%i', r) , sprintf( 'mean%s%i%s.nii', run_file_prefix, r, run_file_suffix ) ); 
    
end