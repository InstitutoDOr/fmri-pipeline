%% Run the Demo for Design diagnostics
% It assumes that DesignDiagnostics.m as well as the named contrast/design
% files are also in this same folder
% To run just type 'demo' in the terminal
%
% If you want more info on what comes out of this type 'help DesignDiagnostics'
%
% Script by Martin M Monti ( monti@psych.ucl.edu http://montilab.psych.ucla.edu )
% Version 07/22/2014

P = fileparts(mfilename('fullpath'));

addpath(fullfile(P, 'Dependencies'))
addpath(fullfile(P, 'Dependencies','collinearity-diagnostics-matlab'));

% spmfile = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL/RESP_MOV_EFFORT_SEP_CSO_MOTOR/SUBJ002/SPM.mat';
spmfile = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL/RESP_MOV_EFFORT_SEP_CSO/SUBJ002/SPM.mat';
tit = 'RESP_MOV_EFFORT_SEP_CSO';

%spmfile = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL/RESP_MOV_EFFORT_SEP_C_SO/SUBJ002/SPM.mat';
%tit = 'RESP_MOV_EFFORT_SEP_C_SO';
remove_movement_physlog_reg = 1;
first_reg_is_handgrip = 0;
single_session = 1;

a = load(spmfile);
% 1. Set X and C matrices and variables
X=a.SPM.xX.X;   % Load in an X matrix (observations x regressors)

X_names = [a.SPM.xX.name];
exConstants = find(~cellfun(@isempty, regexp([a.SPM.xX.name], 'Sn\([0-9]+\).*constant\>')));
X(:,exConstants) = [];
X_names(exConstants) = [];

nvols = find(1-a.SPM.xX.X(:,exConstants(1)),1)-1;

% zscore regressors to have them on same scale
reginds = find(~cellfun(@isempty, regexp(X_names, 'Sn.*R[0-9]+\>')));

X(:,reginds) = zscore(X(:,reginds));

tcon=find(strcmp({a.SPM.xCon.STAT}, 'T'));
C=[a.SPM.xCon(tcon).c]; % Load in contrast matrix C (contrasts x regressors)
TR=2;                        % Let's say it's 2 secs (you can change it if you want)
C(exConstants,:) = [];

%% remove regressors of no interest for diagnostices
if remove_movement_physlog_reg
    if first_reg_is_handgrip
        handgrip_inds = find(~cellfun(@isempty, regexp(X_names, 'Sn.*R1\>')));
        for k=1:length(handgrip_inds)
           for m=1:length(reginds)
               if reginds(m) == handgrip_inds(k)
                   reginds(m) = [];
                   break;
               end
           end
        end
    end
    
    X(:,reginds) = [];
    C(reginds,:) = [];
    X_names(reginds) = [];
end
        

if single_session
    s1 = find(~cellfun(@isempty, regexp(X_names, 'Sn\(1\)')));
    X = X(1:nvols,s1);
    C = C(s1,:);
end

% 2. Show the Design Matrix (X) and the Contrast Matrix (C)
figure(99);subplot(1,2,1);imagesc(X);title('Experimental Design (X Matrix)')
figure(99);subplot(1,2,2);imagesc(C');colormap(redblue);title('Contrasts (C Matrix)')
for x = 1:size(C',2)
    for y = 1:size(C',1)
        text(x,y,num2str(C(x,y)'))
    end
end
pause(1)

% 3. Run Design Diagnostics
convolved = 1;
X_names = regexprep(X_names,'Sn\(1\)', '');
X_names = regexprep(X_names,'\*bf\(1\)', '');
DesignDiagnostics(X,C,2, convolved, X_names,tit);


