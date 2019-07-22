%% bootstrap
init;

%% configurations 
config = [];

config.nrun = 4;
config.nvol = 304;
config.ncorte = 24;
config.TR = 2;
config.TA = 1.675;
config.sliceorder = 1:config.ncorte;
config.TA = config.TA - (config.TA/config.ncorte);
config.smooth = [6 6 6];
config.export_from_raw_data = 1; 
% 228 * 2 (max distance between trials of the same condition * 2)
config.HPF = 0;
config.mask = {'/dados3/SOFTWARES/Blade/toolbox_IDOR/spm12/spm12/tpm/mask_ICV.nii,1'};
config.mthresh = 0.8;


% Abre SPM para gerar gráficos
if isempty(spm('Figname'))
    spm fmri;
end