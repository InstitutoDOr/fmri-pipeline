%% bootstrap
init;

% Abre SPM para gerar gráficos
if isempty(spm('Figname'))
    spm fmri;
end