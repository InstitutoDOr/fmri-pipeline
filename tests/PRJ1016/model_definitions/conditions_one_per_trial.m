function [ conditions ] = conditions_one_per_trial( Log )
%CALCULA PARÂMETROS DAS CONDICOES BASEADO NO INPUT LOG
% returns conditions = struct( 'names', [] , 'onsets', [], 'durations', [] );

%[~, ~, onsets] = Log.getMatches();
%inds = find( onsets );
indsP = find( Log.get_matches( {'lex*'}, Log.Code ) ); %Indice das palavras
classes = Log.Code(indsP);
classes = upper( regexprep(classes,'^lex(\w).*$','$1') ); %Deixa apenas a inicial de cada palavra

conditions = struct( 'names', [], 'onsets', [], 'durations', []);
conditions.names = { 'A', 'B', 'C', 'P' };
conditions.onsets = cell(1,4);
conditions.durations = cell(1,4);

%% Calculating onsets
ends = find( Log.get_matches( {'choice'}, Log.Code ) );

% defining onsets/durations of each trial
lastC = 0;
countReps = 0;
for nT = 1:24
    indStart = ((nT-1)*4 + 1);
    onset = Log.timereal( indsP(indStart) );
    duration = Log.timereal( ends(nT) ) - onset;
    reps = countTrial( conditions.names, classes(nT:nT+3) );
    [ val, nC ] = max( reps );
    if lastC == nC
        countReps = countReps + 1;
    else
        countReps = 1;
    end
    lastC = nC;
    if countReps > 3
        reps(nC) = 0;
        [ val, nC ] = max( reps );
    else
        
    end
    conditions.onsets{nC} = [conditions.onsets{nC} onset];
    conditions.durations{nC} = [conditions.durations{nC} duration];
end

end

%% COUNT TRIAL
function values = countTrial( conditions, vals )

for c = 1:length(conditions)
    values(c) = sum( strcmp(vals,conditions{c}) );
end

end