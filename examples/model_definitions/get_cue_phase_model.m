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
function model = get_cue_phase_model()

    categories = { 'cue.*FLA', 'cue.*STI' ,'cue.*SELF', 'cueEFFORTONLY', 'squeeze(E|F|S)', 'squeezeCUEONLY', 'reward(E|F|S)*', 'rewardCUEONLY', 'ClipFla.*', 'ClipAvai.*' };
    spm_names  = { 'CUE TEAM', 'CUE STI' ,'CUE SELF' , 'CUE EFFORT', 'SQUEEZE ALL', 'NO SQUEEZE', 'REWARD AFTER SQUEEZE', 'REWARD NO SQUEEZE', 'CLIP TEAM', 'CLIP AVAI' };

    duration = [ 1.5 1.5 1.5 1.5 3 3 2 2];
    for k=1:length( categories )-2

        def(k).pres_type = 'Picture';
        def(k).pres_codes = { categories{k} };
        def(k).pres_termination_codes = [] ; % { 'squeeze.*' };
        def(k).pres_termination_types = { 'Picture' };
        def(k).spm_name = spm_names{k};
        def(k).spm_fix_duration = duration(k);
        def(k).spm_pmod = '';
    end
    
    
    for k=length(categories)-1:length(categories)
        def(k).pres_type = 'Video';
        def(k).pres_codes = { categories{k} };
        def(k).pres_termination_codes = { 'fixposclip' };
        def(k).pres_termination_types = { 'Picture' };
        def(k).spm_name = spm_names{k};
        def(k).spm_fix_duration = [];
        def(k).spm_pmod = '';
    end
    
    
    model.name = 'CUE_PHASE';
    model.def  = def;
    
    ci = 1;
    model.contrast(ci).vec  = [ 1 -1 0];
    model.contrast(ci).name = 'CUE FLA > CUE STI';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ -1 1 0];
    model.contrast(ci).name = 'CUE STI > CUE FLA';
    
    ci= ci+1;
       
    model.contrast(ci).vec  = [ 1 0 -1];
    model.contrast(ci).name = 'CUE FLA > CUE SELF';

    ci= ci+1;
       
    model.contrast(ci).vec  = [ -1 0 1];
    model.contrast(ci).name = 'CUE SELF > CUE FLA';

    ci = ci+1;
    model.contrast(ci).vec  = [ 0 1 -1];
    model.contrast(ci).name = 'CUE STI > CUE SELF';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 -1 1];
    model.contrast(ci).name = 'CUE SELF > CUE STI';
    
    %% contrastes com baseline
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 1 0 0 -1];
    model.contrast(ci).name = 'CUE FLA > CUE EFFORT';

    ci = ci+1;
    model.contrast(ci).vec  = [ 0 1 0 -1];
    model.contrast(ci).name = 'CUE STI > CUE EFFORT';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 1 -1];
    model.contrast(ci).name = 'CUE SELF > CUE EFFORT';
    
    %% sequeeze period
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 1 -1];
    model.contrast(ci).name = 'SQUEEZE > NO SQUEEZE';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 -1 1];
    model.contrast(ci).name = 'NO SQUEEZE > SQUEEZE';
    
    %% sequeeze period
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 1 -1];
    model.contrast(ci).name = 'REWARD SQUEEZE > REWARD NO SQUEEZE';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 -1 1];
    model.contrast(ci).name = 'REWARD NO SQUEEZE > REWARD SQUEEZE';
    
    %% videos
    ci = ci+1;
    model.contrast(ci).vec  = [ zeros(1,length(categories)-2) 1 0 ];
    model.contrast(ci).name = 'VIDEO FLA';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ zeros(1,length(categories)-2) 0 1];
    model.contrast(ci).name = 'VIDEO AVAI';
    
    ci = ci+1;
    model.contrast(ci).vec  = [ zeros(1,length(categories)-2) 1 -1 ];
    model.contrast(ci).name = 'VIDEO FLA - AVAI';
    
    ci = ci+1;
    model.contrast(ci).vec  = [ zeros(1,length(categories)-2) -1 1 ];
    model.contrast(ci).name = 'VIDEO AVAI - FLA';
    

    model.regressor_function_handle = '';

end