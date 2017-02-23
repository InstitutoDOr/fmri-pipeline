function pmod = parametric_repeats( Log )

[~, ~, onsets] = Log.getMatches();
inds = find( onsets );
indsT = find( Log.get_matches( {'choice'}, Log.Code ) ); %Indicam o fim dos Trials

values = [];
%Generating values
for k = indsT'
    nC = length(find(inds < k));
    inds(inds<k) = [];
    for n = 1:nC
        values(end+1) = n;
    end
end

pmod.name = 'REPETICOES';
pmod.param = values;
pmod.poly = 1;

end