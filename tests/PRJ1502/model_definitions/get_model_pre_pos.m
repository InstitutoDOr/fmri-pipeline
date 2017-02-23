function model = get_model_pre_pos()

model.name = 'ANALISE_PILOTOS'; %Output DIR
model.conditions.names = { 'GO', 'STOP' };
model.conditions.onsets = { 20:40:200, 0:40:200 };
model.conditions.durations = { 20, 20 };


%% contrastes entre condicoes
%  contrasts = {
%      {'GO', 1}
%      {'GO (1)', [1 0 0 0], 'none'}
%      {'GO (2)', [0 0 0 0 0 0 0 1], 'none'}
%      {'GO (3)', [0 0 0 0 0 0 0 0 0 0 0 0 0 0 1], 'none'}
%      {'GO (4)', [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1], 'none'}
%  };
% contrastes entre condicoes
 contrasts = {
     {'GO', [1 -1]} 
     {'IM_PRE', [1 -1], 'none'}
     {'IM_POS', [0 0 0 0 0 0 0 0 1 -1], 'none'}
     {'POS>PRE', [-1 1 0 0 0 0 0 0 1 -1], 'none'}

 };
model.contrast = prepareContrasts( contrasts );
end