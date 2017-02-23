%%% nRoi - informa betas de qual roi sera utilizado
%%% nCol - coluna a ser preenchida
%%% output - matriz que sera trabalhada

resp2 = respostas;
names = struct( 'lexachievement', 'Ach', ...
    'lexbenevolence', 'Ben', ...
    'lexcontrol', 'Con', ...
    'lexpseudopalavra', 'Pseudo');
opcoes = {'ganhou', 'doou'};
firstRow = 0;
subjs = fieldnames( betas{nRoi} );
for nS = 1:length(subjs) %nS - numero dos sujeitos
    subjid = subjs{nS};
    iPos = find( strcmp(respostas(:,1), subjid) );
    firstRow = iPos(1)-1;
    for nD = 1:2 %nO - Posicao das decisoes
        clear cont;
        iOpcoes = strcmp( respostas(iPos,4), opcoes{nD});
        %Ira varrer todas os eventos relacionados com ganhos e doacoes
        for nR = find(iOpcoes)'
            for nE = nR-3:nR %Quatro palavras para cada resposta
                tipo = respostas{nE,3};
                if( ~exist('cont', 'var') || ~isfield( cont,tipo) )
                    cont.(tipo) = 0;
                end
                cont.(tipo) = cont.(tipo)+1;
                label = sprintf('%s %s_%d', names.(tipo), upper(opcoes{nD}(1)), cont.(tipo) );
                posBeta = find( strcmp(betas{nRoi}.(subjid){1}, label) );
                nRow = firstRow + nE;
                output{nRow,nCol} = betas{nRoi}.(subjid){2}(posBeta);
            end
        end
    end
end