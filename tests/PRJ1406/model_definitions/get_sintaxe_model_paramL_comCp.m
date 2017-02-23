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
function model = get_sintaxe_model_paramL_comCp()

%% Separando categoria C em C e Cp
% PARA SER C: 
sent_C = '((v1_C1)|(v1_C10)|(v1_C11)|(v1_C12)|(v1_C13)|(v1_C14)|(v1_C15)|(v1_C18)|(v1_C19)|(v1_C20)|(v1_C21)|(v1_C22)|(v1_C23)|(v1_C25)|(v1_C26)|(v1_C27)|(v1_C28)|(v1_C29)|(v1_C3)|(v1_C30)|(v1_C33)|(v1_C35)|(v1_C36)|(v1_C4)|(v1_C7)|(v2_C1)|(v2_C13)|(v2_C14)|(v2_C15)|(v2_C16)|(v2_C17)|(v2_C18)|(v2_C19)|(v2_C2)|(v2_C20)|(v2_C21)|(v2_C22)|(v2_C23)|(v2_C25)|(v2_C3)|(v2_C31)|(v2_C32)|(v2_C33)|(v2_C34)|(v2_C35)|(v2_C36)|(v2_C4)|(v2_C5)|(v2_C6)|(v2_C9))';
% PARA SER Cp: 
sent_Cp = '((v1_C16)|(v1_C17)|(v1_C2)|(v1_C24)|(v1_C31)|(v1_C32)|(v1_C34)|(v1_C5)|(v1_C6)|(v1_C8)|(v1_C9)|(v2_C10)|(v2_C11)|(v2_C12)|(v2_C24)|(v2_C26)|(v2_C27)|(v2_C28)|(v2_C29)|(v2_C30)|(v2_C7)|(v2_C8))';

categories = { 'sentenca.*T_.*', 'sentenca.*I_.*', 'sentenca.*L_.*', ['sentenca_' sent_C '_.*'], ['sentenca_' sent_Cp '_.*']  };
spm_names  = { 'T', 'I', 'L', 'C', 'Cp' };

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

model.name = 'COMPLETE_PARAMS_L_COMCP';
model.def  = def;
model.contrasts_f = 0;

%% contrastes entre condicoes
contrasts = {
    {'Transitivo - Ligacao', [ 1  0 -1]}
    {'Transitivo - Controle', [ 2 0 0 0 -1 -1]}
    {'Transitivo - Intransitivo', [ 1 -1]}
    {'Ligacao - Controle', [ 0 0 2 0 -1 -1 ]}
    {'Intransitivo - Ligacao', [ 0 1 -1]}
    {'Intransitivo - Controle', [ 0 2 0 0 -1 -1]}
   {'Estrutura argumental verbo com C', [3 1 -1 0 -3 ]}
     % {'Estrutura argumental verbo micro', [1 0.5 -0.5 0 -1]}
   {'Estrutura argumental parametrizado v1 com C', [1.5 1 0.5 0 -3]}
   {'Estrutura argumental parametrizado v2 com C e Cp', [1.5 1 0.5 0 -1.5 -1.5 ]}
   {'Numero de referentes com C', [2 -1 2 0 -3]}
   {'Numero de referentes parametrizado com C', [2 1 2 0 -5]}
   % {'Numero de referentes micro', [1 -0.5 1 0 -1.5]}
   % {'Numero de palavras', [1 -1 1.5 0 -1.5]}
};

model.contrast = prepareContrasts( contrasts );
end