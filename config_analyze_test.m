%% configurations 

config = [];

%% GENERAL PARAMETERS
config.preproc_name  = 'NORM_ANAT';
config.dir_base        = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/';
config.raw_base        = fullfile( config.dir_base, 'RAW_DATA', 'NII' );
config.preproc_base    = fullfile( config.dir_base, 'PREPROC_DATA', 'fMRI', config.preproc_name );
config.proc_base       = fullfile( config.dir_base, 'PROC_DATA', 'fMRI', config.preproc_name );
config.nrun = 3
config.nvol = 256
config.ncorte = 40 
config.TR = 2
config.TA = 1.675;
config.TA = config.TA - (config.TA/config.ncorte)
config.smooth = [6 6 6]
config.export_from_raw_data = 1; 

config.runs_prefix = { 'FMRI__RUN1_PRJ1410*', 'FMRI__RUN2_PRJ1410*', 'FMRI__RUN3_PRJ1410*' }; 
config.run_file_prefix = 'FMRIRUN';
config.run_file_suffix = 'PRJ1410SENSE';

config.anat_prefix = '3D_T1_PRJ1410*';
config.anat_file = '3DT1PRJ1410SENSE.nii';

%% subjects
config.subj_prefix = 'TESTE';
config.subjs = [ 2 ];

%% configure paths
spm_dir = fileparts( which( 'spm' ) );
addpath( genpath( fullfile( config.dir_base, 'SCRIPTS') ) );
% spm fmri

%% PREPROCESSING
% preprocessing

%% FIRST LEVEL
config.logdir = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/LOG/TESTE002/';
config.files = { '1Run.log', '2Run.log', '3Run.log'};
config.first_level_preproc_prefix = 'swar';

% modelos com regressor motor
% config.model(1) = get_cue_motor_model();
% config.model(2) = get_cue_and_squeeze_motor_model();
% config.model(3) = get_cue_and_squeeze_and_outcome_motor_model();
% config.model(4) = get_squeeze_motor_model();

% models sem regressor motor
% config.model(1) = get_cue_model();
% config.model(2) = get_cue_and_squeeze_model();
% config.model(3) = get_cue_and_squeeze_and_outcome_model();
% config.model(4) = get_squeeze_model();

% modelos parametricos
%config.model(1) = get_parametric_cue_model();
%config.model(2) = get_parametric_cue_and_squeeze_model();
% config.model(3) = get_cue_and_squeeze_and_outcome_model();
% config.model(4) = get_squeeze_model();

%config.model(1) = get_effort_separado_cue_and_squeeze_model();

config.model(1) = get_cue_and_squeeze_without_effort_motor_model();

config.model([]) = [];

config.HPF = 128;

config.only_recalculate_contrasts = 0;
run_first_level( config );


%config.sec.g1 = [ 2:5 7:9 ];
%config.sec.g2 = [];
%config.sec.name = 'ALL_EX1_6';

%run_second_level( config );

