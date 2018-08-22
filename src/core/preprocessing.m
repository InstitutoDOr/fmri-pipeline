function preprocessing( config )
import utils.Var;

preproc_name = config.preproc_name;
dir_base = config.dir_base;
raw_base = config.raw_base;
bids_dir = Var.get( config, 'bids_dir', config.raw_base );
task_details = loadjson( utils.resolve_name( [bids_dir '/*task-' config.task '_*.json'] ) );

preproc_base = config.preproc_base;
smooth = config.smooth;
subjs = config.subjs;
subj_prefix = config.subj_prefix;

% Steps
fieldmap = Var.get(config, 'fieldmap', 0);
realign = Var.get(config, 'realign', 1);
slice_timing = Var.get(config, 'slice_timing', 1);
norm_anat = Var.get(config, 'norm_anat', 1);
norm_EPI = Var.get(config, 'norm_EPI', 1);
smoothing = Var.get(config, 'smoothing', 1);

% BIDS
BIDS = Var.get(config, 'BIDS', BIDS_struct);
BIDS.task = Var.get(config, 'task', '');

start_prefix = Var.get(config, 'start_prefix', '');

spm_dir = spm('Dir');

%% start of pipeline
if ~isdir( preproc_base ), mkdir( preproc_base ); end

for i = 1:length(subjs)
    name_subj = get_subjid(config, subjs(i));
    
    disp (['Preprocessing for subject: ', name_subj ]);
    
    %%%%%%%%%%%%% Prepare Directory structure %%%%%%%%%
    % create subject directory for preprocessing data %
    raw_dir  = fullfile( bids_dir, name_subj );
    ses_dirs = utils.resolve_names( fullfile(raw_dir, 'ses-*') );
    % If not a longitudinal study, use the raw_dir
    if isempty(ses_dirs)
        ses_dirs = raw_dir;
    end
    
    % treat first and second nsit
    for ns = 1:length(ses_dirs)
        files = {}; % Files to run with SPM
        bids_dir = ses_dirs{ns};
        ses_name = regexp(bids_dir, 'ses-\w+$', 'match', 'once');
        batch_prefix = [ses_name 'BATCH_'];
        current_prefix = start_prefix;
        
        preproc_dir = fullfile( preproc_base, name_subj );
        anat_file = utils.resolve_name( fullfile( preproc_dir, BIDS.anat_dir, ['*_' config.anat_suffix '.nii*']) );
        funcs = neuro.bids.get_scans( fullfile(preproc_dir, BIDS.func_dir), ['sub-*task-' config.task] );
        
        %%%%%%% Fieldmap %%%%%%%%%%
        if fieldmap
            fmapdir          = fullfile( preproc_dir, BIDS.fmap_dir );
            fmap.phase       = [utils.resolve_name(fullfile( fmapdir, 'sub-*_phase*.nii')) ',1'];
            fmap.phase_hdr   = neuro.bids.loadjson( fmap.phase );
            fmap.mag         = [utils.resolve_name(fullfile( fmapdir, 'sub-*_magnitude*.nii')) ',1'];
            fmap.TEs         = [fmap.phase_hdr.EchoTime1 fmap.phase_hdr.EchoTime2] * 1000;
            fmap.readoutTime = 1000 / task_details.BandwidthPerPixelPhaseEncode;
            fmap.anat        = [anat_file ',1'];
            fmap.suffix      = 'func_run-';
            clear matlabbatch;
            calculate_VDM;
            files(end+1).name = fullfile( preproc_dir, [batch_prefix '%d_UNWARP.mat']);
            files(end).matlabbatch = matlabbatch;
            files(end).message = sprintf( 'Unwarping for subject: %s\n%s\n', name_subj, preproc_dir);
        end
        
        %%%%%%% Realignment %%%%%%%%%%
        if realign
            clear matlabbatch;
            realignment;
            files(end+1).name = fullfile( preproc_dir, [batch_prefix '%d_REALIGN.mat']);
            files(end).matlabbatch = matlabbatch;
            files(end).message = sprintf( 'Realignment for subject: %s\n%s\n', name_subj, preproc_dir);
            
            normpdf = utils.correctFilename( sprintf('mov_%s.pdf', name_subj ) );
            files(end).execs = {'utils.ps2pdf_alt( ''psfile'', [''spm_'' datestr(now, ''yyyymmmdd'') ''.ps''], ''pdffile'', ''' normpdf ''');'};
            current_prefix = ['r' current_prefix];
        end
        
        %%%%%%% Slicetiming %%%%%%%%%%
        if slice_timing
            clear matlabbatch;
            slicetiming;
            files(end+1).name = fullfile( preproc_dir, [batch_prefix '%d_SLICETIME.mat']);
            files(end).matlabbatch = matlabbatch;
            files(end).message = sprintf( 'Slicetiming for subject: %s\n%s\n', name_subj, preproc_dir);
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
                files(end+1).name = fullfile( preproc_dir, [batch_prefix '%d_NORM_ANAT.mat']);
                files(end).matlabbatch = matlabbatch;
                files(end).message = sprintf( 'Normalization structural images for subject: %s\n%s\n', name_subj, preproc_dir );
                
                normpdf = utils.correctFilename( sprintf('norm_%s.pdf', name_subj ) );
                files(end).execs = {'utils.ps2pdf_alt( ''psfile'', [''spm_'' datestr(now, ''yyyymmmdd'') ''.ps''], ''pdffile'', ''' normpdf ''');'};
                current_prefix = ['w' current_prefix];
            end
        elseif norm_EPI
            %%%%%%% Normalization %%%%%%%%%%%%
            clear matlabbatch;
            normalize_affine
            files(end+1).name = fullfile( preproc_dir, [batch_prefix '%d_NORM_AFFINE.mat']);
            files(end).matlabbatch = matlabbatch;
            files(end).message = sprintf( 'Normalization structural images for subject: %s\n%s\n', name_subj, preproc_dir );
            
            normpdf = utils.correctFilename( sprintf('norm_%s.pdf', name_subj ) );
            files(end).execs = {'utils.ps2pdf_alt( ''psfile'', [''spm_'' datestr(now, ''yyyymmmdd'') ''.ps''], ''pdffile'', ''' normpdf ''');'};
            current_prefix = ['w' current_prefix];
        end
        
        
        %%%%%%% Smoothing functional images  %%%%%%%%%%%%
        if smoothing
            clear matlabbatch;
            smooth_batch;
            files(end+1).name = fullfile( preproc_dir, [batch_prefix '%d_SMOOTH.mat']);
            files(end).matlabbatch = matlabbatch;
            files(end).message = sprintf( 'Smoothing functional images for subject: %s\n%s\n', name_subj, preproc_dir);
            current_prefix = ['s' current_prefix];
        end
        
        if ~config.only_batch_files
            execSpmFiles( files )
        end;
        
    end; % visit
end;

cd ..
end
