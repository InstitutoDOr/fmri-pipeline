config = [];

%% GENERAL PARAMETERS
config.preproc_name  = 'NORM_ANAT';
config.dir_base        = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/';
config.preproc_base    = fullfile( config.dir_base, 'PREPROC_DATA', 'fMRI', config.preproc_name );

config.runs_prefix = { 'FMRI__RUN1_PRJ1410*', 'FMRI__RUN2_PRJ1410*', 'FMRI__RUN3_PRJ1410*' }; 
config.run_file_prefix = 'swarFMRI';
config.run_file_suffix = 'PRJ1410SENSE';

config.subjs = [2:16 18:26 28:32];

config.out_dir = fullfile( config.dir_base, 'PREPROC_DATA', 'fMRI', [config.preproc_name '_ICA'] );

for s=1:length(config.subjs)
    
    subjid = sprintf('SUBJ%03i', config.subjs(s));
    
    for r=1:3
        runid = sprintf('RUN%i', r );
        infile = fullfile(config.preproc_base, subjid, runid, [config.run_file_prefix runid config.run_file_suffix ]);
        tmp_outdir = fullfile(config.out_dir, subjid, runid);
        if ~isdir(tmp_outdir), mkdir(tmp_outdir), end
    
        command = ['melodic -i ' infile ' --nomask --nobet --tr=2 --Oall -v --report -o ' tmp_outdir];
        system(command);
    end   
end