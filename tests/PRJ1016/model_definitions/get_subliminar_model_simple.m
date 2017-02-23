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
function model = get_subliminar_model_simple()
model.name = 'SUBLIMINAR/BETA_EXTRACTION'; %Output DIR

categories = { 'achievement', 'achievement', 'benevolence', 'benevolence', 'control', 'control'};
spm_names  = { 'Ach_D', 'Ach_G', 'Ben_D', 'Ben_G', 'Con_D', 'Con_G'};
terminations = {'doou', 'ganhou'};

for k=1:length( categories )
    for nT=1:length(terminations)
        pos = k+nT-1;
        def(pos).pres_type = 'Picture';
        def(pos).pres_codes = categories(k);
        def(pos).pres_termination_codes = terminations(nT);
        def(pos).pres_termination_types = {'Picture'};
        def(pos).jump.codes = {'no_response'};
        def(pos).jump.type = 'Picture';
        def(pos).spm_name = spm_names{k};
        def(pos).spm_fix_duration = [];
        def(pos).spm_pmod = '';
    end
end

%Doou
%terminations  = { 'doou', 'ganhou' };
% for k=1:length( categories )
%     ind = length(def)+1;
%     def(ind).pres_type = 'Response';
%     def(ind).pres_codes = { '\<16>\', '\<32\>' };
%     def(ind).pres_termination_codes = [];
%     def(ind).pres_termination_types = { 'Response' };
%     def(ind).spm_name = 'MOTOR';
%     def(ind).spm_fix_duration = 0;
%     def(ind).spm_pmod = '';
% end
model.def  = def;

% contrastes entre condicoes
 contrasts = {
     %{'ACH', [ 1 0 ]}
     %{'BEN', [ 0 1 ]}
     %{'CONTROL', [ 0 0 1 ]}
     {'BEN - CONTROL', [ 0 1 -1 ]}
     {'ACH - CONTROL', [ 1 0 -1 ]}
     {'BEN - ACH', [ 1 -1 ]}
     {'CONTROL - BEN', [ 0 -1 1 ]}
     {'CONTROL - ACH', [ -1 0 1 ]}
     {'ACH - BEN', [ 1 -1 ]}
 };

model.contrast = prepareContrasts( contrasts );
end