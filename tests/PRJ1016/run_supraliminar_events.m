bootstrap;

%% configurations 
config = [];

%% GENERAL PARAMETERS
config.preproc_name  = 'NORM_ANAT';
config.dir_base        = idorFolder('/dados1/PROJETOS/PRJ1016_PRIMING/03_PROCS/');
config.raw_base        = fullfile( config.dir_base, 'RAW_DATA', 'NII' );
config.preproc_base    = fullfile( config.dir_base, 'PREPROC_DATA', 'fMRI', config.preproc_name );
config.proc_base       = fullfile( config.dir_base, 'PROC_DATA', 'fMRI', config.preproc_name );
config.nrun = 3;
config.nvol = 210;
config.ncorte = 40;
config.TR = 2;
config.TA = 1.675;
config.TA = config.TA - (config.TA/config.ncorte);
config.smooth = [6 6 6];
config.export_from_raw_data = 1;
config.together = 1;

config.runs_prefix = { 'FMRI__RUN1_PRJ1016*', 'FMRI__RUN2_PRJ1016*', 'FMRI__RUN3_PRJ1016*' }; 
config.run_file_prefix = 'FMRIRUN*';
config.run_file_suffix = 'PRJ1016SENSE';

config.anat_prefix = '3D_T1_PRJ1016*';
config.anat_file = '3DT1PRJ1016SENSE.nii';

%% subjects
config.subj_prefix = 'SUBJ';

%% EDITAR AQUI PARA CONFIGURAR O QUE RODAR
config.subjs = [29:37];
config.do.preprocessing = 0; % 0 ou 1;
config.do.first_level   = 1;
config.only_recalculate_contrasts = 0;
config.only_estimate = 1;
config.do.second_level  = 0;
config.mov_regressor = 1;
config.resp_regressor = 0;
config.only_batch_files = 1;

%% configure paths
spm_dir = fileparts( which( 'spm' ) );
addpath( genpath( fullfile( config.dir_base, 'SCRIPTS') ) );
    
%% inicializar uma vez o struct
config.model = get_supraliminar_model_complex();

%% FIRST LEVEL
if do_first_level
    config.logdir = idorFolder('/dados1/PROJETOS/PRJ1016_PRIMING/03_PROCS/LOG_PRESENTATION/fMRI');
    config.files = { 'Priming1.log', 'Priming2.log', 'Priming3.log'};
    config.first_level_preproc_prefix = 'swar';
    
    config.HPF = 128;
    
    run_first_level( config );
end

if do_second_level
    config.sec.g1 = [2:4 8 10:17 19:23];
    config.sec.g2 = [];
    config.sec.name = 'ALL_[SEM 9 18]';

    run_second_level( config );
end

system('chmod 777 -R /dados1/PROJETOS/PRJ1016_PRIMING');
