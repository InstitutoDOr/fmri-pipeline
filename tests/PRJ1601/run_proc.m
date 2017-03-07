config_main; % Pré-configura o processamento deste projeto

%% subjects
config.subj_prefix = 'S';

%% EDITAR AQUI PARA CONFIGURAR O QUE RODAR
config.subjs = [1:6] + 1601000;
config.subjid_complete = 0;
config.only_recalculate_contrasts = 0;
config.only_estimate = 0;
config.mov_regressor = 1;
config.resp_regressor = 0;
config.only_batch_files = 0;
config.norm_anat = 1; %Informa se faz ou não a normalizacao anatomica
config.preserve_indir = 0; % Mantem o nome dos diretorios
config.export_from_raw_data = 1;

if( ~config.norm_anat )
    config.preproc_name    = 'NORM';
    config.preproc_base    = fullfile( config.dir_base, 'PREPROC_DATA', 'fMRI', config.preproc_name );
    config.proc_base       = fullfile( config.dir_base, 'PROC_DATA', 'fMRI', config.preproc_name );
end

config.do.preprocessing = 1;
config.do.first_level   = 0;
config.do.second_level  = 0;
config.do.extract_betas = 0;
config.start_prefix     = '';
 
%% Modelos
%config.model = model_test();

%% FIRST LEVEL
config.presentation = 0;
config.first_level_preproc_prefix = 'swar';
    
%config.HPF = 128;
%config.HPF = 320;

%% SECOND LEVEL
config.sec.g1 = config.subjs;
config.sec.g1_name = 'NFB';
config.sec.g2 = [];
config.sec.g2_name = 'CTL';
config.sec.name = 'ONE_SAMPLE';

exec_procs(config);