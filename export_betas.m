% Extraction of Betas
init;
%(1) Directories:
curdir = pwd;
data_dir = '/dados1/PROJETOS/PRJ1016_PRIMING/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/BETAS/MOV_SIMPLE_NOHRF';
rois_dir = '/dados1/PROJETOS/PRJ1016_PRIMING/03_PROCS/ROIs';
out_dir  = pwd;

%(2) the names of the participant subfolders
subjs = 1:45;
subjsIgnore = [1:7 12 13 15 16 19 24 32 38 40 41];
subjs = setdiff( subjs, subjsIgnore );
nsubs = length(subjs);

%(3) the ROI you have created in marsbar. You can put multiple ROIs
% here, but I thought it was easier to put in one at a time as the output is
% messy as is.
roi_files = {
    'mOFC_sphere_10--3_35_-13_roi'
    'NAcc_sphere_10-12_11_-13_roi'
    'DLPFC_sphere_10--24_26_32_roi'
};
n_roi = length( roi_files );
betas = cell( 1, n_roi );

spm('Defaults', 'fmri');
spmdir = fileparts(which( 'spm' ));
addpath( fullfile( spmdir, 'toolbox','marsbar' ) );

% global defaults
for n = 1: n_roi
    fprintf( 'loading ROI %s\n', roi_files{n} );
    roi_file = fullfile( rois_dir, roi_files{n} );
    load( roi_file );
    
    % pcs_data = [];
    for k = 1:nsubs
        subjid = sprintf('SUBJ%03d', subjs(k));
        subdir = fullfile( data_dir, subjid );
        fprintf('Working on participant %s\n',subdir);
        cd(subdir);
        
        pcs_data.(subjid) = extractBetas(subdir, roi_file);
    end
    
    betas{n} = pcs_data;
    
    %regname=char(SPM.xX.name(1,:));

    % (4) the file name (e.g., ROI co-ords) and type (e.g., .txt, .csv, .xls) to which you want your
    % percent signal change values to be saved.
    % regname = char (e_names);
    %/ fileOut = fullfile(out_dir, sprintf( 'betas_%s.xlsx', roi_files{n}));
    % fprintf( 'Writing results in file: %s\n', fileOut);
    % geraOut( fileOut, pcs_data);
end
cd(curdir);

addpath( fullfile(pwd, '..') );
respostas = extractInfosSupra( subjs );

[nL, nC] = size(respostas);
output = cell( nL, nC+n_roi );
output(1:nL, 1:nC) = respostas(:,:);
output(:, nC+1:end) = {0};
header = {'SUBJID', 'RUN', 'CLASS', 'DECISAO'};
for nRoi = 1:n_roi
    nCol = nC+nRoi;
    header{end+1} = roi_files{nRoi};
    %cruza_betas_respostas;
    cruza_betas;
end
outfile = 'betas.xlsx';
delete( outfile );
geraOut( outfile, { [header;output] });

% Incluindo header
%system('chmod 777 -R /dados1/PROJETOS/PRJ1016_PRIMING');