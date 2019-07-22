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
function model = get_valores_model_modulacao()

jus = 'sentenca.*#\(J';
bon = 'sentenca.*#\(B';
cor = 'sentenca.*#\(C';
pre = 'sentenca.*#\(P';
gan = 'sentenca.*#\(G';
rud = 'sentenca.*#\(R';

%categories = { 'sentenca.*jus.*', patBon, 'sentenca.*cor.*', 'sentenca.*pre.*', 'sentenca.*gan.*', 'sentenca.*rud.*' };
%spm_names  = { 'jus', 'bon' ,'cor', 'pre', 'gan', 'rud'};
categories = {jus bon cor pre gan rud};
spm_names = {'jus' 'bon' 'cor' 'pre' 'gan' 'rud'};

for k=1:length( categories )
    def(k).pres_type = 'Sound';
    def(k).pres_codes = categories(k);
    def(k).pres_termination_codes = { 'fim_sentenca' };
    def(k).pres_termination_types = { 'Picture' };
    def(k).spm_name = spm_names{k};
    def(k).spm_fix_duration = [];
    def(k).spm_pmod.name = @valores_mod_param;
    def(k).spm_pmod.str = 'grau:';
end

ind = length(def)+1;
def(ind).pres_type = 'Response';
def(ind).pres_codes = { '\<16>\', '\<32\>' };
def(ind).pres_termination_codes = [];
def(ind).pres_termination_types = [];
def(ind).spm_name = 'MOTOR';
def(ind).spm_fix_duration = 0;
def(ind).spm_pmod = '';

model.name = 'VALORES_MOD_PARAM';
model.def  = def;
model.contrasts_f = false;

%% contrastes entre condicoes
contrasts = {
     {'POS - NEG',  [ 1 0 1 0 1 0 -1 0 -1 0 -1 0]}
     {'NEG - POS', -[ 1 0 1 0 1 0 -1 0 -1 0 -1 0]}
     {'JUS - BON',  [ 1 0 -1 0]}
     {'BON - JUS', -[ 1 0 -1 0]}
     {'JUS - COR',  [ 1 0 0 0 -1 0]}
     {'COR - JUS', -[ 1 0 0 0 -1 0]}
     {'BON - COR',  [ 0 0 1 0 -1 0]}
     {'COR - BON', -[ 0 0 1 0 -1 0]}
     {'PRE - GAN',  [ 0 0 0 0 0 0 1 0 -1 0]}
     {'GAN - PRE', -[ 0 0 0 0 0 0 1 0 -1 0]}
     {'PRE - RUD',  [ 0 0 0 0 0 0 1 0 0 0 -1 0]}
     {'RUD - PRE', -[ 0 0 0 0 0 0 1 0 0 0 -1 0]}
     {'GAN - RUD',  [ 0 0 0 0 0 0 0 0 1 0 -1 0]}
     {'RUD - GAN', -[ 0 0 0 0 0 0 0 0 1 0 -1 0]}
     {'JUS - PRE',  [ 1 0 0 0 0 0 -1 0]}
     {'PRE - JUS', -[ 1 0 0 0 0 0 -1 0]}
     {'JUS - GAN',  [ 1 0 0 0 0 0 0 0 -1 0 ]}
     {'GAN - JUS', -[ 1 0 0 0 0 0 0 0 -1 0 ]}
     {'JUS - RUD',  [ 1 0 0 0 0 0 0 0 0 0 -1 ]}
     {'RUD - JUS', -[ 1 0 0 0 0 0 0 0 0 0 -1 ]}
     {'BON - PRE',  [ 0 0 1 0 0 0 -1 0 ]}
     {'PRE - BON', -[ 0 0 1 0 0 0 -1 0 ]}
     {'BON - GAN',  [ 0 0 1 0 0 0 0 0 -1 0 ]}
     {'GAN - BON', -[ 0 0 1 0 0 0 0 0 -1 0 ]}
     {'BON - RUD',  [ 0 0 1 0 0 0 0 0 0 0 -1 ]}
     {'RUD - BON', -[ 0 0 1 0 0 0 0 0 0 0 -1 ]}
     {'COR - PRE',  [ 0 0 0 0 1 0 -1 0 ]}
     {'PRE - COR', -[ 0 0 0 0 1 0 -1 0 ]}
     {'COR - GAN',  [ 0 0 0 0 1 0 0 0 -1 ]}
     {'GAN - COR', -[ 0 0 0 0 1 0 0 0 -1 ]}
     {'COR - RUD',  [ 0 0 0 0 1 0 0 0 0 0 -1 ]}
     {'RUD - COR', -[ 0 0 0 0 1 0 0 0 0 0 -1 ]}
     {'JUS', [ 1 0 ]}
     {'BON', [ 0 0 1 ]}
     {'COR', [ 0 0 0 0 1 ]}
     {'PRE', [ 0 0 0 0 0 0 1 0 ]}
     {'GAN', [ 0 0 0 0 0 0 0 0 1 ]}
     {'RUD', [ 0 0 0 0 0 0 0 0 0 0 1 ]}
};

model.contrast = prepareContrasts( contrasts );
end