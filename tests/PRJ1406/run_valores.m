bootstrap;

%% EDITAR AQUI PARA CONFIGURAR O QUE RODAR
subjs = 1:29;
%subjs = 1; %Para testes
subjsIgnore = [8 11 13 17 24]; %Sujeitos que precisam ser removidos
config.subjs = setdiff( subjs, subjsIgnore );
config.do.preprocessing = 0; % 0 ou 1;
config.do.first_level   = 0; % 0 ou 1;
config.do.second_level  = 1;

% To extract betas
config.one_session       = 0;
config.do.extract_betas  = 0;


config.only_recalculate_contrasts = 0;
config.only_estimate = 0;
config.only_batch_files = 0;
config.mov_regressor = 1;
config.resp_regressor = 0;


%config.model = get_valores_model();
config.model = get_valores_model_melhores();
%config.model = get_valores_model_modulacao();

%% FIRST LEVEL  
config.presentation = 1;
config.logdir = '/dados1/PROJETOS/PRJ1406_SINTAXE_E_VALORES/03_PROCS/LOGS_PRESENTATION/ajustado/';
config.files = { 'RUN1*.log', 'RUN2*.log', 'RUN3*.log', 'RUN4*.log'};
config.first_level_preproc_prefix = 'swar';

config.HPF = 196;
    
%% SECOND LEVEL
config.sec.g1 = setdiff(config.subjs, 1:4);
config.sec.g2 = [];
% covfiles - Mat file with two variables (R , names)
config.sec.covfiles = {'/dados1/PROJETOS/PRJ1406_SINTAXE_E_VALORES/03_PROCS/SCRIPTS/spm/extra/covariates.mat'};
config.sec.name = 'ALL_COV';

exec_procs(config);
%system(['chmod 777 -R /dados1/PROJETOS/' prjdir]);
