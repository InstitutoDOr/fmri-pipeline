function execSpmFiles( files, execute )
%EXECSPMFILES Summary of this function goes here
%   Detailed explanation goes here
if( ~exist('execute', 'var') ); execute = true; end;

for k=1:length(files)
    if isstruct(files(k))
        matlabbatch = files(k).matlabbatch;
        save( sprintf(files(k).name, k), 'matlabbatch' );
        if isfield(files(k), 'message')
            disp( files(k).message );    
        end
    else
        clear matlabbatch;
        load( files{k} );
    end
    
    %% If is to execute
    if( execute )
        spm_jobman('run',matlabbatch);
        execs = utils.Var.get( files(k), 'execs', false);
        if iscell(execs)
            try
                eval([files(k).execs{:}]);
            catch
                warning(sprintf('problems executing %s', [files(k).execs{:}]));
            end
        end
    end
end
    
end