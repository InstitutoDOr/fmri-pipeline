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
function model = get_effort_separado_C_S_motor_model()

    categories = { 
        'cueFLA|cueCUEONLY_FLA'
        'cueSTI|cueCUEONLY_STI' 
        'cueSELF|cueCUEONLY_SELF'
        'cueEFFORTONLYFLA'
        'cueEFFORTONLYSTI'
        'cueEFFORTONLYSELF'
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
    spm_names  = { 
        'CUE TEAM'
        'CUE STI'
        'CUE SELF'
        'CUE EFFORT TEAM'
        'CUE EFFORT STI'
        'CUE EFFORT SELF'
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
        'CLIP AVAI'
        
        };
    durations = [ 1.5*ones(1,6) 3*ones(1,9) ];
    
    for k=1:length( categories )-2

        def(k).pres_type = 'Picture';
        def(k).pres_codes = { categories{k} };
        def(k).pres_termination_codes = [] ; % { 'squeeze.*' };
        def(k).pres_termination_types = { 'Picture' };
        def(k).spm_name = spm_names{k};
        def(k).spm_fix_duration = durations(k);
        def(k).spm_pmod = '';
    end

    %Calcula a duracao dos videos
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
    
    

    model.name = 'EFFORT_SEP_C_S_MOTOR';
    model.def  = def;
    
    ci = 1;     
   %% Contrastes Cues
    model.contrast(ci).vec  = [ 1 0 0];
    model.contrast(ci).name = 'CUE TEAM';
    
    ci= ci+1;
    model.contrast(ci).vec  = [ 0 1 0];
    model.contrast(ci).name = 'CUE STI';
    
    ci= ci+1;
    model.contrast(ci).vec  = [ 0 0 1];
    model.contrast(ci).name = 'CUE SELF';
    
    ci= ci+1;
    model.contrast(ci).vec  = [ 0 0 0 1];
    model.contrast(ci).name = 'CUE EFFORT TEAM';
    
    ci= ci+1;
    model.contrast(ci).vec  = [ 0 0 0 0 1];
    model.contrast(ci).name = 'CUE EFFORT STI';
    
    ci= ci+1;
    model.contrast(ci).vec  = [ 0 0 0 0 0 1];
    model.contrast(ci).name = 'CUE EFFORT SELF';
    
    ci= ci+1;
    model.contrast(ci).vec  = [ 1 -1 0];
    model.contrast(ci).name = 'CUE TEAM > CUE STI';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ -1 1 0];
    model.contrast(ci).name = 'CUE STI > CUE TEAM';
    
    ci= ci+1;
       
    model.contrast(ci).vec  = [ 1 0 -1];
    model.contrast(ci).name = 'CUE TEAM > CUE SELF';

    ci= ci+1;
       
    model.contrast(ci).vec  = [ -1 0 1];
    model.contrast(ci).name = 'CUE SELF > CUE TEAM';

    ci = ci+1;
    model.contrast(ci).vec  = [ 0 1 -1];
    model.contrast(ci).name = 'CUE STI > CUE SELF';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 -1 1];
    model.contrast(ci).name = 'CUE SELF > CUE STI';
    
    %% contrastes Squeezes
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 1];
    model.contrast(ci).name = 'SQUEEZE TEAM';

    ci = ci+1;
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 1];
    model.contrast(ci).name = 'SQUEEZE STI';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 1];
    model.contrast(ci).name = 'SQUEEZE SELF';
    
    ci = ci+1;
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 1 -1];
    model.contrast(ci).name = 'SQUEEZE TEAM > SQUEEZE STI';
    
    ci = ci+1;
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 -1 1];
    model.contrast(ci).name = 'SQUEEZE STI > SQUEEZE TEAM';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 1 0 -1];
    model.contrast(ci).name = 'SQUEEZE TEAM > SQUEEZE SELF';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 -1 0 1];
    model.contrast(ci).name = 'SQUEEZE SELF > SQUEEZE TEAM';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 1 -1];
    model.contrast(ci).name = 'SQUEEZE STI > SQUEEZE SELF';
    
      ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 -1 1];
    model.contrast(ci).name = 'SQUEEZE SELF > SQUEEZE STI';
    
      ci= ci+1;
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 1];
    model.contrast(ci).name = 'SQUEEZE EFFORT TEAM';
    
    ci= ci+1;
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 0 1];
    model.contrast(ci).name = 'SQUEEZE EFFORT STI';
    
    ci= ci+1;
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 0 0 1];
    model.contrast(ci).name = 'SQUEEZE EFFORT SELF';
    
     ci= ci+1;
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 1 0 0 -1];
    model.contrast(ci).name = 'SQUEEZE SELF > EFFORT';
    
     ci= ci+1;
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 1 0 0 -1];
    model.contrast(ci).name = 'SQUEEZE TEAM > EFFORT ';
    
    ci= ci+1;
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 1 0 0 -1];
    model.contrast(ci).name = 'SQUEEZE STI > EFFORT';


    
      %% contrastes "Squeeze" Cue Only
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 0 0 0 1];
    model.contrast(ci).name = 'SQ CUE TEAM';
       
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 0 0 0 0 1];
    model.contrast(ci).name = 'SQ CUE STI';
      
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1];
    model.contrast(ci).name = 'SQ CUE SELF';
    
 
    
    %% contrastes Squeeze > cue only
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 1 0 0 0 0 0 -1];
    model.contrast(ci).name = 'SQUEEZE SELF > SQ CUE ONLY';

    ci = ci+1;
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 1 0 0 0 0 0 -1];
    model.contrast(ci).name = 'SQUEEZE TEAM > SQ CUE ONLY';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 1 0 0 0 0 0 -1];
    model.contrast(ci).name = 'SQUEEZE STI > SQ CUE ONLY';
    
    
    %% contrastes CUE > SQUEEZE
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 1 0 0 0 0 0 -1];
    model.contrast(ci).name = 'CUE SELF > SQUEEZE SELF';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 -1 0 0 0 0 0 1];
    model.contrast(ci).name = 'SQUEEZE SELF > CUE SELF';

    ci = ci+1;
    model.contrast(ci).vec  = [ 1 0 0 0 0 0 -1];
    model.contrast(ci).name = 'CUE TEAM > SQUEEZE TEAM';
    
    ci = ci+1;
    model.contrast(ci).vec  = [ -1 0 0 0 0 0 1];
    model.contrast(ci).name = 'SQUEEZE TEAM > CUE TEAM';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 1 0 0 0 0 0 -1];
    model.contrast(ci).name = 'CUE STI > SQUEEZE STI';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 -1 0 0 0 0 0 1];
    model.contrast(ci).name = 'SQUEEZE STI > CUE STI';
    
    %% videos
    ci = ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 ];
    model.contrast(ci).name = 'VIDEO TEAM';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1];
    model.contrast(ci).name = 'VIDEO AVAI';
    
    ci = ci+1;
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 ];
    model.contrast(ci).name = 'VIDEO TEAM > AVAI';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 1];
    model.contrast(ci).name = 'VIDEO AVAI > TEAM';

 %% motor
    ci= ci+1;
    
    model.contrast(ci).vec  = [ zeros(1,length(categories)) 1];
    model.contrast(ci).name = 'MOTOR';

    model.regressor_function_handle = @get_motor_data;


end