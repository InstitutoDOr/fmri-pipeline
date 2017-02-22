preproc_base = config.preproc_base    
nrun = config.nrun
nvol = config.nvol
smooth = config.smooth 
runs_prefix = config.runs_prefix 
run_file_prefix = config.run_file_prefix 
run_file_suffix = config.run_file_suffix 
subjs = config.subjs
subj_prefix = config.subj_prefix


%% start of pipeline
if ~isdir( preproc_base ), mkdir( preproc_base ); end


for i=subjs
    
    name_subj{i} = sprintf( '%s%03i', subj_prefix, i );
    disp (['Smoothing for subject: ', name_subj{i} ]);
    
    preproc_dir = fullfile( preproc_base, [name_subj{i} ]) ;
    
    cd( preproc_dir )
    
    %%%%%%% Smoothing functional images  %%%%%%%%%%%%
    
    config.preproc_dir = preproc_dir;
    
    matlabbatch = smooth_batch_params(config);
    save( fullfile( preproc_dir, 'BATCH_SMOOTH_GAR.mat'), 'matlabbatch' );
    disp (sprintf( 'Smoothing functional images for subject: %s\n%s\n', name_subj{i}, preproc_dir) );
    spm_jobman('run',matlabbatch);
    
end

