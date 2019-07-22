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
function model = get_model_RIO_semneutro(config, subj_name)

model.name = 'RIO_SEMNEUTRO';

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

%% Configuring conditions
% ONSETS
subj_name = regexp(subj_name,'SUBJ\d{3}', 'once', 'match');
for ns = 1 : length(config.subjsOnsets)
    if( strcmp(config.subjsOnsets{ns}(1), subj_name) )
        onsetParams = config.subjsOnsets{ns};
        break;
    end
end
onsets = optsOnsets.( onsetParams{2} ).( onsetParams{3} );

% CONDITIONS
for r=1:4
    model.conditions(r).names       = {'ANGUSTIA' 'TERNURA'};
    model.conditions(r).onsets  = onsets{r};
    model.conditions(r).durations   = {46 46};
    model.conditions(r).regcontrast = struct('name', {}, 'columns', {});
    model.conditions(r).pmod = {};
    model.conditions(r).regfile = '';
end

% contrastes entre condicoes
 contrasts = {
     {'A', [ 1 0]}
     {'T', [ 0 1]}
     {'T - A', [ -1 1]}
     {'A - T', [ 1 -1]}
     {'A [1]', [ 1 0 0 0 0 0 0 0 ], 'none'}
     {'T [1]', [ 0 1 0 0 0 0 0 0], 'none'}
     {'T - A [1]', [ -1 1 0 0 0 0 0 0], 'none'}
     {'A - T [1]', [ 1 -1 0 0 0 0 0 0], 'none'}
     {'A [2]', [0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0], 'none'}
     {'T [2]', [0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0], 'none'}
     {'T - A [2]', [0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0], 'none'}
     {'A - T [2]', [0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0], 'none'}
     {'A [3]', [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0], 'none'}
     {'T [3]', [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0], 'none'}
     {'T - A [3]', [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0], 'none'}
     {'A - T [3]', [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0], 'none'}
     {'A [4]', [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0], 'none'}
     {'T [4]', [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0], 'none'}
     {'T - A [4]', [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0], 'none'}
     {'A - T [4]', [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0], 'none'}
};

model.contrast = prepareContrasts( contrasts );
end