bootstrap; % Pré-configura o processamento deste projeto

%% subjects
config.subj_prefix = 'SUBJ';

%% EDITAR AQUI PARA CONFIGURAR O QUE RODAR
subjs = 1;
subjsIgnore = [5 6 18 40 42:50]; %Sujeitos que precisam ser removidos
config.subjs = setdiff( subjs, subjsIgnore );
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
    config.preproc_name  = 'NORM';
    config.preproc_base    = fullfile( config.dir_base, 'PREPROC_DATA', 'fMRI', config.preproc_name );
    config.proc_base       = fullfile( config.dir_base, 'PROC_DATA', 'fMRI', config.preproc_name );
end

config.do.preprocessing = 1;
config.do.first_level   = 1;
config.do.second_level  = 1;
config.do.extract_betas  = 1;
config.start_prefix = '';
 
%% Modelos
if config.mov_regressor
    config.model = get_model(); %Com parâmetros de movimento
    config.mov_reg_pat = 'rp_%s*smart.txt';
    config.model.name = [config.model.name '_SMART'];
else
    config.model = get_model_sem_mov(); %Sem parâmetros de movimento
end

%% FIRST LEVEL
config.presentation = 0;
config.first_level_preproc_prefix = 'swar';
    
%config.HPF = 128;
%config.HPF = 320;

%% SECOND LEVEL
[g1 g2] = groups( subjsIgnore );
config.sec.g1 = g1;
config.sec.g1_name = 'NFB';
config.sec.g2 = g2;
config.sec.g2_name = 'CTL';
config.sec.name = 'TWO_SAMPLE';

exec_procs(config);