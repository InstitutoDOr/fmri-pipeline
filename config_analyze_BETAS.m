%% configurations 
addpath( '/dados3/SOFTWARES/PESQUISA/MATLAB/SCRIPTS_IDOR/bruno' );
initFolder( '/dados3/SOFTWARES/PESQUISA/MATLAB/SCRIPTS_IDOR/bruno' );
initFolder( idorFolder('/dados3/SOFTWARES/PESQUISA/MATLAB/SCRIPTS_IDOR/bruno/idorSpm') );
includeSubdirs( {'model_definitions','utils'} );

config = [];

%% GENERAL PARAMETERS
config.preproc_name  = 'NORM_ANAT';
config.dir_base        = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/';
config.raw_base        = fullfile( config.dir_base, 'RAW_DATA', 'NII' );
config.preproc_base    = fullfile( config.dir_base, 'PREPROC_DATA', 'fMRI', config.preproc_name );
config.proc_base       = fullfile( config.dir_base, 'PROC_DATA', 'BETASERIES', config.preproc_name );
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
config.subjs = [9];
%config.subjs = [2 4:16 18 19 21:26 28:32];
do_preprocessing = 0; % 0 ou 1;
do_first_level   = 1;
config.only_recalculate_contrasts = 0;
do_second_level  = 0;
config.mov_regressor = 1;
config.resp_regressor = 1;
config.outlier_regressor = 0;

config.only_estimate = 1;
config.mov_regressor = 1;
config.do.preprocessing = 0;
config.do.first_level   = 0;
config.do.second_level  = 0;
config.do.extract_betas  = 1;

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

%config.model(end+1) = get_cue_motor_model();
 
config.model(end+1) = get_effort_separado_CSO_model_TIAGO();
config.model(end).name = ['AR_NoSmooth' config.model(end).name];

%config.model(end+1) = get_effort_separado_CSO_motor_model();
%config.model(end).name = ['AR_' config.model(end).name];

%config.model(end+1) = get_effort_separado_CSO_model_ANNR();
%config.model(end).name = ['AR_' config.model(end).name];

%config.model(end+1) = get_separado_cue_motor_model();

%-----Testes sobreposicao BOLD CUE and SQUEEZE

%config.model(end+1) = get_effort_separado_C_SO_model();
%config.model(end+1) = get_effort_separado_C_SO_motor_model();
%config.model(end+1) = get_effort_separado_C_S_motor_model();
%config.model(end+1) = get_effort_separado_C_S_model();

%config.model(end+1) = get_effort_separado_C_SO_Gito_model();
%config.model(end).name = ['AR_' config.model(end).name];

%config.model(end+1) = get_effort_separado_C_SO_Gito_motor_model();
%config.model(end).name = ['AR_' config.model(end).name];
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
    
 %% FIRST LEVEL
if do_first_level
    
    config.logdir = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/LOG/';
    config.physlogdir = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PHYS_LOG/';
    config.files = { '1Run.log', '2Run.log', '3Run.log'};
    config.first_level_preproc_prefix = 'war';
    
    config.HPF = 128;
    
    %run_first_level( config );
    
end

exec_procs(config);
