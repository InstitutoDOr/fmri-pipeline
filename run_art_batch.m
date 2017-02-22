arttooldir = '/usr/local/MATLAB/toolbox_IDOR/art_IDOR';
addpath( arttooldir );

datadir = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL/RESP_MOV_EFFORT_SEP_CSO';
artdir  = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/ART';

subjs = [ 18:19 ];
for s=1:length(subjs)
    
    subdir(1).name = sprintf('SUBJ%03i', subjs(s) );
    
    spm_file = fullfile(datadir, subdir(1).name, 'SPM.mat');
    artsubdir = fullfile(artdir, subdir(1).name );
    
    sid = num2str( subdir(1).name(5:end) );
    
    art_batch_IDOR( {spm_file}, {artsubdir}, sid, 3, 9 );
    
    art_batch_IDOR( {spm_file}, {artsubdir}, sid, 2, 9 );
    
    close all
    
   
end

rmpath( arttooldir );