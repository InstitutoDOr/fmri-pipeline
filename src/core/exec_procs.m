function exec_procs( config )
import utils.Var;
import utils.path.basename;

% Abre SPM para gerar gr??ficos
if isempty(spm('Figname'))
    spm fmri;
end

if isempty(Var.get(config, 'subjs', []))
    patt = fullfile(config.raw_base, [config.subj_prefix '*/']);
    config.subjs = utils.resolve_names( patt, 0);
end

for i = 1:length(config.subjs)
    subj = get_subjid(config, config.subjs(i));
    
    try
        % Compatibility with old versions
        export_default = Var.get(config, 'export_from_raw_data', 0);
        if Var.get(config.do, 'export_from_raw_data', export_default)
            export_from_raw_data( config, subj );
        end
        
        if Var.get(config.do, 'preprocessing', 0)
            preprocessing( config, subj );
        end
        
        %% FIRST LEVEL
        if Var.get(config.do, 'first_level', 0)
            run_first_level( config, subj );
        end
        
        if Var.get(config.do, 'extract_betas', 0)
            extract_betas( config, subj );
        end
    catch e
        if Var.get(config, 'stop_with_error', 1)
            rethrow(e)
        end
        getReport(e)
    end
end

if Var.get(config.do, 'second_level', 0)
    run_second_level(config);
end