test_bootstrap;

tmp_dir = fullfile(pwd, 'tmp');

config.norm_anat = 1;
dirout = 'fMRI_ANAT';

%% GENERAL PARAMETERS
config.preproc_name  = 'MBI';
config.dir_base        = '/dados1/PROJETOS/PRJ1411_NFB_VR/03_PROCS';
config.raw_base        = fullfile( config.dir_base, 'RAW_DATA', 'NII', 'MELBOURNE' );
config.preproc_base    = fullfile( config.dir_base, 'PREPROC_DATA', dirout, config.preproc_name );
%config.proc_base       = fullfile( config.dir_base, 'PROC_DATA', dirout, 'SEM_SLICE_TIMING' );
config.proc_base       = fullfile( tmp_dir, 'PROC_DATA', dirout );
config.sliceorder = [2:2:24 1:2:24];
config.export_from_raw_data = 1;

config.runs_prefix = { 'RUN*1', 'RUN*2', 'RUN*3', 'RUN*4' }; 
config.run_file_prefix = 'FUNC*';
config.run_file_suffix = '4D';

config.anat_prefix = '3D_T1*';
config.anat_file = 'RAI.nii';

%% subjects
config.subj_prefix = 'SUBJ';

%% EDITAR AQUI PARA CONFIGURAR O QUE RODAR
config.subjs = [ 1:3 5 ];
%config.subjs = 1;
config.only_recalculate_contrasts = 0;
config.only_estimate = 0;
config.only_batch_files = 0;
config.mov_regressor = 1;
config.resp_regressor = 0;

%Etapas do processamento
config.do.preprocessing = 0; % 0 ou 1;
config.do.first_level   = 1;
config.do.second_level  = 0;
config.do.extract_betas = 1;

%Configurando PREPROC
config.realign = 1;
config.norm_anat = 1;
config.slice_timing = 1;
config.presentation = 0;
config.start_prefix = '';

%ART Outliers
config.art_outliers = 1;
config.outliers.SUBJ001_1_SVM_BABA = [536 537];
config.outliers.SUBJ002_2_ROI_ABAB = [1093 1094];
config.outliers.SUBJ005_1_ROI_BABA = [428 584 585 611 612 614 615 616 617 618 620 621 816 817 817 819 820 848 849 850 851 1029 1030 1162 1163];

%% resolving SUBJS name
subjs = {};
for nsubj = config.subjs
    subjs{end+1} = sprintf('%s%03d*SVM*',config.subj_prefix, nsubj);
    subjs{end+1} = sprintf('%s%03d*ROI*',config.subj_prefix, nsubj);
end
config.subjs = subjs;
    
%% inicializar uma vez o struct
config.model = {@get_model_MBI, @get_model_MBI_semneutro};    
config.model = {@get_model_MBI_semneutro};
config.model = {@get_model_MBI_NFB};
    
 %% FIRST LEVEL
if config.do.first_level
    config.first_level_preproc_prefix = 'swar';
end

if config.do.second_level
    config.model(m).contrast(10:end) = []; %limpando contrastes que não queremos para o second level
    config.sec.g1 = [2:7 9 10];
    config.sec.g2 = [];
    config.sec.name = 'ALL';
end

exec_procs(config);