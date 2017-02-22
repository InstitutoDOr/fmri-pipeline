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
config.run_file_prefix = 'WIPFMRIRUN';
config.run_file_suffix = 'PRJ1410SENSE';

config.anat_prefix = 'WIP3D_T1_PRJ1410*';
config.anat_file = 'WIP3DT1PRJ1410SENSE.nii';

%% subjects
config.subj_prefix = 'SUBJ';

%% EDITAR AQUI PARA CONFIGURAR O QUE RODAR
config.subjs = [2:16 18:26 28:32];
%config.subjs = [2 4:16 18 19 21:26 28:32];
do_preprocessing = 0; % 0 ou 1;
do_first_level   = 1;
config.only_recalculate_contrasts = 1;
do_second_level  = 1;
config.mov_regressor = 1;
config.resp_regressor = 1;
config.outlier_regressor = 0;

%% configure paths
spm_dir = fileparts( which( 'spm' ) );
addpath( genpath( fullfile( config.dir_base, 'SCRIPTS') ) );
spm fmri

%% PREPROCESSING
if do_preprocessing
    preprocessing
end

%% smoothing
do_smoothing = 0
if do_smoothing
    config.file_prefix = 'gwar';
    apply_smoothing
end


%% inicializar uma vez o struct
config.model = get_effort_separado_CSO_model_TIAGO();
config.model(1) = [];

%---- modelos ATUAIS

%config.model(end+1) = get_effort_separado_CSO_model_TIAGO();

%config.model(end+1) = get_effort_separado_CSO_motor_model();

%config.model(end+1) = get_separado_cue_motor_model();

%config.model(end+1) = get_cue_motor_model();

%-----Testes sobreposicao BOLD CUE and SQUEEZE

%config.model(end+1) = get_effort_separado_C_SO_model();
%config.model(end+1) = get_effort_separado_C_SO_motor_model();
%config.model(end+1) = get_effort_separado_C_S_motor_model();
%config.model(end+1) = get_effort_separado_C_S_model();

config.model(end+1) = get_effort_separado_C_SO_Gito_model();

config.model(end+1) = get_effort_separado_C_SO_Gito_motor_model();

%config.model(end+1) = get_effort_separado_CZero_S_Gito_motor_model();

% -----OLD-----

%     config.model(end+1) = get_effort_C_SO_motor_model();

%     config.model(end+1) = get_cue_and_squeeze_motor_model();
%     config.model(end+1) = get_cue_and_squeeze_and_outcome_motor_model();
%     config.model(end+1) = get_squeeze_motor_model();


%     % models sem regressor motor
%     config.model(end+1) = get_cue_model();
%     config.model(end+1) = get_cue_and_squeeze_model();
%     config.model(end+1) = get_cue_and_squeeze_and_outcome_model();
%     config.model(end+1) = get_squeeze_model();
%
%     % modelos parametricos
%     config.model(end+1) = get_parametric_cue_model();
%     config.model(end+1) = get_parametric_cue_and_squeeze_model();
%     config.model(end+1) = get_cue_and_squeeze_and_outcome_model();
%     config.model(end+1) = get_squeeze_model();
%     config.model(end+1) = get_effort_separado_parametric_cue_and_squeeze_model();
%      config.model(end+1) = get_effort_separado_parametric_CSO_model();
%
%     % strange model design
%     config.model(end+1) = get_cue_and_squeeze_without_effort_motor_model();
%config.model(end+1) = get_effort_separado_cue_motor_model();
    
% config.model(end+1) = get_effort_separado_outcome_motor_model();        
% config.model(end+1) = get_effort_separado_cue_and_squeeze_model();
% config.model(end+1) = get_effort_separado_CSO_model();


%config.model(end+1) = get_effort_C_SO_model();
 


% config.model(end+1) = get_effort_separado_CSO_baseline_model();
% config.model(end+1) = get_effort_separado_outcome_model();
% config.model(end+1) = get_cue_phase_model();
% config.model(end+1) = get_cue_phase_squeeze_parametric_model();
%  config.model(end+1) = get_cue_phase_squeeze_parametric_TIAGO();

%for k=1:length(config.model )
    
   %config.model(k).name =  ['G' config.model(k).name ];
%end
config.model([]) = [];

% Sebastian: test autocorrelation parameter AR(1)    
%config.model(end).name = [config.model(end).name '_AR1'];
    
 %% FIRST LEVEL
if do_first_level
    
    config.logdir = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/LOG/';
    config.physlogdir = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PHYS_LOG/';
    config.files = { '1Run.log', '2Run.log', '3Run.log'};
    config.first_level_preproc_prefix = 'swar';
    
    config.HPF = 128;
    
    run_first_level( config );
    
end

