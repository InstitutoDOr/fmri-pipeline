function preprocessing( config )
import utils.Var;

preproc_name = config.preproc_name;
dir_base = config.dir_base;
raw_base = config.raw_base;
preproc_base = config.preproc_base;
nrun = config.nrun;
nvol = config.nvol;
ncorte = config.ncorte;
TR = config.TR;
TA = config.TA;
if( isfield(config, 'sliceorder') )
    sliceorder = config.sliceorder;
else
    sliceorder = [1:ncorte];
end
smooth = config.smooth;
export_from_raw_data = config.export_from_raw_data;
runs_prefix = config.runs_prefix;
run_file_prefix = config.run_file_prefix;
run_file_suffix = config.run_file_suffix;
anat_prefix = config.anat_prefix;
anat_file = config.anat_file;
subjs = config.subjs;
subj_prefix = config.subj_prefix;
preserve_indir = ~isempty( Var.get(config, 'runs_dir', [])) && (length(config.runs_dir) == length(config.runs_prefix));
fieldmap_prefix = Var.get(config, 'fieldmap_prefix', []);

% Steps
fieldmap = Var.get(config, 'fieldmap', 0);
realign = Var.get(config, 'realign', 1);
slice_timing = Var.get(config, 'slice_timing', 1);
norm_anat = Var.get(config, 'norm_anat', 1);
norm_EPI = Var.get(config, 'norm_EPI', 1);
smoothing = Var.get(config, 'smoothing', 1);

if ~isfield(config, 'start_prefix')
    config.start_prefix = '';
end
start_prefix = Var.get(config, 'start_prefix', '');

spm_dir = fileparts( which( 'spm' ) );

%% start of pipeline
if ~isdir( preproc_base ), mkdir( preproc_base ); end

for i = 1:length(subjs)
    files = {};
    name_subj{i} = get_subjid(config, subjs(i));
    
    disp (['Preprocessing for subject: ', name_subj{i} ]);
    
    %%%%%%%%%%%%% Prepare Directory structure %%%%%%%%%
    % create subject directory for preprocessing data %
    sdirs = dir( fullfile( raw_base, [get_subjid(config, subjs(i), false) '*']) );
    
    % treat first and second visit
    for vis = 1:length(sdirs)
        current_prefix = start_prefix;
        preproc_dir = fullfile( preproc_base, name_subj{i} ) ;
        
        if ~isdir( preproc_dir ),
            mkdir( preproc_dir );
        else
            disp( sprintf('preproc directory %s already exists', preproc_dir ) );
        end
        
        cd( preproc_dir )
        
        %%%%%%% Fieldmap %%%%%%%%%%
        if fieldmap
            fmapdir          = fullfile( preproc_dir, 'FIELDMAP' );
            fmap.phase       = fullfile( fmapdir, 'PHASE.nii,1');
            fmap.mag         = fullfile( fmapdir, 'MAG.nii,1');
            fmap.TEs         = config.fieldmapTEs;
            fmap.readoutTime = config.fieldmapReadoutTime;
            fmap.anat        = fullfile( preproc_dir, 'ANAT', [anat_file ',1'] );
            clear matlabbatch;
            calculate_VDM;
            files(end+1).name = fullfile( preproc_dir, 'BATCH_%d_UNWARP.mat');
            files(end).matlabbatch = matlabbatch;
            files(end).message = sprintf( 'Unwarping for subject: %s\n%s\n', name_subj{i}, preproc_dir);
        end
        
        %%%%%%% Realignment %%%%%%%%%%
        if realign
            clear matlabbatch;
            realignment;
            files(end+1).name = fullfile( preproc_dir, 'BATCH_%d_REALIGN.mat');
            files(end).matlabbatch = matlabbatch;
            files(end).message = sprintf( 'Realignment for subject: %s\n%s\n', name_subj{i}, preproc_dir);
            
            normpdf = utils.correctFilename( sprintf('mov_%s.pdf', name_subj{i} ) );
            files(end).execs = {'utils.ps2pdf_alt( ''psfile'', [''spm_'' datestr(now, ''yyyymmmdd'') ''.ps''], ''pdffile'', ''' normpdf ''');'};
            current_prefix = ['r' current_prefix];
        end
        
        %%%%%%% Slicetiming %%%%%%%%%%
        if slice_timing
            clear matlabbatch;
            slicetiming;
            files(end+1).name = fullfile( preproc_dir, 'BATCH_%d_SLICETIME.mat');
            files(end).matlabbatch = matlabbatch;
            files(end).message = sprintf( 'Slicetiming for subject: %s\n%s\n', name_subj{i}, preproc_dir);
            current_prefix = ['a' current_prefix];
        end
        
        %%%%%%% Normalization %%%%%%%
        if norm_anat
            if strcmp(spm('Ver'), 'SPM8')
                preproc_norm_anat_spm8
                current_prefix = ['w' current_prefix];
            else
                clear matlabbatch
                preproc_norm_anat;
                
                %% Setting execution script
                files(end+1).name = fullfile( preproc_dir, 'BATCH_%d_NORM_ANAT.mat');
                files(end).matlabbatch = matlabbatch;
                files(end).message = sprintf( 'Normalization structural images for subject: %s\n%s\n', name_subj{i}, preproc_dir );
                
                normpdf = utils.correctFilename( sprintf('norm_%s.pdf', name_subj{i} ) );
                files(end).execs = {'utils.ps2pdf_alt( ''psfile'', [''spm_'' datestr(now, ''yyyymmmdd'') ''.ps''], ''pdffile'', ''' normpdf ''');'};
                current_prefix = ['w' current_prefix];
            end
        elseif norm_EPI
            %%%%%%% Normalization %%%%%%%%%%%%
            clear matlabbatch;
            normalize_affine
            files(end+1).name = fullfile( preproc_dir, 'BATCH_%d_NORM_AFFINE.mat');
            files(end).matlabbatch = matlabbatch;
            files(end).message = sprintf( 'Normalization structural images for subject: %s\n%s\n', name_subj{i}, preproc_dir );
            
            normpdf = utils.correctFilename( sprintf('norm_%s.pdf', name_subj{i} ) );
            files(end).execs = {'utils.ps2pdf_alt( ''psfile'', [''spm_'' datestr(now, ''yyyymmmdd'') ''.ps''], ''pdffile'', ''' normpdf ''');'};
            current_prefix = ['w' current_prefix];
        end
        
        
        %%%%%%% Smoothing functional images  %%%%%%%%%%%%
        if smoothing
            clear matlabbatch;
            smooth_batch;
            files(end+1).name = fullfile( preproc_dir, 'BATCH_%d_SMOOTH.mat');
            files(end).matlabbatch = matlabbatch;
            files(end).message = sprintf( 'Smoothing functional images for subject: %s\n%s\n', name_subj{i}, preproc_dir);
            current_prefix = ['s' current_prefix];
        end
        
        if ~config.only_batch_files
            execSpmFiles( files )
        end;
        
    end; % visit
end;

cd ..

try
    ps2pdf( 'psfile', ['spm_' datestr(now, 'yyyymmmdd') '.ps'], 'pdffile', ['all_' datestr(now, 'yyyymmmdd') '.pdf'] );
catch
    warning( 'could not find ps file' )
end
end

