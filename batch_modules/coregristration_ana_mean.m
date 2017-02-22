matlabbatch{1}.spm.spatial.coreg.estimate.ref    = {fullfile( preproc_dir, 'RUN1', sprintf( 'mean%s%i%s.nii,%i', run_file_prefix, 1, run_file_suffix, 1 ) )};
matlabbatch{1}.spm.spatial.coreg.estimate.source = {fullfile( preproc_dir, 'ANAT', anat_file )};
matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
