% def structure with following fields:
% pres_type: type name of event
% pres_codes: list of numerical codes that define a condition in SPM
% spm_termination_codes: list of numerical codes that defines the end
% of the condition in SPM, i.e. the duration will be calculated between
% events
% spm_termination_types: list of types
% spm_name: name of condition in SPM
% spm_fix_duration: duration of event (equal for all matched events), if
% left empty, and spm_termination_codes is not defined or empty, duration
% will be set to zero
% spm_pmod: list of values for parametric modulation matching the list of
% pres_codes
function model = get_supraliminar_model_one_per_trial( config )
import idor.utils.Var;

model.name = 'ONE_PER_TRIAL';
model.def = @conditions_one_per_trial;

mod_parametric = Var.get(config, 'mod_parametric', false);

%% HRF
hrf = Var.get(config, 'hrf_derivate', [0, 0]);
if( all( hrf == [1 1]) )
    model.name = [ model.name '_HRF' ];
    % contrastes entre condicoes
    contrasts = {
        {'BEN - CONTROL', [ 0 0 0 1 0 0 -1]}
        {'ACH - CONTROL', [ 1 0 0 0 0 0 -1]}
        {'BEN - ACH', [ -1 0 0 1]}
        {'ACH - BEN', [ 1 0 0 -1]}
        };
else
    %NO HRF
    % contrastes entre condicoes
    model.name = [ model.name '_NOHRF' ];
    contrasts = {
        {'BEN - CONTROL', [ 0 1 -1]}
        {'ACH - CONTROL', [ 1 0 -1]}
        {'BEN - ACH', [ -1 1]}
        {'ACH - BEN', [ 1 -1]}
        };
end

%Caso a parte
if mod_parametric
    contrasts = {
        {'BEN - CONTROL', [ 0 0 1 0 -1]}
        {'ACH - CONTROL', [ 1 0 0 0 -1]}
        {'BEN - ACH', [ -1 0 1]}
        {'ACH - BEN', [ 1 0 -1]}
        };
end

model.contrast = prepareContrasts( contrasts );
model.contrasts_f = 0;
end