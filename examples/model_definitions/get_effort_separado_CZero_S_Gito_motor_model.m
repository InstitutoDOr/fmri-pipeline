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
function model = get_effort_separado_CZero_S_Gito_motor_model()

    categories = { 'cueFLA'
                   'cueSTI' 
                   'cueSELF' 
                   'cueEFFORTONLYFLA'
                   'cueEFFORTONLYSTI'
                   'cueEFFORTONLYSELF'
                   'cueCUEONLY_FLA'
                   'cueCUEONLY_STI'
                   'cueCUEONLY_SELF'
                   'squeezeFLA'
                   'squeezeSTI'
                   'squeezeSELF'
                   'squeezeEFFORTONLYFLA'
                   'squeezeEFFORTONLYSTI'
                   'squeezeEFFORTONLYSELF'
                   'squeezeCUEONLY_FLA'
                   'squeezeCUEONLY_STI'
                   'squeezeCUEONLY_SELF'
                   'ClipFla.*'
                   'ClipAvai.*' 
                   };
    spm_names  = { 'CUE TEAM'
                   'CUE STI' 
                   'CUE SELF'
                   'CUE EFFORT TEAM'
                   'CUE EFFORT STI'
                   'CUE EFFORT SELF'
                   'CUEONLY TEAM'
                   'CUEONLY STI'
                   'CUEONLY SELF'
                   'SQUEEZE TEAM'
                   'SQUEEZE STI'
                   'SQUEEZE SELF'
                   'SQUEEZE EFFORT FLA'
                   'SQUEEZE EFFORT STI'
                   'SQUEEZE EFFORT SELF'
                   'SQ CUE TEAM'
                   'SQ CUE STI'
                   'SQ CUE SELF'                   
                   'CLIP TEAM'
                   'CLIP AVAI' };
    durations = [ 0*ones(1,9) 3*ones(1,9) ];
    
    for k=1:length( categories )-2

        def(k).pres_type = 'Picture';
        def(k).pres_codes = { categories{k} };
        def(k).pres_termination_codes = [] ; % { 'squeeze.*' };
        def(k).pres_termination_types = { 'Picture' };
        def(k).spm_name = spm_names{k};
        def(k).spm_fix_duration = durations(k);
        def(k).spm_pmod = '';
    end

    ind = length(def)+1;
    
    for k=length( categories )-1:length( categories )
        def(k).pres_type = 'Video';
        def(k).pres_codes = { categories{k} };
        def(k).pres_termination_codes = { 'fixposclip' };
        def(k).pres_termination_types = { 'Picture' };
        def(k).spm_name = spm_names{k};
        def(k).spm_fix_duration = [];
        def(k).spm_pmod = '';
    end
    
    

    model.name = 'EFFORT_SEP_CZero_S_Gito_Motor';
    model.def  = def;
    
    ci = 1;
   
    %% contrastes CUE > SQUEEZE
      
    model.contrast(ci).vec  = [ 1 0 0 0 0 0 0 0 0 -1];
    model.contrast(ci).name = 'CUE TEAM > SQUEEZE TEAM';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ -1 0 0 0 0 0 0 0 0 1];
    model.contrast(ci).name = 'SQUEEZE TEAM > CUE TEAM';

    ci = ci+1;
    
    model.contrast(ci).vec  = [ 0 1 0 0 0 0 0 0 0 0 -1];
    model.contrast(ci).name = 'CUE STI > SQUEEZE STI';
    
    ci = ci+1;
    
    model.contrast(ci).vec  = [ 0 -1 0 0 0 0 0 0 0 0 1];
    model.contrast(ci).name = 'SQUEEZE STI > CUE STI';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 1 0 0 0 0 0 0 0 0 -1];
    model.contrast(ci).name = 'CUE SELF > SQUEEZE SELF';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 -1 0 0 0 0 0 0 0 0 1];
    model.contrast(ci).name = 'SQUEEZE SELF > CUE SELF';

     %% contrastes CUE ONLY > SQUEEZE CUE ONLY
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 -1];
    model.contrast(ci).name = 'CUE ONLY TEAM > SQ CUE ONLY TEAM';
    
    ci= ci+1;    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 -1 0 0 0 0 0 0 0 0 1];
    model.contrast(ci).name = 'SQ CUE ONLY TEAM > CUE ONLY TEAM';

    ci = ci+1;
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 -1];
    model.contrast(ci).name = 'CUE ONLY STI > SQ CUE ONLY STI';
    
    ci = ci+1;
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 -1 0 0 0 0 0 0 0 0 1];
    model.contrast(ci).name = 'SQ CUE ONLY STI > CUE ONLY STI';
    
    ci= ci+1;    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 -1];
    model.contrast(ci).name = 'CUE ONLY SELF > SQ CUE ONLY SELF';
    
    ci= ci+1;
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 -1 0 0 0 0 0 0 0 0 1];
    model.contrast(ci).name = 'SQ CUE ONLY SELF > CUE ONLY SELF';

    %% Apenas CUES
    ci= ci+1;
    
    model.contrast(ci).vec  = [1];
    model.contrast(ci).name = 'CUE TEAM';

    ci = ci+1;
    model.contrast(ci).vec  = [ 0 1];
    model.contrast(ci).name = 'CUE STI';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 1 ];
    model.contrast(ci).name = 'CUE SELF';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 1];
    model.contrast(ci).name = 'CUE ONLY TEAM';
    
    ci = ci+1;
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 1];
    model.contrast(ci).name = 'CUE ONLY STI';
    
    ci= ci+1;    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 1];
    model.contrast(ci).name = 'CUE ONLY SELF';
    
        ci= ci+1;    
    model.contrast(ci).vec  = [ 0 0 1 0 0 0 0 0 -1];
    model.contrast(ci).name = 'CUE SELF > CUE ONLY SELF';
    
    ci= ci+1;    
    model.contrast(ci).vec  = [ 0 0 -1 0 0 0 0 0 1];
    model.contrast(ci).name = 'CUE ONLY SELF > CUE SELF';  
    
    ci= ci+1;    
    model.contrast(ci).vec  = [ 1 0 0 0 0 0 -1];
    model.contrast(ci).name = 'CUE TEAM > CUE ONLY TEAM';
    
    ci= ci+1;
    model.contrast(ci).vec  = [ -1 0 0 0 0 0 1];
    model.contrast(ci).name = 'CUE ONLY TEAM > CUE  TEAM';  
    
    ci = ci+1;
    model.contrast(ci).vec  = [ 0 1 0 0 0 0 0 -1];
    model.contrast(ci).name = 'CUE STI > CUE ONLY STI';    
    
    ci = ci+1;
    model.contrast(ci).vec  = [ 0 -1 0 0 0 0 0 1];
    model.contrast(ci).name = 'CUE ONLY STI > CUE STI'; 
  
   
    %% motor
    ci= ci+1;
    
    model.contrast(ci).vec  = [ zeros(1,length(categories)) 1];
    model.contrast(ci).name = 'MOTOR';

    model.regressor_function_handle = @get_motor_data;
end