function [simdata,multicol,statsdata]=DesignDiagnostics_check_beta(X,C,tr, convolved, beta_range_scale)
%%
% The aim of this function is to run some diagnostics on your experimental
% design and contrasts -- you know, to see how good they are! The real aim
% is to make sure your design is (1) the best possible in terms of its
% efficiency, and (2) does not suffer from too much multicollinearity.
% Considering how underpowered fMRI is, and how small the effect sizes
% typically are, this is a simple way of trying to make sure you get the
% most bang for your (supervisor's) buck before you ever scan a single
% participant.
%
% NOTE 1: Efficiency is scale-less so the right way of using this function
% is to come up with different designs and see how efficient each is, and
% then pick the most efficient one. 
% 
% NOTE 2: There are many questions that you should evaluate when you are
% setting up your next experiment; for instance "should I have a blocked
% design? Should I have a slow or fast event related design? What is the
% best ordering of the trials/conditions?" ecc. There are 2 aspects to each
% of these questions:
% (1) The Psychological answer: for that, sorry, but you are on your own.
%     Pilot the task (on yourself too), see how you like it and if you are
%     coming up with unwanted or un-anticiapted strategies and the like.
% (2) The Statistical answer: this is what the present function is handy
%     for. As a guideline, you want designs with the highest efficiencies
%     (both overall and for the specific contrasts you are interested in)
%     and you want to avoid having lots of collinearity because that can
%     lead to unstable estimates (which gan even go in the wrong
%     direction!)
%
% This function will do 2 things for you (print the results to screen and
% generate some sexy figures):
%
% 1. MULTICOLLINEARITY DIAGNOSTICS:
% It will calculate various measures diagnostic of multicollinearity. If
% your design is substantially multicollinear then the collinear regressors
% might be "wild" and even be in the wrong direction, so in that case you
% probably want to fix it. Examples of how to fix it might include: (1)
% eliminating one of the two collinear regressors; (2) performing some kind
% of data reduction (e.g., PCA) and then feed the factors you derive from
% that as regressors; (3) in some circumstances, particularly if you are
% only interested in group level statistics, you might still pull it off
% even if you do have collinear designs (and if you are an FSLer the
% "de-weight outliers" option will help with decreasing the importance of
% very crazy estimates -- though, if you can fix it with (1) or (2), why
% not?)
%
% 2. SIMULATIONS:
% This part of the function will take your design, assign a random "true"
% 'activation' value to each regressor (i.e., a true beta) and then run a
% number of simulations (i.e., GLMs) and see how well it can recover, on
% average, that "true" beta value. Along with the average estimated betas
% (which you'd hope would be pretty close to the "true" beta), it will also
% tell you the variance associated with the estimates, the average t-value
% for each beta, the average F-value for the whole model as well as the
% adjusted R2.
%
% Have tons of fun!
%
% USAGE:
%
%   [simdata,multicol] = DesignDiagnostics(X,C,tr)
%               
%       INPUT:
%              - X is a t (rows) by p (columns) design matrix with each 
%               row being a sample (e.g. timepoint/volume) and each column
%               being a regressor (e.g., task). 
%                       NOTE: the script assumes that you have not convolved 
%               your regressors yet. So your matrix should be comprised of
%               1s and 0s. If you don't like the (default) double gamma
%               convolution kernel you can do the convolution yourself 
%               (i.e., feed in a convolved X matrix) and comment out the
%               convolution below in the code.
%
%              - C is a c (rows) by p (columns) contrast matrix. This is
%               the matrix specifying which comparisons you want to perform.
%       
%              - tr is the TR you expect to use
%
%       OUTPUT
%              - simdata is a p (rows) by s (columns) matrix containing the
%              results of the simulations. The columns give the following
%              summary information over the run simulations (which match
%              the printed output of this function):
%              Regressor#, True Beta, Average Estimated Beta, Average
%              Standard Error, Average T-value.
%
%              - multicol is a structure that contains all sorts of 
%              information concerning multicollinearity in your design including
%               the diagnostic measures (VIF and CondInd -- see below for
%               an explanation of each)
%
%               NOTE: The data stored in simdata and multicol is exactly
%               the same data that gets printed to the screen, it's just in
%               case you want to do something fancy with it.
%
% There are 3 main diagnostics for collinearity that are used in this
% function: pearson correlations, Variance Inflation Factor, Condition
% Index)
%
%
% Here is an explanation of VIF and CI if you want to understand your
% results better
%
%
% Variance Inflation Factor,VIF, (a measure calculated for each variable) is
%     simply the reciprocal of tolerance.  It measures the degree to which 
%     the interrelatedness of the variable with other predictor variables 
%     inflates the variance of the estimated regression coefficient for 
%     that variable.  Hence the square root of the VIF is the degree to 
%     which the collinearity has increased the standard error for that 
%     variable.  Therefore, a high VIF value indicates high multicollinearity
%     of that variable with other independents and instability of the 
%     regression coefficient estimation process.  There are no statistical 
%     tests to test for multicollinearity using the tolerance or VIF measures.
%     VIF=1 is ideal and many authors use VIF=10 as a suggested upper limit 
%     for indicting a definite multicollinearity problem for an individual 
%     variable (VIF=10 inflates the Standard Error by 3.16).  Some would 
%     consider VIF=4 (doubling the Standard Error) as a minimum for 
%     indicated a possible multicollinearity problem.   
% Condition Index values are calculated from the eigenvalues for a rescaled 
%     crossproduct X�X matrix.  Hence these measures are not for individual 
%     variables (like the tolerance and VIF measures) but are for individual 
%     dimensions/components/factors and measure of the amount of the variability
%     it accounts for in the rescaled crossproduct X�X matrix.  The rescaled 
%     crossproduct X�X matrix values are obtained by dividing each original 
%     value by the square root of the sum of squared original values for that 
%     column in the original matrix, including those for the intercept.  This 
%     yields an X�X matrix with ones on the main diagonal.  Eigenvalues close 
%     to 0 indicate dimensions which explain little variability.  A wide spread 
%     in eigenvalues indicates an ill-conditioned crossproduct matrix, meaning 
%     there is a problem with multicollinearity.  A condition index is calculated
%     for each dimension/component/factor by taking the square root of ratio of
%     the largest eigenvalue divided by the eigenvalue for the dimension. 
%     A common rule of thumb is that a condition index over 15 indicates a 
%     possible multicollinearity problem and a condition index over 30 suggests 
%     a serious multicollinearity problem.  Since each dimension is a linear 
%     combination of the original variables the analyst using OLS regression is 
%     not able to merely exclude the problematic dimension.  Hence a guide is 
%     needed to determine which variables are associated with the problematic 
%     dimension. ****Another way of putting it is: (1) decompose the
%     correlation matrix into a linear combination of variables (so, you 
%     make the first linear combination taking the dimension that
%     has the most variance, then you take the second dimension that has
%     the most variance, contingent on it being independent of the first
%     dimension, hten you take the third dimension, contingent on it being
%     independent of the first and second ...); (2) for each linear
%     combination the igenvalue represents how much variance it explains;
%     (3) for each linear combination calculate the CI as the square root
%     of the ratio between the maximum of the obtained igenvalues, and the
%     igenvalue for each given linear combination; if the maximum is much
%     much bigger than other eigenvalues it means that there is one linear
%     combination that explains most of the variability of our original
%     variables, hence they are likely to be highly correlated.
%
%
% Script by Martin M Monti (monti@psych.ucla.edu http://montilab.psych.ucla.edu)
% Version 07/22/2014



warning('off','all');
%-------------------------
% Set important variables
%-------------------------

b_true=randi([1 5],1,size(X,2))*beta_range_scale;     % Pick some random numbers for betas
b_true=rand(1,size(X,2))+beta_range_scale;     % Pick some random numbers for betas
%b_true=[10 9 8 7 6 5 -1 -0.5 -1 b_true(10:17)];
%                                                (between 5 and about 10)
nloops=50;                                      % Number of simulations
basis_function=spm_hrf(tr);                     % Basis function (DGamma with TR=tr)
numConds=size(X,2);
noise_multip=4;                                 % Noise multiplier; the larger the noisier

%------------------------------
% Initialize storage variables
%------------------------------
regCorr=zeros(nloops,1);                % Correlation among regressors
varX=regCorr;
Beta=zeros(nloops,size(X,2));           % Store the regression betas
SE=zeros(nloops,size(X,2));             % Store var(Beta)
T=zeros(nloops,size(X,2));
F=zeros(nloops,2);                      % Store the F-values
R2adj=zeros(nloops,1);                  % Store each regression's R2

% --------------------------------------------
% Convolve each regressor and store in Xmatrix
% --------------------------------------------
if convolved
    Xmatrix = X;
else
    for r=1:size(X,2)
        Xmatrix(:,r)=conv(X(:,r),basis_function);
    end
    Xmatrix=Xmatrix(1:size(X,1),:); % Trim the X matrix to its original number of samples
end

% ------------------------------
% 1. Multicollinearity testing
% ------------------------------
multicol=colldiag(Xmatrix);
disp('***************************************************************')
disp('              DESIGN DIAGNOSTICS')
disp('***************************************************************')
disp(' ')
disp('------------------------------')
disp('A. Multicollinearity')
% the VIF measures the factor by which the parameter�s variance
% (in an orthogonal regression; hence without multicollinearity) is multiplied (c.q. inflated).
% disp('------------------------------')
% for i=1:size(Xmatrix,2)
%     disp(['Reg #' num2str(i) ': ' num2str(mcol.vif(i),'%0.2f')]);
% end
disp('------------------------------')
display(multicol.str)
disp('3. See figure 1 for regressor correlations')
disp(' ')
disp('------------------------------')
disp('**NOTE: VIF > 5-10 potential multicollinearity')
disp('             CondInd < 10   weak')
disp('        30 < CondInd < 100  moderate to strong')
disp('             CondInd > 100  severe')
disp(' ')

%------------------------------
% 2. Design Efficiency
%------------------------------
disp(' ')
disp('------------------------------')
disp('B. DesignEfficiency')
disp('------------------------------')
DesignEfficiencyCalc(X,C,tr);
disp(' ')
disp(' ')

%------------------------------
% 3. Run Simulation
%------------------------------
for i=1:nloops
    %-------------------------------------------------------
    % Run a regression and save the t-values for amplitude estimates
    %-------------------------------------------------------
    true_signal_std = std( Xmatrix*b_true' );
    
    noise=randn(size(X,1),1)*1*true_signal_std;             % Noise for the regression
    data=Xmatrix*b_true' + noise;
    stats=regstats(data,Xmatrix,'linear');
    T(i,:)=stats.tstat.t(2:end)';
    Beta(i,:)=stats.beta(2:end)';
    SE(i,:)=stats.tstat.se(2:end)';
    F(i,1)=stats.fstat.f;
    F(i,2)=stats.fstat.pval;
    R2adj(i)=stats.adjrsquare;
end

   for i=1:size(Xmatrix,2)
      tabdata(i,1)=i; %regressor number
      tabdata(i,2)=b_true(i); %Real beta
      tabdata(i,3)=mean(Beta(:,i)); %Average estimated beta
      tabdata(i,4)=mean(SE(:,i)); %Average SE
      tabdata(i,5)=mean(T(:,i)); %Average T-value
      statsdata.betaSE(i) = std(Beta(:,i))/sqrt(size(Beta,1));
      
   end

   statsdata.pval = mean(F(:,2));
   statsdata.F    = mean(F(:,1));
   statsdata.R    = mean(R2adj);
   
   
   % Set table data variables
    colheadings={'Regr #', 'True b','Avg est b', 'Avg SE','Avg T-value'};
    disp('------------------------------')
    disp('C. Simulations')
    disp('------------------------------')
    disp(' ')
    disp(['Model Summary:'])
    disp(['Run length: ' secs2hms(tr*size(X,1))])
    for i=1:size(X,2)
        disp(['   Regr' num2str(i) ': ' num2str(sum(X(:,i))) ' on TRs'])
    end
    
    disp(['Number of simulations: ' num2str(nloops)])
    disp(['Avg F: ' num2str(mean(F(:,1))) '(p < ' num2str(mean(F(:,2))) ')'])
    disp(['Avg R2-adj: ' num2str(mean(R2adj))])
    disp('------------------------------')
    disp(['Individual regressors summary:'])
    displaytable(tabdata,colheadings);
    disp('------------------------------')
    disp(' ')
    disp(' ')

%-----------------------------
% 4. Create some sexy figures
%-----------------------------

% Make a legend for the plots
clear leg
for i=1:size(X,2)
    leg(i,1)={['Reg' num2str(i)]};
end

figure(1); % Regressor correlations (with numbers) 
    subplot(2,2,1);imagesc(corr(Xmatrix),[-1 1]);colormap(redblue);set(gca,'xticklabel',[],'yticklabel',[]);title('Regressor correlation');colorbar;
    [cors,pcors]=corrcoef(Xmatrix);
    cors=cors(:);
    pcors=pcors(:);
    for i=1:size(cors)
       if pcors(i)<=0.05
         textStrings(i)={[num2str(cors(i),'%0.2f') '*']};
       else
         textStrings(i)={[num2str(cors(i),'%0.2f')]};
       end
    end
%    textStrings=corr(Xmatrix);
%    textStrings=num2str(textStrings(:),'%0.2f'); % Create strings from the correlation matrix
    [x,y] = meshgrid(1:size(corr(Xmatrix)));   % Create x and y coordinates for the strings
    hStrings = text(x(:),y(:),textStrings,...      % Plot the strings
                'HorizontalAlignment','center');
     subplot(2,2,[3:4]);%plot(zscore(Xmatrix));xlabel('TR');ylabel('Regressor Z-scored amplitude');set(gca,'ytick',[]);title('Design');legend(leg);
    plot(Xmatrix);xlabel('TR');ylabel('Regressor original amplitude');set(gca,'ytick',[]);title('Design');legend(leg);
    
     figure(2); % The simulations
        subplot(3,2,1);plot(Beta);title(['Betas (True values: ' num2str(b_true) ')']);legend(leg);
            for i=1:size(X,2)
                hold on; line([1:nloops],[b_true(i)])
            end
            hold off
        subplot(3,2,3);plot(SE);title('SE');legend(leg);
        subplot(3,2,5);plot(T);title('T-test');legend(leg)
        %subplot(3,2,2);plot(F);title('F-test');
        subplot(3,2,2);[haxes,hline1,hline2]=plotyy([1:nloops],F(:,1),[1:nloops],F(:,2));title('F-test');legend('F','pval');
            axes(haxes(1));ylabel('F-test');
            axes(haxes(2));ylabel('p-value');set(haxes(2),'YLim',[0 0.1],'YTick',[0 0.05 0.1]);%hold on;plot([1:nloops],0.05,'g');
            %set(hline2,'LineStyle','--');
        subplot(3,2,4);plot(R2adj);title('R2 Adjusted');
        subplot(3,2,6);title('Summary statistics');set(gca,'xticklabel',[],'yticklabel',[],'xcolor','w','ycolor','w');...

    

simdata=tabdata;

warning('on','all');


