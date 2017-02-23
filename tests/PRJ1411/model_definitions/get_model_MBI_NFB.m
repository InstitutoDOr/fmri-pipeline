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
function model = get_model_MBI_NFB(config, subj_name)

model.name = 'MBI';
model.contrasts_f = 0;

optsOnsets = struct('SVM',[], 'ROI',[]);
SVM_AB = {[182 258 486 562] [30 106 334 410]};
SVM_BA = {[30 106 334 410] [182 258 486 562]};
ROI_AB = { [334 410 486 562] [30 106 182 258]};
ROI_BA = {[30 106 182 258] [334 410 486 562]};
optsOnsets.SVM.A = {SVM_AB,SVM_BA,SVM_AB,SVM_BA};
optsOnsets.SVM.B = {SVM_BA,SVM_AB,SVM_BA,SVM_AB};
optsOnsets.ROI.A = {ROI_AB,ROI_BA,ROI_AB,ROI_BA};
optsOnsets.ROI.B = {ROI_BA,ROI_AB,ROI_BA,ROI_AB};

model.conditions = [];
algo = regexp(subj_name,'SVM|ROI', 'once', 'match');
inicio = 'A';
if regexp(subj_name,'BABA$')
    inicio = 'B';
end
onsets = optsOnsets.( algo ).( inicio );

for r=1:4
    model.conditions(r).names       = {'ANGUSTIA' 'TERNURA'};
    model.conditions(r).onsets  = onsets{r};
    model.conditions(r).durations   = {46 46};
    model.conditions(r).regcontrast = struct('name', {}, 'columns', {});
    model.conditions(r).pmod = {};
    model.conditions(r).regfile = '';
end

% contrastes entre condicoes
 regs = [0 0 0 0 0 0 0]; % outliers + movs
 jump = [0 0 regs];
 contrasts = {
     {'A', [ 1 0]}
     {'T', [ 0 1]}
     {'T - A', [ -1 1]}
     {'A - T', [ 1 -1]}
     {'A NFB', [ jump 1 0 regs 1 0 regs 1 0], 'none'}
     {'T NFB', [ jump 0 1 regs 0 1 regs 0 1], 'none'}
     {'T - A NFB', [ jump -1 1 regs -1 1 regs -1 1], 'none'}
     {'A - T NFB', [ jump 1 -1 regs 1 -1 regs 1 -1], 'none'}
     {'A [1]', [ 1 0 regs], 'none'}
     {'T [1]', [ 0 1 regs], 'none'}
     {'T - A [1]', [ -1 1], 'none'}
     {'A - T [1]', [ 1 -1], 'none'}
     {'A [2]', [jump 1 0], 'none'}
     {'T [2]', [jump 0 1], 'none'}
     {'T - A [2]', [jump -1 1], 'none'}
     {'A - T [2]', [jump 1 -1], 'none'}
     {'A [3]', [jump jump 1 0], 'none'}
     {'T [3]', [jump jump 0 1], 'none'}
     {'T - A [3]', [jump jump -1 1], 'none'}
     {'A - T [3]', [jump jump 1 -1], 'none'}
     {'A [4]', [jump jump jump 1 0], 'none'}
     {'T [4]', [jump jump jump 0 1], 'none'}
     {'T - A [4]', [jump jump jump -1 1], 'none'}
     {'A - T [4]', [jump jump jump 1 -1], 'none'}
};

model.contrast = prepareContrasts( contrasts );
end