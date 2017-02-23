function pmod = valores_mod_param( Log )

[~, ~, onsets] = Log.getMatches();
inds = find( onsets );
codes = Log.Code(inds);
strValues = regexprep(codes, '.*_(\-?\d)\)$', '$1');
values = cellfun(@str2num, strValues, 'UniformOutput', true);

pmod.name = 'REPETICOES';
pmod.param = values;
pmod.poly = 1;


end

