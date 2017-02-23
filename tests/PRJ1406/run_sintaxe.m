bootstrap;

%% EDITAR AQUI PARA CONFIGURAR O QUE RODAR
subjs = [1:29];
subjsIgnore = [8 11 13 17 24]; %Sujeitos que precisam ser removidos
config.subjs = setdiff( subjs, subjsIgnore );
config.do.preprocessing = 0; % 0 ou 1;
config.do.first_level   = 1; % 0 ou 1;
config.do.second_level  = 1;
% so quando quer recalcular somente contrastes
config.only_recalculate_contrasts = 0;

config.mov_regressor = 1;
%quando quer incluir correcao de respiracao, o que nao se aplica a este estudo
config.resp_regressor = 0;

%config.model = get_sintaxe_model();
%config.model = get_sintaxe_model_simple();
config.model = get_sintaxe_model_paramLeC();
%config.model = get_sintaxe_model_paramL_comCp();

%% FIRST LEVEL
%config.logdir = '/dados1/PROJETOS/PRJ1406_SINTAXE_E_VALORES/03_PROCS/LOGS_PRESENTATION/LOGS COM CATEGORIA CP/';
config.logdir = '/dados1/PROJETOS/PRJ1406_SINTAXE_E_VALORES/03_PROCS/LOGS_PRESENTATION/';
config.files = { 'RUN1*.log', 'RUN2*.log', 'RUN3*.log', 'RUN4*.log'};
config.first_level_preproc_prefix = 'swar';

config.HPF = 128;
    
%% SECOND LEVEL
config.sec.g1 = config.subjs;
config.sec.g2 = [];
config.sec.name = 'ALL';

exec_procs(config);

