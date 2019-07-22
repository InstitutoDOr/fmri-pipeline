bootstrap_test;

tmp_dir = fullfile(pwd, 'tmp');

%% configurations
config = [];

%% GENERAL PARAMETERS
config.preproc_name  = 'NORM_ANAT';
config.dir_base        = '/dados1/PROJETOS/PRJ1016_PRIMING/03_PROCS/';
config.raw_base        = fullfile( config.dir_base, 'RAW_DATA', 'NII' );
config.preproc_base    = fullfile( config.dir_base, 'PREPROC_DATA', 'fMRI', config.preproc_name );
config.proc_base       = fullfile( tmp_dir, 'PROC_DATA', 'fMRI', config.preproc_name );
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
config.subjs = [8 9];

%% EDITAR AQUI PARA CONFIGURAR O QUE RODAR
config.only_recalculate_contrasts = 0;
config.only_estimate = 0;
config.only_batch_files = 0;
config.mov_regressor = 1;
config.resp_regressor = 0;
config.one_session = 1;

config.do.preprocessing  = 0;
config.do.first_level    = 0;
config.do.second_level   = 0;
config.do.extract_betas  = 1;

%% configure paths
spm_dir = fileparts( which( 'spm' ) );
 
%% inicializar uma vez o struct
config.duration_conds = 0; %Duration
config.mod_parametric = 0;
config.model = model_test( config );

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
