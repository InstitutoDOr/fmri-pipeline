function pmod = valores_mod_paramC( Log )

[~,~,data] = xlsread('/dados1/PROJETOS/PRJ1406_SINTAXE_E_VALORES/03_PROCS/SCRIPTS/spm/model_definitions/params/params_C.xlsx');

[~, ~, onsets] = Log.getMatches();
codes = Log.Code(onsets);
strValues = regexprep(codes, '.*(v\d_C\w+)_.*', '$1');
values = zeros(1, length(strValues));
for k = 1 : length(strValues)
    onset = strcmp( strValues{k}, data(:,1) );
    if ~any(onset)
        error('Erro! Não foi encontrado modulador parametrico para a condicao %s', strValues{k});
    end
    values(k) = data{onset,2};
end

if( max(values) == min (values) )
    error('Erro! Todos os valores da modulação paramétrica são iguais. Não será possível utilizá-la.');
end

pmod.name = 'PARAMS_C';
pmod.param = values';
pmod.poly = 1;


end

