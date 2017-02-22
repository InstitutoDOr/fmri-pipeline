function [RUNFiltered mask T F pF Beta global_signal] = subtract_global_signal(RUNUnfiltered)

RUNUnfiltered = double(RUNUnfiltered);
[xdim ydim zdim vdim] = size(RUNUnfiltered);

if nargout > 2
    T = zeros(xdim,ydim, zdim, 1);
    F = zeros(xdim,ydim, zdim);
    pF = zeros(xdim,ydim, zdim);
    Beta = zeros(xdim,ydim, zdim,1);
end

vol = squeeze( RUNUnfiltered(:,:,:,1) );
m = max(max(max(vol)));
mask = vol > 0.05*m ;

vx = sum(sum(sum(mask)));
Y = zeros(vdim,vx);
ind =1;
for x = 1:xdim
    for y = 1:ydim
        for z = 1:zdim
            unfiltered = reshape(RUNUnfiltered(x, y, z, :), vdim, 1);
            if sum(unfiltered) == 0 || sum( isnan(unfiltered) ) > 0 || mask(x,y,z) == 0
                RUNFiltered(x, y, z, :) = unfiltered;
            else
                Y(:,ind) = unfiltered;
                ind = ind + 1;
            end;
        end;
    end;
end;

R = mean(Y, 2);
global_signal = R;
R = zscore(R);

parfor x = 1:xdim
    for y = 1:ydim
        for z = 1:zdim
            unfiltered = reshape(RUNUnfiltered(x, y, z, :), vdim, 1);
            if sum(unfiltered) == 0 || sum( isnan(unfiltered) ) > 0 || mask(x,y,z) == 0
                RUNFiltered(x, y, z, :) = unfiltered;
            else
                if 0
                beta = pinv(R) * unfiltered;
                RUNFiltered(x, y, z, :) = unfiltered - R * beta ;

                Beta(x,y,z,:) = beta;
                
                else 
                stats = regstats( unfiltered, R, 'linear' , {'beta', 'tstat', 'fstat'} );
                RUNFiltered(x, y, z, :) = unfiltered - R * stats.beta(2:end) ;
                
                T(x,y,z,:) = stats.tstat.t(2:end);
                F(x,y,z)   = stats.fstat.f;
                pF(x,y,z)  = stats.fstat.pval;
                end
            end;
        end;
    end;
end;

end