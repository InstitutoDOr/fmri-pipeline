function exec_procs( config )
import utils.Var;

% Abre SPM para gerar gráficos
if isempty(spm('Figname'))
    spm fmri;
end

% Compatibility with old versions
export_default = Var.get(config, 'export_from_raw_data', 1);
if Var.get(config.do, 'export_from_raw_data', export_default)
    export_from_raw_data( config );
end

if config.do.preprocessing
    preprocessing( config );
end

%% FIRST LEVEL
if config.do.first_level
    run_first_level( config );
end

if config.do.second_level
    run_second_level( config );
end

if config.do.extract_betas
    extract_betas( config );
end