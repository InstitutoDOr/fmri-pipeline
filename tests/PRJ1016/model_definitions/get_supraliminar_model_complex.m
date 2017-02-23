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
function model = get_supraliminar_model_complex()

categories = { 'lexachievement', 'lexachievement', 'lexbenevolence', 'lexbenevolence', 'lexcontrol', 'lexcontrol', 'lexpseudopalavra', 'lexpseudopalavra' };
spm_names  = { 'Ach G', 'Ach D', 'Ben G', 'Ben D', 'Con G', 'Con D', 'Pseudo G', 'Pseudo D' };
terminators = { 'ganhou', 'doou', 'ganhou', 'doou', 'ganhou', 'doou', 'ganhou', 'doou' };

for k=1:length( categories )
    def(k).pres_type = 'Picture';
    def(k).pres_codes = categories(k);
    def(k).pres_termination_codes = { 'ganhou' 'doou' 'no_response' };
    def(k).pres_termination_types = { 'Picture' };
    def(k).pres_termination_valueCheck = terminators(k); %Valor que será utilizado para informar se descarta ou não evento
    def(k).spm_fix_duration = 1;
    def(k).spm_name = spm_names{k};
%     def(k).spm_pmod(1).name = @get_ocorType;
%     def(k).spm_pmod(1).str = 'ganhou';
%     def(k).spm_pmod(2).name = @get_ocorType;
%     def(k).spm_pmod(2).str = 'doou';
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

model.name = 'COMPLEX';
model.def  = def;

% contrastes entre condicoes
 contrasts = {};

model.contrast = prepareContrasts( contrasts );
end