function export_from_raw_data( config )
import utils.Var;

raw_base = config.raw_base;
preproc_base = config.preproc_base;
nrun = config.nrun;
anat_prefix = config.anat_prefix;
subjs = config.subjs;

% Steps
fieldmap = Var.get(config, 'fieldmap', 0);
norm_anat = Var.get(config, 'norm_anat', 1);

% BIDS
BIDS = Var.get(config, 'BIDS', BIDS_struct);
BIDS.task = Var.get(config, 'task', '');

if ~isfield(config, 'start_prefix')
    config.start_prefix = '';
end

%% start of pipeline
if ~isdir( preproc_base ), mkdir( preproc_base ); end

for i = 1:length(subjs)
    name_subj = get_subjid(config, subjs(i));
    
    disp (['Exporting data for subject: ', name_subj ]);
    
    %%%%%%%%%%%%% Prepare Directory structure %%%%%%%%%
    % create subject directory for preprocessing data %
    sdirs = dir( fullfile( raw_base, [get_subjid(config, subjs(i), false) '*']) );
    
    % treat first and second visit
    for vis = 1:length(sdirs)
        preproc_dir = fullfile( preproc_base, name_subj ) ;
        
        if ~isdir( preproc_dir ),
            mkdir( preproc_dir );
        else
            fprintf('preproc directory %s already exists', preproc_dir );
        end
        
        raw_dir = fullfile( raw_base, sdirs(vis).name );
        
        %% Exporting FUNC data
        pattern = sprintf('*task-%s*.nii*', BIDS.task);
        raw_files = utils.resolve_names( fullfile( raw_dir, BIDS.func_dir, pattern ) );
        
        % Checking number of RUNs
        if length(raw_files) ~= nrun
            error( 'Number of functional runs different of %d.', nrun );
        end
        
        for raw_file = raw_files
            outdir = fullfile( preproc_dir, BIDS.func_dir );
            file = regexprep(raw_file{1}, '.nii.*$', ''); % Removing extension
            copy_gunzip(file, outdir);
        end
        
        %% Exporting ANAT data
        if norm_anat
            pattern = sprintf('*%s*.nii*', BIDS.anat_modality);
            raw_files = utils.resolve_names( fullfile( raw_dir, BIDS.anat_dir, pattern ) );
            if length(raw_files) ~= 1
                error( 'anatomical directory not found or several matches found. Please clean up directory %s\n', fullfile( raw_dir, anat_prefix )  );
            end
            file = regexprep(raw_files{1}, '.nii.*$', ''); % Removing extension
            outdir = fullfile( preproc_dir, BIDS.anat_dir );
            copy_gunzip( file, outdir );
        end
        
        %% Exporting Field Mapping data
        if fieldmap
            raw_files = utils.resolve_names( fullfile( raw_dir, BIDS.fmap_dir, '*.nii*' ) );
            for raw_file = raw_files
                file = regexprep(raw_file{1}, '.nii.*$', ''); % Removing extension
                outdir = fullfile( preproc_dir, BIDS.fmap_dir );
                copy_gunzip( file, outdir );
            end
        end
    end % visit
end
end


function copy_gunzip( indir, outdir, suffix )
import utils.resolve_names;
if nargin < 3, suffix = '*'; end

files = utils.resolve_names( [indir suffix] );
if( ~isdir(outdir) )
    mkdir( outdir );
end
for file=files
    copyfile( file{1}, outdir, 'f' );
end

gunzip_dir(outdir);

end

% Function to extract all gunzip files inside a folder
function gunzip_dir(dir_files)

% Try gunzip all gz files
try
    cmd = sprintf('find %s -name "*.gz" -type f -exec gunzip -f "{}" \\;', dir_files);
    system( cmd );
catch
    gunzip(fullfile(dir_files, '*.gz'))
end
end
