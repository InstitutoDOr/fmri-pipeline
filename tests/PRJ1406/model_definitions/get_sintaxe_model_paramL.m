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
function model = get_sintaxe_model_paramL()

categories = { 'sentenca.*T_.*', 'sentenca.*I_.*', 'sentenca.*L_.*', 'sentenca.*C.*' };
spm_names  = { 'T', 'I', 'L', 'C' };

for k=1:length( categories )
    def(k).pres_type = 'Sound';
    def(k).pres_codes = categories(k);
    def(k).pres_termination_codes = { 'fim_sentenca' };
    def(k).pres_termination_types = { 'Picture' };
    def(k).spm_name = spm_names{k};
    def(k).spm_fix_duration = [];
    def(k).spm_pmod = '';
    if( strcmp( categories(k), 'sentenca.*L_.*' ) )
        def(k).spm_pmod.name = @valores_mod_paramL;
    end
end

ind = length(def)+1;
def(ind).pres_type = 'Response';
def(ind).pres_codes = { '\<16>\', '\<32\>' };
def(ind).pres_termination_codes = [];
def(ind).pres_termination_types = [];
def(ind).spm_name = 'MOTOR';
def(ind).spm_fix_duration = 0;
def(ind).spm_pmod = '';

model.name = 'COMPLETE_PARAMS_L';
model.def  = def;
model.contrasts_f = 0;

%% contrastes entre condicoes
contrasts = {
    {'Transitivo - Ligacao', [ 1 0 -1]}
    {'Transitivo - Controle', [ 1 0 0 0 -1]}
    {'Transitivo - Intransitivo', [ 1 -1]}
    {'Ligacao - Controle', [ 0 0 1 0 -1]}
    {'Intransitivo - Ligacao', [ 0 1 -1]}
    {'Intransitivo - Controle', [ 0 1 0 0 -1]}
    {'Estrutura argumental verbo', [3 1 -1 0 -3]}
    {'Estrutura argumental parametrizado', [1.5 1 0.5 0 -3]}
    {'Estrutura argumental T e I perto', [3 2 -1 0 -4]}
    {'Numero de referentes', [2 -1 2 0 -3]}
    {'Numero de referentes parametrizado', [2 1 2 0 -5]}
    {'Numero de palavras', [1 -1 1.5 0 -1.5 0]}
    };

model.contrast = prepareContrasts( contrasts );
end