function scans = get_scans( preproc_dir, nrun, nvol, run_file_prefix, run_file_suffix )

scans = [];
for r=1:nrun
    for k=1:nvol
        run_tmp{k,1} = fullfile( preproc_dir, sprintf( 'RUN%i', r) , sprintf( '%s%i%s.nii,%i', run_file_prefix, r, run_file_suffix, k ) ); 
        scans{r,1} = run_tmp;
    end
end

end