function fixed_effects_MBI( subjspat )
models = { 'MOV_MBI' };
nReg = 7; %Parâmetros de movimento

for m=1:length(models)
    
    model_name = models{m};
    fprintf('FIXED EFFECT - %s\n', model_name);
    
    stats_dir = '/dados2/PROJETOS/PRJ1411_NFB_VR/03_PROCS/PROC_DATA/fMRI_ANAT/STATS';
    datadir = fullfile( stats_dir, 'FIRST_LEVEL', model_name );
    destdir = fullfile( stats_dir, 'FIXED_EFFECT', 'MBI' );
    fprintf('OUT DIR - %s\n', destdir);
    
    %Defining subjs
    subjs = dir( fullfile(datadir, subjspat) );
    
    for s=1:length(subjs)
        %Defining subjname
        if( isstruct(subjs(s)) )
            subj = subjs(s).name;
        else
            subj = sprintf('SUBJ%03i',subjs(s));
        end
        
        %preparing data
        tmp = load( fullfile( datadir, subj,'BATCH_1_FIRST_LEVEL.mat' ) );
        if s == 1
            matlabbatch = tmp.matlabbatch;
            firstsubj = subj;
            nRun = length(tmp.matlabbatch{1}.spm.stats.fmri_spec.sess);
            nCond = length(tmp.matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond);
        else
            nses = length(matlabbatch{1}.spm.stats.fmri_spec.sess);
            nsesB = length(tmp.matlabbatch{1}.spm.stats.fmri_spec.sess);
            inds = nses +1 : nses + nsesB;
            
            matlabbatch{1}.spm.stats.fmri_spec.sess(inds) = tmp.matlabbatch{1}.spm.stats.fmri_spec.sess;
        end
        
    end
    
    tmp_destdir = utils.correctFilename( fullfile( destdir, ['SUBJS' sprintf('_%s', subjspat) ] ) );
    tmp_destdir = strrep(tmp_destdir, '*', '');
    if ~isdir( tmp_destdir ), mkdir( tmp_destdir ), end
    
    outfile = fullfile( tmp_destdir, 'SPM.mat' );
    
    %matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.1;
    %matlabbatch{1}.spm.stats.fmri_spec.mask = {'/dados3/SOFTWARES/Blade/toolbox_IDOR/spm12/spm12/tpm/mask_ICV.nii,1'};
    matlabbatch{1}.spm.stats.fmri_spec.dir{1}   = tmp_destdir;
    matlabbatch{2}.spm.stats.fmri_est.spmmat{1} = outfile;
    
    tmp = load( fullfile( datadir, firstsubj, 'BATCH_2_CONTRAST.mat' ) );
    
    tmp.matlabbatch{1}.spm.stats.con.spmmat{1} = outfile;
    %Corrigindo contrastes n�o replicados para o projeto PRJ1411
    for nC = 1:length( tmp.matlabbatch{1}.spm.stats.con.consess )
        if( ~isfield( tmp.matlabbatch{1}.spm.stats.con.consess{nC}, 'tcon' ) ); continue; end;
        rep = tmp.matlabbatch{1}.spm.stats.con.consess{nC}.tcon.sessrep;
        if ( strcmp(rep, 'none') )
           nParamsSubj = nRun * (nCond+nReg); % (3 cond + 6 params mov) x 4 runs
           vals = tmp.matlabbatch{1}.spm.stats.con.consess{nC}.tcon.convec;
           if( length(vals) < nParamsSubj ); vals(end+1:nParamsSubj) = 0; end;
           tmp.matlabbatch{1}.spm.stats.con.consess{nC}.tcon.convec = repmat(vals,1,length(subjs));
        end
    end
    
    disp( ['RUNNING FIXED EFFECTS FOR SUBJECTS ' subjspat ] );
    save( fullfile( tmp_destdir, 'FIXED_FIRST_LEVEL.mat'), 'matlabbatch' );
    spm_jobman('run',matlabbatch);
    
    disp( ['RUNNING CONTRASTS FOR FIXED EFFECTS FOR SUBJECTS ' subjspat ] );
    matlabbatch = tmp.matlabbatch;
    save( fullfile( tmp_destdir, 'FIXED_BATCH_CONTRAST.mat'), 'matlabbatch' );
    spm_jobman('run',matlabbatch);
    
end