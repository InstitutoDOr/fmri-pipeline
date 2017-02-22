% http://www.unicog.org/pmwiki/files/Sepideh_plottingTimeCoursesSlides.pdf

% get cluster of interest from a maskfile, e.g.- ROIs from marsbar, Anatomy toolbox, WFU PickAtlas toolbox
% XYZ is a 3xn matrix of x-y-z-triplets
maskfile = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/ROIs/Functional Localizer/rM1_-36_-25_56.nii' % or .img
V = spm_vol(maskfile)
[Y,XYZ] = spm_read_vols(V);
[R,C,P]  = ndgrid(1:V(1).dim(1),1:V(1).dim(2),1:V(1).dim(3));
XYZ      = [R(:)';C(:)';P(:)'];
maskvalues = spm_get_data(V, XYZ); % nx1 linear array of values
myCluster = XYZ(:, find(Y(:)>0.5)); % triplets of x-y-z-indices

config.subjs = [2]; % [2:16 18:26 28:32];
model_name = 'RESP_MOV_EFFORT_SEP_CSO_MOTOR';

vols = [1 256; 257 512; 513 768];

for s=1:length(config.subjs)
    
    suid = sprintf('SUBJ%03i', config.subjs(s));
    rdir = fullfile('/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL/', model_name, suid);
    load(fullfile(rdir, 'SPM.mat'));

    % or original time course for selective (ER-) averaging
    % SPM.xY.VY contains filenames of orig data
    y = spm_get_data(SPM.xY.VY, myCluster); % data from original images that were fed into the GLM analysis
    % eventually in addition
    y = SPM.xX.W*y; % prewhitening (sphericity correction)
    y = spm_filter(SPM.xX.K, y); % high-pass filtering

    
    for r=1:size(vols,1)

        % get indices of regressor and of volumes
        rind = find(strcmp( SPM.xX.name, ['Sn(' num2str(r) ') R1']));
        vinds = [vols(r,1):vols(r,2)];
        
       
        BOLD = y(vinds,:);
        BOLD = spm_detrend(BOLD, 1);% linear detrending

        BOLD = mean(BOLD,2); % mean over cluster voxels
        reg = SPM.xX.X(vinds,rind);
 
        x=[0:2:510]';
        xx = [0:.5:511.5]';
        
        BOLD = spline(x,BOLD,xx);
        reg = spline(x,reg,xx);
                
        [c,lags] = xcorr(BOLD,reg, 10);
        
        [mc, mi] = max(c);
        best_lag = lags(mi);
        c_orig = corr(BOLD,reg);
        if best_lag < 0
            c_best_lag = corr(BOLD(1:end+best_lag),reg(1-best_lag:end));
        elseif best_lag > 0
            c_best_lag = corr(BOLD(1+best_lag:end),reg(1:end-best_lag));
        else
            c_best_lag = corr(BOLD,reg);
        end
        result(s,r).c_orig = c_orig;
        result(s,r).c_best_lag = c_best_lag;
        result(s,r).best_lag = best_lag;
        
    end
end

%save( fullfile('/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL/', model_name, 'motor_reg_lag.mat'),'result');

figure,plot(zscore(BOLD(1:end-1,:)))
hold on, plot(zscore(reg(2:end,:)),'k')

% %% totally raw http://andysbrainblog.blogspot.com.br/2014/05/extracting-and-regressing-out-signal-in.html
% V = spm_vol('yourMaskedFunctional')
% G = [];
% for i = 1:length(V)
% G = [G; spm_global(V(i))];
% end
% 
% figure; plot(G)