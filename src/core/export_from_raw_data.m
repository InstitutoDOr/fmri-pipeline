function export_from_raw_data( config )
import utils.Var;

raw_base = config.raw_base;
preproc_base = config.preproc_base;
nrun = config.nrun;
subjs = config.subjs;
runs_prefix = config.runs_prefix;
run_file_prefix = config.run_file_prefix;
run_file_suffix = config.run_file_suffix;
preserve_indir = ~isempty( Var.get(config, 'runs_dir', [])) && (length(config.runs_dir) == length(config.runs_prefix));
anat_prefix = config.anat_prefix;
anat_file = config.anat_file;
fieldmap_prefix = Var.get(config, 'fieldmap_prefix', []);

% Steps
fieldmap = Var.get(config, 'fieldmap', 0);
norm_anat = Var.get(config, 'norm_anat', 1);

if ~isfield(config, 'start_prefix')
    config.start_prefix = '';
end

%% start of pipeline
if ~isdir( preproc_base ), mkdir( preproc_base ); end

for i = 1:length(subjs)
    name_subj = get_subjid(config, subjs(i));
    preproc_dir = fullfile( preproc_base, name_subj ) ;
    
    disp (['Exporting data for subject: ', name_subj ]);
    
    %%%%%%%%%%%%% Prepare Directory structure %%%%%%%%%
    % create subject directory for preprocessing data %
    sdirs = dir( fullfile( raw_base, [get_subjid(config, subjs(i), false) '*']) );
    
    raw_dir = fullfile( raw_base, sdirs(1).name );
            
    for r=1:nrun
        
        raw_dir_run = dir( fullfile( raw_dir, runs_prefix{r} ) );
        if length(raw_dir_run) ~= 1
            error( 'run not found or several matches found. Please clean up directory %s\n', fullfile( raw_dir, runs_prefix{r} )  );
        end
        
        indir = fullfile( raw_dir, raw_dir_run(1).name );
        indir = strrep(indir, '{rn}', num2str(r) );
        prefix = sprintf( '%s%s.nii*', run_file_prefix, run_file_suffix );
        prefix = strrep(prefix, '{rn}', num2str(r) );
        
        if preserve_indir
            outdir = fullfile( preproc_dir, config.runs_dir{r} );
        else
            outdir = fullfile( preproc_dir, sprintf( 'RUN%i', r) );
        end
        copy_gunzip(indir, outdir, prefix);
        
    end
    
    if norm_anat
        raw_dir_run = dir( fullfile( raw_dir, anat_prefix ) );
        if length(raw_dir_run) ~= 1
            error( 'anatomical directory not found or several matches found. Please clean up directory %s\n', fullfile( raw_dir, anat_prefix )  );
        end
        indir  = fullfile( raw_dir, raw_dir_run(1).name );
        outdir = fullfile( preproc_dir, sprintf( 'ANAT') );
        copy_gunzip( indir, outdir, [anat_file '*.gz'] );
    end
    
    if fieldmap
        
        fms = utils.resolve_names( fullfile( raw_dir, fieldmap_prefix, '*.nii*' ) );
        fms = sort(fms);
        if length(fms) ~= 2
            error('two files for fieldmap expected')
        end
        fmnames = { 'MAG', 'PHASE' };
        for k=1:2
            ext = regexp(fms{k},'\.nii(\.gz)*$', 'match', 'once');
            outdir = fullfile( preproc_dir, 'FIELDMAP' );
            outfile = fullfile(outdir, [fmnames{k} ext]);
            fmapfiles{k} = regexprep(outfile, '\.gz$', '');
            if ~ isdir(outdir)
                mkdir(outdir)
            end
            copyfile(fms{k}, outfile);
        end
        
        gunzip_dir(outdir);
    end
end
end


function copy_gunzip( indir, outdir, pattern )
import utils.resolve_names;
if nargin < 3, pattern = '*.gz'; end

files = utils.resolve_names( fullfile(indir, pattern) );
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

