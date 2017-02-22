rootdir = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL/RESP_MOV_EFFORT_SEP_CSO_TIAGO_SINGLE_TRIAL/';

subjs = [2:16 18:26 28:29];

clear matlabbatch;
for s=1:length(subjs)
   
    batchfile = fullfile( rootdir, sprintf( 'SUBJ%03i', subjs(s) ), 'BATCH_FIRST_LEVEL.mat' ); 
    load(batchfile);
    spm_jobman( 'run', matlabbatch );
    
end