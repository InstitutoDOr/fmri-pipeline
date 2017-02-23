%% bootstrap
init;
execRec('/dados1/PROJETOS/PRJ1016_PRIMING/03_PROCS/RAW_DATA', @limpaWIP);

% Abre SPM para gerar gráficos
if isempty(spm('Figname'))
    spm fmri;
end