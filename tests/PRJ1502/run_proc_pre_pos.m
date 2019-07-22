bootstrap; % Pré-configura o processamento deste projeto

%% subjects
config.subj_prefix = 'PILO';
config.runs_prefix = { '*IMAGE_1*', '*IMAGE_2*'}; 
config.run_file_prefix = 'WIPIMAG*';
config.nrun = 2;
%% EDITAR AQUI PARA CONFIGURAR O QUE RODAR
subjs = 5;
subjsIgnore = []; %Sujeitos que precisam ser removidos
config.subjs = setxor( subjs, subjsIgnore );
config.only_recalculate_contrasts = 0;
config.only_estimate = 0;
config.mov_regressor = 1;
config.resp_regressor = 0;
config.only_batch_files = 0;

config.do.preprocessing = 0;
config.do.first_level   = 1;
config.do.second_level  = 0;
config.do.extract_betas  = 0;
 
%% Modelos
config.model = get_model_pre_pos();

%% FIRST LEVEL
config.presentation = 0;
config.first_level_preproc_prefix = 'swar';
    
% config.HPF = 128;
config.HPF = 320;

%% SECOND LEVEL
config.sec.g1 = [];
config.sec.g2 = [];
config.sec.name = 'ALL';

exec_procs(config);
system('chmod 777 -R /dados1/PROJETOS/PRJ1502_NFB_MOTOR_II');