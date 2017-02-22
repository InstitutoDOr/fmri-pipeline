%% Run the Demo for Design diagnostics
% It assumes that DesignDiagnostics.m as well as the named contrast/design
% files are also in this same folder
% To run just type 'demo' in the terminal
%
% If you want more info on what comes out of this type 'help DesignDiagnostics'
%
% Script by Martin M Monti ( monti@psych.ucl.edu http://montilab.psych.ucla.edu )
% Version 07/22/2014


% 1. Set X and C matrices and variables
X=dlmread('X01.txt');   % Load in an X matrix (observations x regressors)
C=dlmread('C01.txt'); % Load in contrast matrix C (contrasts x regressors)
TR=2;                        % Let's say it's 2 secs (you can change it if you want)

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
DesignDiagnostics(X,C,2);


