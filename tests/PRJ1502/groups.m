function [g1, g2] = groups( remove )
%GROUPS - list subjects of each group
% out1 = buddy
% out2 = real

textRnd = fileread('randomize.rnd');
patt = '(?<id>\d+)_Buddy';
ids = regexp(textRnd, patt, 'names');

all = setdiff(1:50, remove);
allB = cell2mat( cellfun(@str2num, {ids.id}, 'un', 0) );

g2 = setdiff(allB, remove);
g1= setdiff(all, g2);

end
