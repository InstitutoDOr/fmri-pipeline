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
function model = get_effort_separado_C_SO_Gito_motor_model()

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
                   'SQUEEZE EFF FLA'
                   'SQUEEZE EFF STI'
                   'SQUEEZE EFF SELF'
                   'N SQUEEZE TEAM'
                   'N SQUEEZE STI'
                   'N SQUEEZE SELF'                   
                   'CLIP TEAM'
                   'CLIP AVAI' };
    durations = [ 1.5*ones(1,9) 5*ones(1,9) ];
    
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
    
    

    model.name = 'EFFORT_SEP_C_SO_Gito_Motor';
    model.def  = def;
    
    ci = 1;
   
    %% contrastes SQUEEZE > SQUEEZE
    
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 1];
    model.contrast(ci).name = 'SQUEEZE TEAM';
    
        ci = ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 0 1];
    model.contrast(ci).name = 'SQUEEZE STI';
    
     ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 0 0 1];
    model.contrast(ci).name = 'SQUEEZE SELF';
    
    ci = ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 1 0 -1];
    model.contrast(ci).name = 'SQ TEAM > SQ SELF';
    
        ci = ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 -1 0 1];
    model.contrast(ci).name = 'SQ SELF > SQ TEAM';
  
        
    ci = ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 1 -1];
    model.contrast(ci).name = 'SQ TEAM > SQ STI';
    
        ci = ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 -1 1];
    model.contrast(ci).name = 'SQ STI > SQ TEAM';
    
            ci = ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 0 1 -1];
    model.contrast(ci).name = 'SQ STI > SQ TEAM';
    
           ci = ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 0 -1 1];
    model.contrast(ci).name = 'SQ TEAM > SQ STI';
    
       ci = ci+1;
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 -1];
    model.contrast(ci).name = 'SQUEEZE TEAM > N SQUEEZE TEAM';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [0 0 0 0 0 0 0 0 0 -1 0 0 0 0 0 1];
    model.contrast(ci).name = 'N SQUEEZE TEAM > SQUEEZE TEAM';

    ci = ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 -1];
    model.contrast(ci).name = 'SQUEEZE STI > N SQUEEZE STI';
    
    ci = ci+1;
    
    model.contrast(ci).vec  = [0 0 0 0 0 0 0 0 0 0 -1 0 0 0 0 0 1];
    model.contrast(ci).name = 'N SQUEEZE STI > SQUEEZE STI';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 -1];
    model.contrast(ci).name = 'SQUEEZE SELF > N SQUEEZE SELF';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 0 0 -1 0 0 0 0 0 1];
    model.contrast(ci).name = 'N SQUEEZE SELF > SQUEEZE SELF';

 ci= ci+1;
    
    model.contrast(ci).vec  = [0 0 0 0 0 0 0 0 0 1 0 0 0 -1];
    model.contrast(ci).name = 'SQUEEZE TEAM > SQUEEZE EFF TEAM';
    
     ci= ci+1;
    
    model.contrast(ci).vec  = [0 0 0 0 0 0 0 0 0 -1 0 0 1];
    model.contrast(ci).name = 'SQUEEZE EFF TEAM > SQUEEZE TEAM';
    
    ci = ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 0 1 0 0 -1];
    model.contrast(ci).name = 'SQUEEZE STI > SQUEEZE EFF STI';
    
    ci = ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 0 -1 0 0 1];
    model.contrast(ci).name = 'SQUEEZE EFF STI > SQUEEZE STI';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 0 0 1 0 0 -1];
    model.contrast(ci).name = 'SQUEEZE SELF > SQUEEZE EFF SELF';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 0 0 -1 0 0 1];
    model.contrast(ci).name = 'SQUEEZE EFF SELF > SQUEEZE SELF';

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
    
    model.contrast(ci).vec  = [1 -1];
    model.contrast(ci).name = 'CUE TEAM > CUE STI';
    
           ci= ci+1;
    
    model.contrast(ci).vec  = [-1 1];
    model.contrast(ci).name = 'CUE STI > CUE TEAM';
    
        ci= ci+1;
    
    model.contrast(ci).vec  = [1 0 -1];
    model.contrast(ci).name = 'CUE TEAM > CUE SELF';
            
        ci= ci+1;
    
    model.contrast(ci).vec  = [-1 0 1];
    model.contrast(ci).name = 'CUE SELF > CUE TEAM';
    
            ci= ci+1;
    
    model.contrast(ci).vec  = [0 -1 1];
    model.contrast(ci).name = 'CUE SELF > CUE STI';
    
                ci= ci+1;
    
    model.contrast(ci).vec  = [0 1 -1];
    model.contrast(ci).name = 'CUE STI > CUE SELF';
    
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