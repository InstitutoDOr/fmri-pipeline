function model = model_test()
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

categories = { 'sentenca.*T_(jus|bon|cor).*', 'sentenca.*T_(pre|gan|rud).*', 'sentenca.*I_(jus|bon|cor).*', 'sentenca.*I_(pre|gan|rud).*', 'sentenca.*L_(jus|bon|cor).*', 'sentenca.*L_(pre|gan|rud).*', 'sentenca.*C.*' };
spm_names  = { 'T+', 'T-' ,'I+', 'I-', 'L+', 'L-', 'C' };

for k=1:length( categories )
    def(k).pres_type = 'Sound';
    def(k).pres_codes = categories(k);
    def(k).pres_termination_codes = { 'fim_sentenca' };
    def(k).pres_termination_types = { 'Picture' };
    def(k).spm_name = spm_names{k};
    def(k).spm_fix_duration = [];
    def(k).spm_pmod = '';
end

ind = length(def)+1;
def(ind).pres_type = 'Response';
def(ind).pres_codes = { '\<16>\', '\<32\>' };
def(ind).pres_termination_codes = [];
def(ind).pres_termination_types = [];
def(ind).spm_name = 'MOTOR';
def(ind).spm_fix_duration = 0;
def(ind).spm_pmod = '';

model.name = 'COMPLETE';
model.def  = def;

%% contrastes entre condicoes
contrasts = {
    {'Transitivo - Ligacao', [ 1 1 0 0 -1 -1]}
    {'Transitivo - Controle', [ 1 1 0 0 0 0 -2]}
    {'Transitivo - Intransitivo', [ 1 1 -1 -1]}
    {'Ligacao - Controle', [ 0 0 0 0 1 1 -2]}
    {'Intransitivo - Ligacao', [ 0 0 1 1 -1 -1]}
    {'Intransitivo - Controle', [ 0 0 1 1 0 0 -2]}
    {'T+ - Controle', [1 0 0 0 0 0 -1]}
    {'T- - Controle', [0 1 0 0 0 0 -1]}
    {'I+ - Controle', [0 0 1 0 0 0 -1]}
    {'I- - Controle', [0 0 0 1 0 0 -1]}
    {'L+ - Controle', [0 0 0 0 1 0 -1]}
    {'L- - Controle', [0 0 0 0 0 1 -1]}
    {'T+ - T-', [1 -1 0 0 0 0 0]}
    {'I+ - I-', [0 0 1  -1 0 0 0]}
    {'L+ - L-', [0 0 0 0 1 -1 0]}  
    {'+ - -', [1 -1 1 -1 1 -1 0]}
    {'+ - controle', [1 0 1 0 1 0 -3]}
    {'- - controle', [0 1 0 1 0 1 -3]}
};

model.contrast = prepareContrasts( contrasts );
end