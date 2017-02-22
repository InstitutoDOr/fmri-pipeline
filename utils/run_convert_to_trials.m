rootdir = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL/RESP_MOV_EFFORT_SEP_CSO_TIAGO/';
destdir = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL/RESP_MOV_EFFORT_SEP_CSO_TIAGO_SINGLE_TRIAL/';

subjs = [2:16 18:26 28:29];


for s=1:length(subjs)
   
    batchfile = fullfile( rootdir, sprintf( 'SUBJ%03i', subjs(s) ), 'BATCH_FIRST_LEVEL.mat' ); 
    
    tmp_destdir =  fullfile( destdir, sprintf( 'SUBJ%03i', subjs(s) ) );
    
    matlabbatch = convert_to_trials( batchfile, tmp_destdir );
    
    if ~isdir( tmp_destdir ), mkdir( tmp_destdir ), end;
    save( fullfile( tmp_destdir, 'BATCH_FIRST_LEVEL.mat' ), 'matlabbatch' );
    
end