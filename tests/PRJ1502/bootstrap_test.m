%% bootstrap
%execRec('/dados1/PROJETOS/PRJ1502_NFB_MOTOR_II/03_PROCS/RAW_DATA', @limpaWIP);
init;

% Abre SPM para gerar gráficos
if isempty(spm('Figname'))
    spm fmri;
end

tmp_dir = fullfile(pwd, 'tmp');

%% configurations 
config = [];

%% GENERAL PARAMETERS
config.preproc_name    = 'NORM_ANAT';
config.dir_base        = '/dados1/PROJETOS/PRJ1502_NFB_MOTOR_II/03_PROCS/';
config.raw_base        = fullfile( config.dir_base, 'RAW_DATA', 'NII' );
config.preproc_base    = fullfile( tmp_dir, 'PREPROC_DATA', 'fMRI', config.preproc_name );
config.proc_base       = fullfile( tmp_dir, 'PROC_DATA', 'fMRI', config.preproc_name );
config.nrun = 2;
config.nvol = 100;
config.ncorte = 40;
config.TR = 2;
config.TA = 1.675;
config.TA = config.TA - (config.TA/config.ncorte);
config.smooth = [6 6 6];
config.export_from_raw_data = 1;
config.together = 1;
%config.mask = {'/dados1/PROJETOS/PRJ1502_NFB_MOTOR_II/03_PROCS/PREPROC_DATA/fMRI/NORM_ANAT/PILO008/brainmask_SUBJ008.nii'};

config.runs_prefix = { '*IMAG_1*', '*NFB_TREINO*' }; 
config.runs_dir = { 'IMAG_1', 'NFB_TREINO' }; 
config.start_prefix = '';
config.run_file_prefix = 'WIP*';
config.run_file_suffix = '';

config.anat_prefix = '3D_T1_PRJ1502*';
config.anat_file = 'WIP3DT1PRJ1502SENSE.nii';

%% subjects
config.subj_prefix = 'SUBJ';

%% configure paths
config.spm_dir = fileparts( which( 'spm' ) );
%addpath( genpath( fullfile( config.dir_base, 'SCRIPTS') ) );