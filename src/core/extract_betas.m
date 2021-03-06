function extract_betas( config, subjid )

import utils.Var;
import neuro.spm.oneSession;

for nM=1:length(config.model)
    model_name = config.model(nM).name;
    if( config.mov_regressor )
        model_name = ['MOV_' model_name];
    end
    
    datadir = fullfile( config.proc_base, 'STATS', 'FIRST_LEVEL', model_name);
    destdir_base = fullfile( config.proc_base, 'BETAS', model_name );
    
    %Irá executar para cada sujeito
    
    destdir = fullfile( destdir_base, subjid );
    load( fullfile( datadir, subjid, 'BATCH_1_FIRST_LEVEL.mat' ) );
    
    if ~isdir( destdir ), mkdir( destdir ), end
    matlabbatch{1}.spm.stats.fmri_spec.dir{1} = destdir;
    matlabbatch{2}.spm.stats.fmri_est.spmmat{1} = fullfile( destdir, 'SPM.mat' );
    
    if Var.get( config, 'one_session' )
        matlabbatch{1}.spm.stats.fmri_spec = oneSession( config, matlabbatch{1}.spm.stats.fmri_spec );
    end
    matlabbatch{1} = neuro.spm.explode_trials( matlabbatch{1} );
    
    fprintf( 'EXTRACTING BETAS FOR SUBJECT  %s\n', subjid );
    save( fullfile( destdir, 'BETA_FIRST_LEVEL.mat'), 'matlabbatch' );
    spm_jobman('run',matlabbatch);
    
end
end

%Agrupa as sessões em uma única
% function matlabbatch = group_sessions( matlabbatch )
% sess = matlabbatch.spm.stats.fmri_spec.sess;
% nses = length(sess);
% startTime = 0;
% TR = matlabbatch.spm.stats.fmri_spec.timing.RT;
% for nSes = 2:nses
%     startTime = startTime + (length( sess(nSes-1).scans ) * TR);
%     sess(1).scans = [sess(1).scans; sess(nSes).scans];
%     sess(1).multi_reg = {}; %TODO: Buscar forma de juntar
%     for nC = 1 : length(sess(1).cond)
%         onsetsExtra = sess(nSes).cond(nC).onset + startTime;
%         sess(1).cond(nC).onset = [sess(1).cond(nC).onset; onsetsExtra];
%         sess(1).cond(nC).duration = [sess(1).cond(nC).duration; sess(nSes).cond(nC).duration];
%     end
% end
% matlabbatch.spm.stats.fmri_spec.sess = sess(1);
%
% end