% splits every condition into single trials
function batch_out = convert_to_trials( batchfile, destdir )

load( batchfile );

batch_out = matlabbatch;
for k=1:length(matlabbatch)
   
    if isfield( matlabbatch{k}.spm, 'stats' ) && isfield( matlabbatch{k}.spm.stats, 'fmri_spec' ) ...
            && isfield( matlabbatch{k}.spm.stats.fmri_spec, 'sess' )
        
        % set output directory
        batch_out{k}.spm.stats.fmri_spec.dir{1} = destdir;
        
        for ses = 1:length(matlabbatch{k}.spm.stats.fmri_spec.sess)
            cond = matlabbatch{k}.spm.stats.fmri_spec.sess(ses).cond;

            ind = 1;
            for c=1:length(cond)
                
                for trials=1:length(cond(c).onset)
                    batch_out{k}.spm.stats.fmri_spec.sess(ses).cond(ind)          = cond(c);
                    batch_out{k}.spm.stats.fmri_spec.sess(ses).cond(ind).onset    = cond(c).onset(trials);
                    batch_out{k}.spm.stats.fmri_spec.sess(ses).cond(ind).duration = cond(c).duration(trials);
                    
                    % delete parameters, they don make sense when modelling
                    % each trial separately
                    if ~isempty( cond(c).pmod )
                        
                        batch_out{k}.spm.stats.fmri_spec.sess(ses).cond(ind).pmod =  struct( 'name', {}, 'param', {}, 'poly', {} );
                        
                    end
                    ind = ind + 1;
                end
            end
        end
        
    end
    
    if isfield( matlabbatch{k}.spm, 'stats' ) && isfield( matlabbatch{k}.spm.stats, 'fmri_est' ) ...
            && isfield( matlabbatch{k}.spm.stats.fmri_est, 'spmmat' )
         batch_out{k}.spm.stats.fmri_est.spmmat{1} = fullfile( destdir, 'SPM.mat' );
    end
    
end

end