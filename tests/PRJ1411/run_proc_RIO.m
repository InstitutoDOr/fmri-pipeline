bootstrap;

config.norm_anat = 1;
dirout = 'fMRI_ANAT';

%% GENERAL PARAMETERS
config.preproc_name  = 'RIO';
config.dir_base        = '/dados1/PROJETOS/PRJ1411_NFB_VR/03_PROCS';
config.raw_base        = fullfile( config.dir_base, 'RAW_DATA', 'NII' );
config.preproc_base    = fullfile( config.dir_base, 'PREPROC_DATA', dirout, config.preproc_name );
config.proc_base       = fullfile( config.dir_base, 'PROC_DATA', dirout );
config.export_from_raw_data = 1;

config.runs_prefix = { '*RUN1*', '*RUN2*', '*RUN3*', '*RUN4*' }; 
config.run_file_prefix = 'fMRIRUN*';
config.run_file_suffix = 'PRJ1411SENSE';

config.anat_prefix = '3DT1_PRJ1411*';
config.anat_file = '3DT1PRJ1411SENSE.nii';

config.subjsOnsets = {
    {'SUBJ002', 'SVM', 'A'}
    {'SUBJ003', 'ROI', 'A'}
    {'SUBJ004', 'SVM', 'B'}
    {'SUBJ005', 'ROI', 'A'}
    {'SUBJ006', 'ROI', 'B'}
    {'SUBJ007', 'SVM', 'A'}
    {'SUBJ009', 'ROI', 'A'}
    {'SUBJ010', 'SVM', 'A'}
};

for nS = 1:length(config.subjsOnsets)
    config.subjs_labels{nS} = sprintf('%s_%s', ...
        config.subjsOnsets{nS}{1}, ...
        config.subjsOnsets{nS}{2});
end

%% subjects
config.subj_prefix = 'SUBJ';

%% EDITAR AQUI PARA CONFIGURAR O QUE RODAR
config.subjs = [ 2:7 9 10 ];
%config.subjs = [3 5 6 9]; %ROI
%config.subjs = [3 5 6 7 9];
config.only_recalculate_contrasts = 0;
config.only_estimate = 0;
config.only_batch_files = 0;
config.mov_regressor = 1;
config.resp_regressor = 0;

config.do.preprocessing = 1; % 0 ou 1;
config.do.first_level   = 1;
config.do.second_level  = 0;
config.do.extract_betas = 0;

%Configurando PREPROC
config.realign = 1;
config.slice_timing = 1;
config.presentation = 0;
config.start_prefix = '';

%ART Outliers
config.art_outliers = 1;
config.outliers.SUBJ005_ROI = [535 536 1026 1027 1028];
config.outliers.SUBJ006_ROI = [1180 1181];
config.outliers.SUBJ007_SVM = [263 264 884 885 887 888 998 999];
config.outliers.SUBJ009_ROI = [1149 1150];

%% inicializar uma vez o struct
config.model = {@get_model_RIO, @get_model_RIO_semneutro};
config.model = {@get_model_RIO_semneutro};
config.model = {@get_model_RIO_NFB};
    
%% FIRST LEVEL
if config.do.first_level
    config.first_level_preproc_prefix = 'swar';
end

%% SECOND LEVEL
if config.do.second_level
    config.sec.g1 = [2:7 9 10];
    config.sec.g2 = [];
    config.sec.name = 'ALL';
    run_second_level( config );
end

exec_procs(config);
