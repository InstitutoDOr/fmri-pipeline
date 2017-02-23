bootstrap;

%% configurations
config = [];

%% GENERAL PARAMETERS
config.preproc_name  = 'NORM_ANAT';
config.dir_base        = '/dados1/PROJETOS/PRJ1016_PRIMING/03_PROCS/';
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
config.export_from_raw_data = 0;
config.mask = {'/dados3/SOFTWARES/Blade/toolbox_IDOR/spm12/spm12/tpm/mask_ICV.nii,1'};
config.mthresh = 0.1;

config.runs_prefix = { '*RUN1*', '*RUN2*', '*RUN3*' }; 
config.run_file_prefix = 'FMRIRUN*';
config.run_file_suffix = 'PRJ1016SENSE';

config.anat_prefix = '3D_T1_PRJ1016*';
config.anat_file = '3DT1PRJ1016SENSE.nii';

config.subj_prefix = 'SUBJ';

config.HPF = 128;
config.hrf_derivate = [0 0]; % Hemodynamic Response Function

%% SUBJECTS
subjs = [1:45];
%subjsIgnore = [1 4:7 24 40 41]; %Sujeitos que precisam ser removidos
%subjs = [2 3 12 13 15 16 19 32 38];
subjsIgnore = [1:7 12 13 15 16 19 24 32 38 40 41];

%% EDITAR AQUI PARA CONFIGURAR O QUE RODAR
config.subjs = setdiff( subjs, subjsIgnore );
config.only_recalculate_contrasts = 0;
config.only_estimate = 0;
config.only_batch_files = 0;
config.mov_regressor = 1;
config.resp_regressor = 0;
config.one_session = 0;

config.do.preprocessing  = 0;
config.do.first_level    = 0;
config.do.second_level   = 1;
config.do.extract_betas  = 0;

%% configure paths
spm_dir = fileparts( which( 'spm' ) );
addpath( genpath( fullfile( config.dir_base, 'SCRIPTS') ) );
 
%% inicializar uma vez o struct
config.duration_conds = 0; %Duration
config.mod_parametric = 0;
%config.model = get_supraliminar_model_simple( config );
%config.model = get_supraliminar_model_simple_response( config );
%config.model = get_supraliminar_model_simple_onesec( config );
%config.model = get_supraliminar_parametric( config );
%config.model = get_supraliminar_decisions( config );
%config.model = get_supraliminar_model_nogap( config );
%config.model = get_supraliminar_model_one_per_trial( config );
config.model = get_supraliminar_model_simple( config );

%% FIRST LEVEL
if config.do.first_level
    config.logdir = '/dados1/PROJETOS/PRJ1016_PRIMING/03_PROCS/LOG_PRESENTATION/fMRI';
    config.files = { 'Priming1.log', 'Priming2.log', 'Priming3.log'};
    config.first_level_preproc_prefix = 'swar';
end

if config.do.second_level
    config.sec.g1 = config.subjs;
    config.sec.g2 = [];
    config.sec.name = sprintf( '%dSUBJS', length(config.subjs) );
end

exec_procs(config);
%run( '/dados1/PROJETOS/PRJ1016_PRIMING/03_PROCS/SCRIPTS/run_params_mov.m' );
%system('chmod 777 -R /dados1/PROJETOS/PRJ1016_PRIMING');