if do_second_level
    
    %config.sec.covariate.vec  = [4 4.85 6 6.57 6.14 5.85 4.71 6.85 6.714 6 6 5.71 4.14 5.42 7 3.28 -1000 6.57 5.71 6.42 4.28 5.85 6.14 6.28 5.71 6.71 -1000 5.42 6.57 6.85 6.14 5.71];
    %config.sec.covariate.name = 'ID';
    
    %config.sec.covariate.vec  = [0 3 6 6 0 5 4 2 4 0 1 2 3 0 5 0 -1000 5 4 3 2 5 3 5 3 4];
    %config.sec.covariate.name = 'DIFFID';
    
    %config.sec.covariate.vec = [5.5 4.25 5.75 4.5 6.25 6.75 5.25 5.75 6.75 6.25 5.25 4 4.75 5.5 6.5 3.25 -1000 5.5 7.5 4 2.75 8 6.25 8.25 4.5 7.75 -1000 7.25 6.75 7.75 5 8];
    %config.sec.covariate.name = 'ENTITAVITY';
    
    %config.sec.covariate.vec = [2.75 1 0.25 0.25 2.25 5 1 3.75 3 1 -0.25 -1.25 2.25 2.5 4.75 1.5 -1000 3.75 3.25 2 1.25 2.75 3.25 6 3.25 6.25];
    %config.sec.covariate.name = 'DIF_ENTITAVITY';
    
    %config.sec.covariate.vec  = [0.15 0.03 0.05 0.21 0.33 1.02 0.04 0.45 0.69 0.55 0.07 0.01 0.88 0.008 0.40 1.23 -1000 0.19 -0.01 0.27 0.52 0.18 -0.02 0.15 0.13 1.05 -1000 0.42];
    %config.sec.covariate.name = 'INGROUPBIAS';
    
    %config.sec.covariate.vec  = [-1000 0.5715 -0.0054 0.4834 0.2581 -0.0483 0.0330 0.1202 -0.4438 0.1735 0.0639 0.5256 0.6442 0.0399 0.0439 -0.1095 -1000 0.2101 0.1269 0.5877 0.4394 0.6404 0.1411 -0.0550 0.1974 0.1132 -1000 0.1788];
    %config.sec.covariate.name = 'SELF_FAN';
    
    %config.sec.covariate.vec  = [4.29 2.57 3.57 4.00 5.86 4.14 3.14 5.43 4.86 5.14 4.00 4.14 3.43 2.29 5.29 1.71 -1000.00 5.14 3.71 2.14 4.00 4.86 4.00 4.71 5.57 4.00 -1000.00 5.57 7.00 4.14 3.14 3.00]
    %config.sec.covariate.name = 'FUSION';
    
    %config.sec.covariate.vec  = [0.14 1.57 2.57 3.00 1.86 3.14 2.14 4.43 3.86 2.00 3.00 3.14 2.43 1.00 4.29 0.71 -1000 4.14 1.29 1.14 0.00 3.43 3.00 3.71 4.43 3.00 3.86 6.00 3.14 0.71 2.00]
    %config.sec.covariate.name = 'DIFF_FUSION';
    
    %config.sec.covariate.vec  = [0.14 1.57 2.57 3.00 1.86 3.14 2.14 4.43 3.86 2.00 3.00 3.14 2.43 1.00 4.29 0.71 -1000 4.14 1.29 1.14 0.00 3.43 3.00 3.71 4.43 3.00 3.86 6.00 3.14 0.71 2.00]
    %config.sec.covariate.name = 'AUC';
    
    %config.sec.covariate.vec  = [10 23 3 24 15 26 6 17 1 20 12 21 30 4 19 25 -1000 14 9 28 29 27 8 2 13 18 -1000 16 11 7 5 22];
    %config.sec.covariate.name = 'Rank_Self';
    
    %config.sec.covariate.vec  = [14 1 17 5 16 28 13 22 29 23 15 2 21 11 25 30 -1000 12 7 4 18 3 8 19 10 26 -1000 20 6 24 9 27];
    %config.sec.covariate.name = 'Rank_Team';
    
    %config.sec.covariate.vec  = [22 17 24 13 15 2 26 12 10 8 21 18 3 29 7 1 -1000 19 27 9 4 11 28 23 20 6 -1000 14 25 16 30 5];
    %config.sec.covariate.name = 'Rank_STI';
    
    %config.sec.covariate.vec  = [0.334818373 0.277516677 0.341119606 0.304230942 0.338853153 0.502151741 0.334157125 0.365787023 0.508015535 0.378960525 0.335275235 0.281683101 0.359283892 0.33092584 0.400198307 0.515481016 -1000 0.332245968 0.321092824 0.292108192 0.346531192 0.288502787 0.322159099 0.350887389 0.328755545 0.400383842 -1000 0.354058118 0.320220052 0.391115199 0.32804823 0.425419359];
    %config.sec.covariate.name = 'Norm_Team';
    
    %config.sec.covariate.vec  = [0.306829276 0.267760166 0.319764131 0.235343833 0.263079852 0.018539281 0.322401674 0.233570239 0.187792372 0.179641423 0.305645076 0.275907661 0.07183848 0.328887318 0.174968957 0.013662627 -1000 0.283883994 0.324725819 0.185674386 0.098497526 0.23200482 0.326976915 0.312293072 0.298238185 0.174933961 -1000 0.246129019 0.320805362 0.264254563 0.331199884 0.120400442];
    %config.sec.covariate.name = 'Norm_STI';
    
    %config.sec.covariate.apply_contrasts = [1 5 7 11]; % apply covariates only for these contrasts (TEAM) CUE
    %config.sec.covariate.apply_contrasts = [2 6 9 12]; % apply covariates only for these contrasts (STI) CUE
    %config.sec.covariate.apply_contrasts = [1 3 10 7 13 16 18 ]; % apply covariates only for these contrasts (TEAM) CSO_MOTOR
    %config.sec.covariate.apply_contrasts = [2 5 8 11 14 17 21]; % apply covariates only for these contrasts (STI) CSO_MOTOR
    
    %config.sec.covariate.apply_contrasts = [1 7 13 16 18 22 27]; % apply covariates only for these contrasts (TEAM) C_SO
    %config.sec.covariate.apply_contrasts = [3 9 14 17 21 23 29]; % apply covariates only for these contrasts (STI) C_SO
    
    config.sec.g1 = [2:16 18:26 28:32];
    %config.sec.g1 = [2:7 9:16 18:24 26 28:31];
    config.sec.g2 = [];
    config.sec.name = '02_32';

    %config.sec.covariate.vec = config.sec.covariate.vec( config.sec.g1 );
    
    run_second_level( config );
end
