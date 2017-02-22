>> help DesignDiagnostics
Contents of DesignDiagnostics:

Demo                           - Run the Demo for Design diagnostics
DesignDiagnostics              - 


DesignDiagnostics is both a directory and a function.

 
  The aim of this function is to run some diagnostics on your experimental
  design and contrasts -- you know, to see how good they are! The real aim
  is to make sure your design is (1) the best possible in terms of its
  efficiency, and (2) does not suffer from too much multicollinearity.
  Considering how underpowered fMRI is, and how small the effect sizes
  typically are, this is a simple way of trying to make sure you get the
  most bang for your (supervisor's) buck before you ever scan a single
  participant.
 
  NOTE 1: Efficiency is scale-less so the right way of using this function
  is to come up with different designs and see how efficient each is, and
  then pick the most efficient one. 
  
  NOTE 2: There are many questions that you should evaluate when you are
  setting up your next experiment; for instance "should I have a blocked
  design? Should I have a slow or fast event related design? What is the
  best ordering of the trials/conditions?" ecc. There are 2 aspects to each
  of these questions:
  (1) The Psychological answer: for that, sorry, but you are on your own.
      Pilot the task (on yourself too), see how you like it and if you are
      coming up with unwanted or un-anticiapted strategies and the like.
  (2) The Statistical answer: this is what the present function is handy
      for. As a guideline, you want designs with the highest efficiencies
      (both overall and for the specific contrasts you are interested in)
      and you want to avoid having lots of collinearity because that can
      lead to unstable estimates (which gan even go in the wrong
      direction!)
 
  This function will do 2 things for you (print the results to screen and
  generate some sexy figures):
 
  1. MULTICOLLINEARITY DIAGNOSTICS:
  It will calculate various measures diagnostic of multicollinearity. If
  your design is substantially multicollinear then the collinear regressors
  might be "wild" and even be in the wrong direction, so in that case you
  probably want to fix it. Examples of how to fix it might include: (1)
  eliminating one of the two collinear regressors; (2) performing some kind
  of data reduction (e.g., PCA) and then feed the factors you derive from
  that as regressors; (3) in some circumstances, particularly if you are
  only interested in group level statistics, you might still pull it off
  even if you do have collinear designs (and if you are an FSLer the
  "de-weight outliers" option will help with decreasing the importance of
  very crazy estimates -- though, if you can fix it with (1) or (2), why
  not?)
 
  2. SIMULATIONS:
  This part of the function will take your design, assign a random "true"
  'activation' value to each regressor (i.e., a true beta) and then run a
  number of simulations (i.e., GLMs) and see how well it can recover, on
  average, that "true" beta value. Along with the average estimated betas
  (which you'd hope would be pretty close to the "true" beta), it will also
  tell you the variance associated with the estimates, the average t-value
  for each beta, the average F-value for the whole model as well as the
  adjusted R2.
 
  Have tons of fun!
 
  USAGE:
 
    [simdata,multicol] = DesignDiagnostics(X,C,tr)
                
        INPUT:
               - X is a t (rows) by p (columns) design matrix with each 
                row being a sample (e.g. timepoint/volume) and each column
                being a regressor (e.g., task). 
                        NOTE: the script assumes that you have not convolved 
                your regressors yet. So your matrix should be comprised of
                1s and 0s. If you don't like the (default) double gamma
                convolution kernel you can do the convolution yourself 
                (i.e., feed in a convolved X matrix) and comment out the
                convolution below in the code.
 
               - C is a c (rows) by p (columns) contrast matrix. This is
                the matrix specifying which comparisons you want to perform.
        
               - tr is the TR you expect to use
 
        OUTPUT
               - simdata is a p (rows) by s (columns) matrix containing the
               results of the simulations. The columns give the following
               summary information over the run simulations (which match
               the printed output of this function):
               Regressor#, True Beta, Average Estimated Beta, Average
               Standard Error, Average T-value.
 
               - multicol is a structure that contains all sorts of 
               information concerning multicollinearity in your design including
                the diagnostic measures (VIF and CondInd -- see below for
                an explanation of each)
 
                NOTE: The data stored in simdata and multicol is exactly
                the same data that gets printed to the screen, it's just in
                case you want to do something fancy with it.
 
  There are 3 main diagnostics for collinearity that are used in this
  function: pearson correlations, Variance Inflation Factor, Condition
  Index)
 
 
  Here is an explanation of VIF and CI if you want to understand your
  results better
 
 
  Variance Inflation Factor,VIF, (a measure calculated for each variable) is
      simply the reciprocal of tolerance.  It measures the degree to which 
      the interrelatedness of the variable with other predictor variables 
      inflates the variance of the estimated regression coefficient for 
      that variable.  Hence the square root of the VIF is the degree to 
      which the collinearity has increased the standard error for that 
      variable.  Therefore, a high VIF value indicates high multicollinearity
      of that variable with other independents and instability of the 
      regression coefficient estimation process.  There are no statistical 
      tests to test for multicollinearity using the tolerance or VIF measures.
      VIF=1 is ideal and many authors use VIF=10 as a suggested upper limit 
      for indicting a definite multicollinearity problem for an individual 
      variable (VIF=10 inflates the Standard Error by 3.16).  Some would 
      consider VIF=4 (doubling the Standard Error) as a minimum for 
      indicated a possible multicollinearity problem.   
  Condition Index values are calculated from the eigenvalues for a rescaled 
      crossproduct X’X matrix.  Hence these measures are not for individual 
      variables (like the tolerance and VIF measures) but are for individual 
      dimensions/components/factors and measure of the amount of the variability
      it accounts for in the rescaled crossproduct X’X matrix.  The rescaled 
      crossproduct X’X matrix values are obtained by dividing each original 
      value by the square root of the sum of squared original values for that 
      column in the original matrix, including those for the intercept.  This 
      yields an X’X matrix with ones on the main diagonal.  Eigenvalues close 
      to 0 indicate dimensions which explain little variability.  A wide spread 
      in eigenvalues indicates an ill-conditioned crossproduct matrix, meaning 
      there is a problem with multicollinearity.  A condition index is calculated
      for each dimension/component/factor by taking the square root of ratio of
      the largest eigenvalue divided by the eigenvalue for the dimension. 
      A common rule of thumb is that a condition index over 15 indicates a 
      possible multicollinearity problem and a condition index over 30 suggests 
      a serious multicollinearity problem.  Since each dimension is a linear 
      combination of the original variables the analyst using OLS regression is 
      not able to merely exclude the problematic dimension.  Hence a guide is 
      needed to determine which variables are associated with the problematic 
      dimension. ****Another way of putting it is: (1) decompose the
      correlation matrix into a linear combination of variables (so, you 
      make the first linear combination taking the dimension that
      has the most variance, then you take the second dimension that has
      the most variance, contingent on it being independent of the first
      dimension, hten you take the third dimension, contingent on it being
      independent of the first and second ...); (2) for each linear
      combination the igenvalue represents how much variance it explains;
      (3) for each linear combination calculate the CI as the square root
      of the ratio between the maximum of the obtained igenvalues, and the
      igenvalue for each given linear combination; if the maximum is much
      much bigger than other eigenvalues it means that there is one linear
      combination that explains most of the variability of our original
      variables, hence they are likely to be highly correlated.
 
 
  Script by Martin M Monti (monti@psych.ucla.edu http://montilab.psych.ucla.edu)
  Version 07/22/2014