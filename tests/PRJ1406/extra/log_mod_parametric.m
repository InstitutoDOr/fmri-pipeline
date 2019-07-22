[~, ~, data] = xlsread( 'param_valores.xlsx' );
data(1,:) = []; % Removing headers
logsdir = '/dados1/PROJETOS/PRJ1406_SINTAXE_E_VALORES/03_PROCS/LOGS_PRESENTATION/ajustado';
logsdirbck = fullfile(logsdir, 'bck');
if( ~isdir( logsdirbck ) )
    mkdir( logsdirbck );
end

%toRem = ([data{:,1}] < 28);
%data(toRem,:) = [];

%Irá varrer enquanto houver linhas com dados
while( ~isempty(data) )
    subj = data{1,1};
    %Caso não seja número, elimina a linha e continua
    if( isnan(subj) )
        data(1,:) = [];
        continue;
    end
    
    %Carregando logs
    logs = struct();
    files = dir( fullfile(logsdir, sprintf('SUBJ%03d*', subj)) );
    for k=1:length(files)
        logfile = files(k);
        logs(k).file = fullfile(logsdir, logfile.name);
        logs(k).content = fileread( logs(k).file );
    end
    
    %Identificando linhas do sujeito
    idx = ([data{:,1}] == subj);
    
    %% Ajusta logs
    rows = find(idx);
    for row = rows
        %organizando dados
        wClass = regexp(data{row, 4}, '_\w_(\w)|^(\w)$', 'tokens', 'once');
        if( isempty(wClass) ) %Ignorar casos não respondidos
            continue;
        end
        grau = data{row, 2};
        codigoAntigo = data{row, 3};
        codigoNovo = sprintf('#(%s_%d)', upper(wClass{1}), grau);
        %Realizando substituções nos arquivos
        count = 0;
        for k=1:length(logs)
            pat = regexptranslate('escape', codigoAntigo);
            origs = regexp(logs(k).content, ['(?i)\S*' pat '\S*'], 'match');
            logs(k).content = regexprep(logs(k).content, ['(?i)(\S*' pat '\S*)'], ['$1' codigoNovo]);
            results = regexp(logs(k).content, ['(?i)\S*' pat '\S*'], 'match');
            count = count + length(origs);
            if( ~isempty(origs) )
                encontrado = origs{1};
                substituido = results{1};
            end
        end
        fprintf('SUBJ%03d - %03d - [ %s => %s ] (%d ocorrências)\n', subj, row, encontrado, substituido, count);
    end
    
    %% Salvando logs
    for k=1:length(logs)
        %salvando cada log
        movefile( logs(k).file, logsdirbck );
        fileID = fopen( logs(k).file ,'w');
        fprintf(fileID, logs(k).content);
        fclose(fileID);
    end
    
    %% elimina linhas do sujeito
    data(idx, :) = [];
end