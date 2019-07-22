init;

% Abre SPM para gerar gráficos
if isempty(spm('Figname'))
    spm12;
end

%% bootstrap
prjid = 'PRJ1406';
prjdir = 'PRJ1406_SINTAXE_E_VALORES';
execRec( fullfile('/dados1/PROJETOS', prjdir, '03_PROCS/RAW_DATA'), @limpaWIP);

%% configurations
config = [];

%% GENERAL PARAMETERS
config.preproc_name  = 'NORM_ANAT';
config.dir_base      = '/dados1/PROJETOS/PRJ1406_SINTAXE_E_VALORES/03_PROCS/';
config.raw_base      = fullfile( config.dir_base, 'RAW_DATA', 'NII' );
config.preproc_base  = fullfile( config.dir_base, 'PREPROC_DATA', 'fMRI', config.preproc_name );
config.proc_base     = fullfile( config.dir_base, 'PROC_DATA', 'fMRI', config.preproc_name );
config.nrun = 4;
config.nvol = 258;
config.ncorte = 40;
config.TR = 2;
config.TA = 1.675;
config.TA = config.TA - (config.TA/config.ncorte);
config.smooth = [6 6 6];
config.export_from_raw_data = 1;

config.runs_prefix = { 'fMRI_RUN1*', 'fMRI_RUN2*', 'fMRI_RUN3*', 'fMRI_RUN4*' };
config.run_file_prefix = 'fMRIRUN*';
config.run_file_suffix = 'PRJ1406SENSE';

config.anat_prefix = '3D_T1_PRJ1406*';
config.anat_file = '3DT1PRJ1406SENSE.nii';

%% subjects
config.subj_prefix = 'SUBJ';

%% MUST EXIST
config.subjs = [];
config.do.preprocessing = 0;
config.do.first_level   = 0;
config.do.second_level  = 0;
config.do.extract_betas  = 0;
config.only_recalculate_contrasts = 0;
config.only_estimate = 0;
config.only_batch_files = 0;
config.mov_regressor = 1;
config.resp_regressor = 0;
config.presentation = 1;

%% configure paths
config.spm_dir = fileparts( which( 'spm' ) );