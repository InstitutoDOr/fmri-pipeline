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
function model = get_supraliminar_parametric()

categories = { 'lexachievement', 'lexbenevolence', 'lexcontrol', 'lexpseudopalavra' };
spm_names  = { 'Achievement', 'Benevolence', 'Control', 'Pseudopalavra' };

for k=1:length( categories )
    def(k).pres_type = 'Picture';
    def(k).pres_codes = categories(k);
    def(k).pres_termination_codes = [];
    def(k).pres_termination_types = { 'Response' };
    def(k).spm_pmod.name = @parametric_repeats;
    def(k).spm_pmod.str = 'repeticoes:';
    def(k).spm_name = spm_names{k};
    def(k).spm_fix_duration = 1;
end

model.name = 'MOD_PARAMETRICA';
model.def  = def;

% contrastes entre condicoes
 contrasts = {
     {'BEN - CONTROL', [ 0 0 1 0 -1 0]}
     {'ACH - CONTROL', [ 1 0 0 0 -1 0]}
     {'BEN - ACH', [ -1 0 1 0]}
     {'CONTROL - BEN', [ 0 0 -1 0 1 0]}
     {'CONTROL - ACH', [ -1 0 0 0 1 0]}
     {'ACH - BEN', [ 1 0 -1 0]}
     {'BEN - PSEUDO', [ 0 0 1 0 0 0 -1 0]}
     {'PSEUDO - BEN', [ 0 0 -1 0 0 0 1 0]}
     {'ACH - PSEUDO', [ 1 0 0 0 0 0 -1 0]}
     {'PSEUDO - ACH', [ -1 0 0 0 0 0 1 0]}
     {'CONTROL - PSEUDO', [ 0 0 0 0 1 0 -1 0]}
     {'PSEUDO - CONTROL', [ 0 0 0 0 -1 0 1 0]}
 };

model.contrast = prepareContrasts( contrasts );
end