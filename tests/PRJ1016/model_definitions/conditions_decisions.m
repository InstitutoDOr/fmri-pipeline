function [ conditions ] = conditions_decisions( Log )
%CALCULA PARÂMETROS DAS CONDICOES BASEADO NO INPUT LOG
% returns conditions = struct( 'names', [] , 'onsets', [], 'durations', [] );

%[~, ~, onsets] = Log.getMatches();
%inds = find( onsets );
indsP = find( Log.get_matches( {'lex*'}, Log.Code ) ); %Indice das palavras
indsC = indsP(4:4:96);
classes = Log.Code(indsC);
classes = upper( regexprep(classes,'^lex(\w).*$','$1') ); %Deixa apenas a inicial de cada palavra

conditions = struct( 'names', [], 'onsets', [], 'durations', []);
conditions.names = {'AD' 'AG' 'BD' 'BG' 'CD' 'CG' 'PD' 'PG'};

%% Calculating onsets
starts = find( Log.get_matches( {'choice'}, Log.Code ) );
auxEnds = find( Log.get_matches( {'ganhou|doou|mascara|Response'}, Log.Code ) );
terminators = [];
for k=starts'
    possiveis = auxEnds( auxEnds > k );
    terminators(end+1) = possiveis(1);
end
decisions = upper( regexprep(Log.Code(terminators),'^(\w).*$','$1') );

% define onsets de cada classe/decisao
for c = conditions.names
    class = c{1}(1);
    decision = c{1}(2);
    idxs = ( strcmp(classes,class) ) & ( strcmp(decisions,decision) );
    if( ~isempty(find(idxs)) )
        conditions.onsets{end+1} = Log.timereal( starts(idxs) );
        terminatorsT = Log.timereal( terminators(idxs) );
        conditions.durations{end+1} = terminatorsT - conditions.onsets{end};
    else
        conditions.onsets{end+1} = [];
        conditions.durations{end+1} = [];
    end
end

end

