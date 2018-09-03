function [ out ] = prepare_contrasts( contrasts )
%PREPARE_CONTRASTS
%   Each constrast must have {name, vec [, sessrep]};

n = length(contrasts);
out(1:n) = struct('name','','vec',[], 'sessrep', 'repl');

for k=1:n
    out(k).name = contrasts{k}{1};
    out(k).vec  = contrasts{k}{2};
    if( length(contrasts{k}) > 2 )
        out(k).sessrep = contrasts{k}{3};
    end
end;

end

