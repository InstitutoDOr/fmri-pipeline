function run_first_level( config )

for m = 1:length(config.model)
    
    for s=1:length(config.subjs)
        %% Defining subject name and preprocdir
        name_subj = get_subjid(config, config.subjs(s));
        
        %% checking model
        if iscell(config.model)
            model = config.model{m}(config, name_subj);
        else
            model = config.model(m);
        end
        
        % When model is resolved by a function, it can returned multiple
        % models that need to be treated as below
        for nM = 1:length(model)
            prepare_and_run_FL(config, name_subj, model(nM))
        end
        
    end
end
end


function prepare_and_run_FL( config, name_subj, model )
import utils.Var;

config.mask = Var.get( config, 'mask', {[spm('Dir') '/tpm/mask_ICV.nii,1']} );
bids_dir = Var.get( config, 'bids_dir', config.raw_base );
task_details = loadjson( utils.resolve_name( [bids_dir '/*task-' config.task '_*.json'] ) );

%%%%%%%%%% Getting BIDS Directory %%%%%%%%%
bids_subj_dir    = fullfile( bids_dir, name_subj );
visits    = utils.resolve_names( fullfile(bids_subj_dir, 'ses-*') );
% Treat all as one session
if isempty(visits)
    visits = [''];
end

preproc_dir = fullfile( config.preproc_base, name_subj );

%% set parameters first level
subdir_name = model.name;
if config.mov_regressor
    subdir_name = ['MOV_' subdir_name ];
end

if config.resp_regressor
    subdir_name = ['RESP_' subdir_name ];
end
dest_dir = fullfile( config.proc_base, 'STATS', 'FIRST_LEVEL',  subdir_name );
mov_reg_pat = Var.get(config, 'mov_reg_pat', 'rp_%s.txt');

for nv = 1:length(visits)
    visit = utils.path.basename(visits{nv});
    dest_dir_subj = fullfile( dest_dir, name_subj, visit );
    funcs = utils.resolve_names( fullfile(preproc_dir, [config.first_level_preproc_prefix '*' visit '*task-' config.task '*_bold.nii*']) );
    regressors = utils.resolve_names( fullfile(preproc_dir, 'func', ['*task-' config.task '*_events.tsv']) );
    events = utils.resolve_names( fullfile(bids_subj_dir, visit, 'func', ['*task-' config.task '*_events.tsv']) );
    outliers = Var.get(config.outliers, strrep(name_subj, 'sub-', ''), []);
    sessions = [];
    
    %% get conditions
    for r=1:length(funcs)
        func_base = regexp( utils.path.basename(funcs{r}), 'sub-.*_bold', 'match', 'once');
        conditions = extract_conditions( events{r}, Var.get(model, 'conditions', []) );
        
        sessions(r).names       = conditions.names;
        sessions(r).onsets      = conditions.onsets;
        sessions(r).durations   = conditions.durations;
        sessions(r).regcontrast = struct('name', {}, 'columns', {});
        sessions(r).pmod        = Var.get( conditions, 'pmod', [] );
        sessions(r).regfile     = [];
        
        %% MOVIMENT
        if config.mov_regressor
            mov_file = utils.resolve_name(fullfile(preproc_dir, sprintf(mov_reg_pat, func_base)));
            sessions(r).regfile = join_regressor( sessions(r).regfile, mov_file );
            sessions(r).regcontrast(end+1).name = 'MOV';
            sessions(r).regcontrast(end).columns = 6;
        end
        
        %% RESPIRATION
        % TODO using BIDS [specs: 8.6 Phisiological and other continuous recordings]
        
        %% OUTLIERS ART
        if Var.get(config, 'art_outliers')
            nvol = get_num_frames( funcs{r} );
            sessions(r).regress.name = 'ART outliers';
            first = (nvol * (r-1)) + 1;
            last = nvol * r;
            art_outs = Var.get(outliers, strrep(visit, 'ses-', ''), []);
            outliers = zeros( nvol, 1 );
            idx = art_outs( art_outs >= first & art_outs<= last ) - (first-1);
            outliers(idx) = 1;
            %Getting outliers
            sessions(r).regress.val = outliers;
        end
        
    end
    
    disp( dest_dir_subj );
    files = {};
    
    %% execute first level
    if ~config.only_recalculate_contrasts
        clear matlabbatch;
        files{end+1} = fullfile( dest_dir_subj, 'BATCH_1_FIRST_LEVEL.mat');
        first_level_spec_and_estimate;
        %% one session (merge all sessions)
        if Var.get(config, 'one_session')
            import neuro.spm.oneSession;
            matlabbatch{1}.spm.stats.fmri_spec = oneSession( config, matlabbatch{1}.spm.stats.fmri_spec );
        end
        save( files{end}, 'matlabbatch' );
    end
    
    %% execute contrasts;
    if ~config.only_estimate
        clear matlabbatch;
        files{end+1} = fullfile( dest_dir_subj, 'BATCH_2_CONTRAST.mat');
        contrast;
        save( files{end}, 'matlabbatch' );
    end
    
    if ~config.only_batch_files
        execSpmFiles( files )
    end
end
end