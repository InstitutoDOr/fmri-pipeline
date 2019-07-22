function pmod = get_ocorType( onsets, Code, result )

opts = {'lexachievement','lexbenevolence','lexcontrol','lexpseudopalavra'};
class = unique(Code(onsets));
[~,results] = get_code_matches({'ganhou|doou|no_response'}, Code);
[~,classes] = get_code_matches({'lex[a|b|c|p]\w*'}, Code);

nBlocks = size( results, 1 );
blocksGanhou = cell(nBlocks, 4);
blocksDoou = cell(nBlocks, 4);
for k=1:nBlocks
    pstart = (k-1)*4 + 1;
    pend = (k)*4;
    blocksGanhou(k,:) = extract( classes(pstart:pend), 'ganhou', results{k} );
    blocksDoou(k,:) = extract( classes(pstart:pend), 'doou', results{k} );
end

vals.ganhou = [vertcat(blocksGanhou{:,1}),vertcat(blocksGanhou{:,2}),vertcat(blocksGanhou{:,3}),vertcat(blocksGanhou{:,4})];
vals.doou = [vertcat(blocksDoou{:,1}),vertcat(blocksDoou{:,2}),vertcat(blocksDoou{:,3}),vertcat(blocksDoou{:,4})];

pmod.name = result;
pmod.param = vals.(result)(:,find(strcmp(opts,class)));
pmod.poly = 1;

end

function codigos = extract( classes, aim, got )
ach = sum(strcmp(classes, 'lexachievement'));
ben = sum(strcmp(classes, 'lexbenevolence'));
con = sum(strcmp(classes, 'lexcontrol'));
pse = sum(strcmp(classes, 'lexpseudopalavra'));
if( strcmp(aim, got) )
    fun = @ones;
else
    fun = @zeros;
end
codigos = {
    fun(ach,1)*ach, fun(ben,1)*ben, fun(con,1)*con, fun(pse,1)*pse
};
end

function [code_matches, code_str] = get_code_matches( codes, Code )

code_matches = ones(length(Code),1) == 0;
for c=1:length(codes)
%    code_matches = [code_matches | strcmp( num2str( codes{c} ), Code )];
    hit = ~cellfun( @isempty, regexp( Code, num2str( codes{c} ) ) );
    code_matches = [code_matches | hit];
end
code_str = Code( code_matches );

end