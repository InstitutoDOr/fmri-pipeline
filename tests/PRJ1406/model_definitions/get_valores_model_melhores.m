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
function model = get_valores_model_melhores()

jus = 'sentenca.*(1_(L_j.*[23]|T_j.*[13])|2_(L_j.*[156]|T_j.*[236])).*';
bon = 'sentenca.*(1_(L_b.*[12356]|T_b.*[125])|2_(L_b.*[235]|T_b.*[23456])).*';
cor = 'sentenca.*(1_(L_c.*[256]|T_c.*[145])|2_(L_c.*[2456]|T_c.*[2456])).*';
pre = 'sentenca.*(1_(L_p.*[234]|T_p.*[1234])|2_(L_p.*[1456]|T_p.*[134])).*';
gan = 'sentenca.*(1_(L_g.*[1356]|T_g.*[46])|2_(L_g.*[34]|T_g.*[1356])).*';
rud = 'sentenca.*(1_(L_r*[34]|T_r.*[2345])|2_(L_r.*[1356]|T_r.*[236]|T_g.*2)).*';
ignore = 'sentenca.*';

%categories = { 'sentenca.*jus.*', patBon, 'sentenca.*cor.*', 'sentenca.*pre.*', 'sentenca.*gan.*', 'sentenca.*rud.*' };
%spm_names  = { 'jus', 'bon' ,'cor', 'pre', 'gan', 'rud'};
categories = {jus bon cor pre gan rud ignore};
spm_names = {'jus' 'bon' 'cor' 'pre' 'gan' 'rud' 'ignore'};

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

model.name = 'VALORES_MELHORES';
model.def  = def;
model.afterLogs = @correct_condition_ignore;

%% contrastes entre condicoes
contrasts = {
     {'POS - NEG',  [ 1 1 1 -1 -1 -1]}
     {'NEG - POS', -[ 1 1 1 -1 -1 -1]}
     {'JUS - BON',  [ 1 -1 ]}
     {'BON - JUS', -[ 1 -1 ]}
     {'JUS - COR',  [ 1 0 -1 ]}
     {'COR - JUS', -[ 1 0 -1 ]}
     {'BON - COR',  [ 0 1 -1 ]}
     {'COR - BON', -[ 0 1 -1 ]}
     {'PRE - GAN',  [ 0 0 0 1 -1 ]}
     {'GAN - PRE', -[ 0 0 0 1 -1 ]}
     {'PRE - RUD',  [ 0 0 0 1 0 -1 ]}
     {'RUD - PRE', -[ 0 0 0 1 0 -1 ]}
     {'GAN - RUD',  [ 0 0 0 0 1 -1 ]}
     {'RUD - GAN', -[ 0 0 0 0 1 -1 ]}
     {'JUS - PRE',  [ 1 0 0 -1 ]}
     {'PRE - JUS', -[ 1 0 0 -1 ]}
     {'JUS - GAN',  [ 1 0 0 0 -1 ]}
     {'GAN - JUS', -[ 1 0 0 0 -1 ]}
     {'JUS - RUD',  [ 1 0 0 0 0 -1 ]}
     {'RUD - JUS', -[ 1 0 0 0 0 -1 ]}
     {'BON - PRE',  [ 0 1 0 -1 ]}
     {'PRE - BON', -[ 0 1 0 -1 ]}
     {'BON - GAN',  [ 0 1 0 0 -1 ]}
     {'GAN - BON', -[ 0 1 0 0 -1 ]}
     {'BON - RUD',  [ 0 1 0 0 0 -1 ]}
     {'RUD - BON', -[ 0 1 0 0 0 -1 ]}
     {'COR - PRE',  [ 0 0 1 -1 ]}
     {'PRE - COR', -[ 0 0 1 -1 ]}
     {'COR - GAN',  [ 0 0 1 0 -1 ]}
     {'GAN - COR', -[ 0 0 1 0 -1 ]}
     {'COR - RUD',  [ 0 0 1 0 0 -1 ]}
     {'RUD - COR', -[ 0 0 1 0 0 -1 ]}
     {'JUS', [ 1 0 ]}
     {'BON', [ 0 1 ]}
     {'COR', [ 0 0 1 ]}
     {'PRE', [ 0 0 0 1 0 ]}
     {'GAN', [ 0 0 0 0 1 ]}
     {'RUD', [ 0 0 0 0 0 1 ]}
};

model.contrast = prepareContrasts( contrasts );
end