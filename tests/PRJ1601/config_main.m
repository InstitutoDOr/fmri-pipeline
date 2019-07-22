init;

% Abre SPM para gerar gráficos
if isempty(spm('Figname'))
    spm fmri;
end

tmp_dir = fullfile(pwd, 'tmp');

%% configurations 
config = [];

%% GENERAL PARAMETERS
config.preproc_name    = 'NAF'; % NORM_ANAT_FIELD
config.dir_base        = '/dados1/PROJETOS/PRJ1601_NFB_MOTIV/03_PROCS/';
config.raw_base        = fullfile( config.dir_base, 'RAW_DATA', 'NII' );
config.preproc_base    = fullfile( config.dir_base, 'PREPROC_DATA', 'fMRI', config.preproc_name );
config.proc_base       = fullfile( config.dir_base, 'PROC_DATA', 'fMRI', config.preproc_name );
config.nrun = 4;
config.nvol = 160;
config.ncorte = 37;
config.TR = 2;
config.TA = 1.925; % last slice time onset, extracted with gdcmdump
config.slicetype = 'interleaved';
config.sliceorder = get_sliceorder(config.slicetype, config.ncorte); 

config.smooth = [6 6 6];
config.export_from_raw_data = 1;
config.together = 1;
%config.mask = {'/dados1/PROJETOS/PRJ1502_NFB_MOTOR_II/03_PROCS/PREPROC_DATA/fMRI/NORM_ANAT/PILO008/brainmask_SUBJ008.nii'};

config.fieldmap = 1;
config.fieldmapTEs = [4.92 7.38]; % look-up in dicom of magnitude and phase image: Echo Time in Tag (0018,0081)
config.fieldmapReadoutTime = 1000/60.096; % look-up in dicom of EPI sequences: (0019,1028)
config.fieldmap_prefix = 'gre_field_mapping_AP_PRJ1601*';
config.runs_prefix = { '*ep2d_pace_moco_RUN1_PRJ1601*', '*ep2d_pace_moco_RUN2_PRJ1601*', '*ep2d_pace_moco_RUN3_PRJ1601*', '*ep2d_pace_moco_RUN4_PRJ1601*',  }; 
config.runs_dir = { 'RUN1', 'RUN2','RUN3', 'RUN4' }; 
config.start_prefix = '';
config.run_file_prefix = '*';
config.run_file_suffix = '';

config.anat_prefix = 't1_mprage_sag_p3_iso_PRJ1601*';
config.anat_file = 't1mpragesagp3isoPRJ1601.nii';

%% subjects
config.subj_prefix = 'SUBJ';

%% configure paths
config.spm_dir = fileparts( which( 'spm' ) );
%addpath( genpath( fullfile( config.dir_base, 'SCRIPTS') ) );