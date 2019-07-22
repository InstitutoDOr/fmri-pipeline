function model = model_test()

model.name = 'MOTOR'; %Output DIR
model.conditions.names = { 'GO' };
model.conditions.onsets = { 20:40:200 };
model.conditions.durations = { 20 };
% Demais RUNs são iguais
%model.conditions(2:6) = model.conditions(1);

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
     {'POS>PRE', [-1 1]}
 };
model.contrast = prepareContrasts( contrasts );
end