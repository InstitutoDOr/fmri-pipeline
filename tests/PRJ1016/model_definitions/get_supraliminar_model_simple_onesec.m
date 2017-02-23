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
function model = get_supraliminar_model_simple_onesec( config )
import idor.utils.Var;

duration = Var.get(config, 'duration_conds', 1);
categories = { 'lexachievement', 'lexbenevolence', 'lexcontrol', 'lexpseudopalavra', 'choice', 'ganhou|doou|no_response' };
spm_names  = { 'Achievement', 'Benevolence', 'Control', 'Pseudopalavra', 'Decision', 'Outcome' };

for k=1:length( categories )
    def(k).pres_type = 'Picture';
    def(k).pres_codes = categories(k);
    def(k).pres_termination_codes = [];
    def(k).pres_termination_types = { 'Response' };
    def(k).spm_name = spm_names{k};
    def(k).spm_fix_duration = 1;
    def(k).spm_pmod = '';
end

%Fixing choice
def(6).spm_fix_duration = 1;

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

model.name = 'TESTE_BRUNO/SIMPLE_DECISION_OUTCOME';
model.def  = def;

%% Duration check
if( duration ~= 1)
    model.name = [ model.name sprintf('_%.1fs', duration) ];
end

%% HRF
hrf = Var.get(config, 'hrf_derivate', [0, 0]);
if( all( hrf == [1 1]) )
    model.name = [ model.name '_HRF' ];
    % contrastes entre condicoes
    contrasts = {
        %{'ACH', [ 1 0 ]}
        %{'BEN', [ 0 0 0 1]}
        %{'CONTROL', [ 0 0 0 0 0 0 1]}
        %{'PSEUDO', [ 0 0 0 0 0 0 0 0 0 1]}
        {'BEN - CONTROL', [ 0 0 0 1 0 0 -1]}
        {'ACH - CONTROL', [ 1 0 0 0 0 0 -1]}
        {'BEN - ACH', [ -1 0 0 1]}
        %{'CONTROL - BEN', [ 0 0 0 -1 0 0 1]}
        %{'CONTROL - ACH', [ -1 0 0 0 0 0 1]}
        {'ACH - BEN', [ 1 0 0 -1]}
        %{'BEN - PSEUDO', [ 0 0 0 1 0 0 0 0 0 -1]}
        %{'PSEUDO - BEN', [ 0 0 0 -1 0 0 0 0 0 1]}
        %{'ACH - PSEUDO', [ 1 0 0 0 0 0 0 0 0 -1]}
        %{'PSEUDO - ACH', [ -1 0 0 0 0 0 0 0 0 1]}
        %{'CONTROL - PSEUDO', [ 0 0 0 0 0 0 1 0 0 -1]}
        %{'PSEUDO - CONTROL', [ 0 0 0 0 0 0 -1 0 0 1]}
        };
else
    %NO HRF
    % contrastes entre condicoes
    model.name = [ model.name '_NOHRF' ];
    contrasts = {
        %{'ACH', [ 1 0 ]}
        %{'BEN', [ 0 0 0 1]}
        %{'CONTROL', [ 0 0 1]}
        %{'PSEUDO', [ 0 0 0 1]}
        {'BEN - CONTROL', [ 0 1 -1]}
        {'ACH - CONTROL', [ 1 0 -1]}
        {'BEN - ACH', [ -1 1]}
        %{'CONTROL - BEN', [ 0 0 0 -1 0 0 1]}
        %{'CONTROL - ACH', [ -1 0 0 0 0 0 1]}
        {'ACH - BEN', [ 1 -1]}
        %{'BEN - PSEUDO', [ 0 1 0 -1]}
        %{'PSEUDO - BEN', [ 0 0 0 -1 0 0 0 0 0 1]}
        %{'ACH - PSEUDO', [ 1 0 0 0 0 0 0 0 0 -1]}
        %{'PSEUDO - ACH', [ -1 0 0 0 0 0 0 0 0 1]}
        %{'CONTROL - PSEUDO', [ 0 0 0 0 0 0 1 0 0 -1]}
        %{'PSEUDO - CONTROL', [ 0 0 0 0 0 0 -1 0 0 1]}
        };
end

model.contrast = prepareContrasts( contrasts );
end