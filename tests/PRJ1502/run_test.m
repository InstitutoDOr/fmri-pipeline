bootstrap_test; % Pré-configura o processamento deste projeto

%% subjects
config.subj_prefix = 'SUBJ';

%% EDITAR AQUI PARA CONFIGURAR O QUE RODAR
config.subjs = 1;
config.subjid_complete = 1;
config.only_recalculate_contrasts = 0;
config.only_estimate = 0;
config.mov_regressor = 1;
config.resp_regressor = 0;
config.only_batch_files = 0;
config.norm_anat = 1; %Informa se faz ou não a normalizacao anatomica
config.preserve_indir = 1; % Mantem o nome dos diretorios
config.export_from_raw_data = 1;

if( ~config.norm_anat )
    config.preproc_name    = 'NORM';
    config.preproc_base    = fullfile( config.dir_base, 'PREPROC_DATA', 'fMRI', config.preproc_name );
    config.proc_base       = fullfile( config.dir_base, 'PROC_DATA', 'fMRI', config.preproc_name );
end

config.do.preprocessing = 0;
config.do.first_level   = 1;
config.do.second_level  = 1;
config.do.extract_betas = 1;
config.start_prefix     = '';
 
%% Modelos
config.model = model_test();

%% FIRST LEVEL
config.presentation = 0;
config.first_level_preproc_prefix = 'swar';
    
%config.HPF = 128;
%config.HPF = 320;

%% SECOND LEVEL
config.sec.g1 = 1;
config.sec.g1_name = 'NFB';
config.sec.g2 = 1;
config.sec.g2_name = 'CTL';
config.sec.name = 'TWO_SAMPLE';

exec_procs(config);