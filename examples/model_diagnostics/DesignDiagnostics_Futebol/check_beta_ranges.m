beta_ranges = [1 2 3 4 5 6 7 8 9 10];

for b=1:length(beta_ranges)

    
    [simdata,multicol,statsdata(b)] = DesignDiagnostics_check_beta(X(:,1:17),C(1:17,:),2, convolved, beta_ranges(b));
    [simdata,multicol,statsdata(b)] = DesignDiagnostics_check_beta(X,C,2, convolved, beta_ranges(b));
    
    % noise scaled together with X*beta to about same standard-deviation,
    % R2 is near zero
   
    
end