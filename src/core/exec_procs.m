function exec_procs( config )
import utils.Var;

% Abre SPM para gerar gráficos
if isempty(spm('Figname'))
    spm fmri;
end

% Only for tests - not working
if Var.get(config, 'experimental_niigz', 0)
    utilspath = utils.path.getpackpath('utils');
    addpath( fullfile(utilspath, '../../toolbox/spm') );
    cfg_getfile('regfilter', 'nifti', {'\.nii(\.gz)*$'});
    cfg_getfile('regfilter', 'image', {'.*\.nii(\.gz)*(,\d+){0,2}$'});
end

% Compatibility with old versions
export_default = Var.get(config, 'export_from_raw_data', 0);
if Var.get(config.do, 'export_from_raw_data', export_default)
    export_from_raw_data( config );
end

if Var.get(config.do, 'preprocessing', 0)
    preprocessing( config );
end

%% FIRST LEVEL
if Var.get(config.do, 'first_level', 0)
    run_first_level( config );
end

if Var.get(config.do, 'second_level', 0)
    run_second_level( config );
end

if Var.get(config.do, 'extract_betas', 0)
    extract_betas( config );
end