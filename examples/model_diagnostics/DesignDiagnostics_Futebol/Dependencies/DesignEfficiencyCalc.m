function [Eff,Eff_c,seEff_c] = DesignEfficiencyCalc(X,C,tr)
%
% The aim of this function is to help you estimate the efficiency of your
% design/contrast matrix. It is best employed by creating a number of X
% matrices and then comparing how they score on efficiency.
%
% USAGE:
%
%       [Eff,Eff_c,seEff_c] = DesignEfficiencyCalc(X,C,tr)
%                     INPUT:
%                       - X(t,p) is a matrix with p columns, each
%                       representing a 1/0 (i.e., on/off) regressor, or
%                       condition, and as many rows t as there are
%                       timepoints in your design. 
%                       - C is a transposed contrast matrix created as in
%                       the following example (which assumes that your X
%                       matrix has 3 regressors and that you want to make
%                       2 contrasts): C=[1 0 0;1 -1 0]'
%                       -tr is the TR of your sequence (used to set the
%                       correct hemodynamic response function).
%                       Currently the HRF is set to be a double gamma.
%                     OUTPUT:
%                       - Eff contains the efficiency of the design/contrast
%                       matrix combo -- This is the number you should really
%                       pay attention to! Note: if you loop multiple
%                       efficiency calculations (say because you are
%                       running this command on multiple potential design
%                       matrices), Eff ends up storing each total
%                       efficiency in a different row (see the little
%                       apostrophe in line 76 of the script).
%                       - Eff_c stores, in each of c columns, the efficiency
%                       of each one of the c contrasts you specified in
%                       matrix C.
%                       - seEff_c stores (similarly to Eff_c) the standard
%                       error tied to the efficiency of each contrast.
%
% NOTE: 1. Efficiency does not have an absolute interpretation, so it is
%       most useful when comparing multiple designs to sort out which one
%       is the most efficienct.
%       2. Technically you should only look at the "total" efficiency of
%       your design/contrast matrix combo; looking at each individual
%       contrast is a bit of a cheat, but it can give you interesting
%       information
%       3. The only dependencies of this function are spm_hrf.m and
%       spm_Gpdf.m
%
% Script by Martin M Monti (monti@psych.ucla.edu)
%

% Set the basis function (default is double gamma with TR=tr)
basis_function=spm_hrf(tr);

%Convolve each regressor and store in Xmatrix
for r=1:size(X,2)
   Xmatrix(:,r)=conv(X(:,r),basis_function); 
end

% Trim the X matrix back to its original number of samples
Xmatrix=Xmatrix(1:size(X,1),:);

% Calculate the total efficiency of your design/contrast matrix
E=1/trace(C'*pinv(Xmatrix'*Xmatrix)*C);

% Calculate the individual efficiencies for each contrast
for c=1:size(C,2)
    Ec(c)=1/trace(C(:,c)'*pinv(Xmatrix'*Xmatrix)*C(:,c));
    EcSE(c)=sqrt(C(:,c)'*inv(Xmatrix'*Xmatrix)*C(:,c));
end
disp(' ')
disp(['Deisgn/Contrast efficiency (Total): ' num2str(E)])
%disp('------------------------------')
disp(['Individual contrasts efficiency (SE):'])
%disp('------------------------------')
for c=1:size(C,2)
disp(['     C' num2str(c) '(' num2str(C(:,c)') '): ' num2str(Ec(c)) ' (' num2str(EcSE(c)) ')'])    
end
disp('------------------------------')

Eff=E';
Eff_c=Ec;
seEff_c=EcSE;
