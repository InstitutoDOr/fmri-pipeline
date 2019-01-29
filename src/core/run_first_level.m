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
main_pattern = ['*task-' config.task '*'];
task_details = loadjson( utils.resolve_name( [bids_dir '/' main_pattern '_*.json'] ) );
visits     = Var.get(config, 'visits', []);
run_suffix = Var.get(config, 'run_suffix', []);

%%%%%%%%%% Getting BIDS Directory %%%%%%%%%
bids_subj_dir    = fullfile( bids_dir, name_subj );

% Visits - If specified, use only what was specified
if isempty(visits)
    % Try to define if exist or not visits (sessions)
    visits = utils.resolve_names( fullfile(bids_subj_dir, 'ses-*'), false );
    if isempty( visits ) % 
        visits = {''};
    end
end

preproc_dir = fullfile( config.preproc_base, name_subj );
preproc_subdir = Var.get( config, 'preproc_subdir', 'func');

%% set parameters first level
subdir_name = model.name;
if config.mov_regressor
    subdir_name = ['MOV_' subdir_name ];
end

if config.resp_regressor
    subdir_name = ['RESP_' subdir_name ];
end
dest_dir = fullfile( config.proc_base, 'STATS', 'FIRST_LEVEL',  subdir_name );
regressors_pat = Var.get(config, 'regressors_pat', [main_pattern '_confounds.tsv']);

for nv = 1:length(visits)
    visit = visits{nv};
    sessions = [];
    dest_dir_subj = utils.mkdir( fullfile( dest_dir, name_subj, visit ) );
    funcs = utils.resolve_names( fullfile(preproc_dir, visit, preproc_subdir, [config.first_level_preproc_prefix '*' visit main_pattern run_suffix '.nii*']) );
    events = utils.resolve_names( fullfile(bids_subj_dir, visit, 'func', [main_pattern '_events.tsv']) );
    if config.mov_regressor
        regressors = utils.resolve_names( fullfile(preproc_dir, visit, preproc_subdir, regressors_pat) );
    end
    
    %% get conditions
    for r=1:length(funcs)
        % Extracting gzip, if necessary
        if regexp(funcs{r}, '\.gz$') > 0
            scans_dir = utils.mkdir( fullfile( dest_dir_subj, 'scans' ) );
            funcs{r} = utils.file.copy_gunzip_file(funcs{r}, scans_dir);
        end
        
        func_base = regexp( utils.path.basename(funcs{r}), 'sub-.*_bold', 'match', 'once');
        conditions = extract_conditions( events{r}, Var.get(model, 'conditions', []), Var.get(model, 'cond', []) );
        
        sessions(r).names       = conditions.names;
        sessions(r).onsets      = conditions.onsets;
        sessions(r).durations   = conditions.durations;
        sessions(r).regress     = struct('name', {}, 'val', {});
        sessions(r).pmod        = Var.get( conditions, 'pmod', [] );
        sessions(r).regfile     = [];
        
        %% MOVIMENT
        if config.mov_regressor
            warning('off','MATLAB:table:ModifiedVarnames')
            treg = utils.file.tsvread_bids(regressors{r});
            names = treg.Properties.VariableNames;
            warning('on','MATLAB:table:ModifiedVarnames')
            total = length(names);
            for nReg = total-5:total % Last 6 columns
                sessions(r).regress(end+1).name = names{nReg};
                sessions(r).regress(end).val = treg.(names{nReg});
            end
            clear treg;
        end
        
        %% RESPIRATION
        % TODO using BIDS [specs: (8.6) - Phisiological and other continuous recordings]
        
        %% OUTLIERS ART
        % For now, not prepared to run in generic cases
        if Var.get(config, 'art_outliers')
            % Default (all 0)
            nvol = get_num_frames( funcs{r} );
            outliers = zeros( nvol, 1 );
            sessions(r).regress(end+1).name = 'ART outliers';
            sessions(r).regress(end).val = outliers;
            
            % Removing only outliers
            sub_outliers = Var.get(config.outliers, strrep(name_subj, 'sub-', ''), []);
            art_outs = Var.get(sub_outliers, strrep(visit, 'ses-', ''), []);
            % Checking if there are ART outliers
            if ~isempty(art_outs)
                first = (nvol * (r-1)) + 1;
                last = nvol * r;
                idx = art_outs( art_outs >= first & art_outs<= last ) - (first-1);
                outliers(idx) = 1;
                %Getting outliers
                sessions(r).regress(end).val = outliers;
            end
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