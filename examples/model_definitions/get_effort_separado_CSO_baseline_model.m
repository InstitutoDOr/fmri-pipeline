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
function model = get_effort_separado_CSO_baseline_model()

    categories = { 'cueFLA', 'cueSTI' ,'cueSELF', 'cueEFFORTONLYFLA', 'cueEFFORTONLYSTI', 'cueEFFORTONLYSELF', 'cueCUEONLY_FLA', 'cueCUEONLY_STI', 'cueCUEONLY_SELF', 'fix.*|baseline', 'saldo_parcial', 'ClipFla.*', 'ClipAvai.*' };
    spm_names  = { 'CUE TEAM', 'CUE STI' ,'CUE SELF', 'CUE EFFORT TEAM', 'CUE EFFORT STI','CUE EFFORT SELF','CUEONLY TEAM', 'CUEONLY STI', 'CUEONLY SELF',  'BASELINE', 'SALDO', 'CLIP TEAM', 'CLIP AVAI' };
    durations = [ 6.5*ones(1,9) ];
    
    for k=1:length( categories )-4

        def(k).pres_type = 'Picture';
        def(k).pres_codes = { categories{k} };
        def(k).pres_termination_codes = [] ; % { 'squeeze.*' };
        def(k).pres_termination_types = { 'Picture' };
        def(k).spm_name = spm_names{k};
        def(k).spm_fix_duration = durations(k);
        def(k).spm_pmod = '';
    end

    k=k+1;
    def(k).pres_type = 'Picture';
    def(k).pres_codes = { categories{k} };
    def(k).pres_termination_codes = { 'cue.*' };
    def(k).pres_termination_types = { 'Picture' };
    def(k).spm_name = spm_names{k};
    def(k).spm_fix_duration = [];
    def(k).spm_pmod = '';
    
    k=k+1;
    def(k).pres_type = 'Picture';
    def(k).pres_codes = { categories{k} };
    def(k).pres_termination_codes = [];
    def(k).pres_termination_types = { 'Picture' };
    def(k).spm_name = spm_names{k};
    def(k).spm_fix_duration = 8;
    def(k).spm_pmod = '';
    
    for k=length( categories )-1:length( categories )
        def(k).pres_type = 'Video';
        def(k).pres_codes = { categories{k} };
        def(k).pres_termination_codes = { 'fixposclip' };
        def(k).pres_termination_types = { 'Picture' };
        def(k).spm_name = spm_names{k};
        def(k).spm_fix_duration = [];
        def(k).spm_pmod = '';
    end
    
    

    model.name = 'EFFORT_SEP_CSO_BASELINE';
    model.def  = def;
    
    ci = 1;
    %% contrastes entre condicoes subtraindo effort
    model.contrast(ci).vec  = [ 1 -1 0 -1 1 0 ];
    model.contrast(ci).name = 'intCSO TEAM > CSO STI';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ -1 1 0 1 -1 0];
    model.contrast(ci).name = 'intCSO STI > CSO TEAM';
    
    ci= ci+1;
       
    model.contrast(ci).vec  = [ 1 0 -1 -1 0 1];
    model.contrast(ci).name = 'intCSO TEAM > CSO SELF';

    ci= ci+1;
       
    model.contrast(ci).vec  = [ -1 0 1 1 0 -1];
    model.contrast(ci).name = 'intCSO SELF > CSO TEAM';

    ci = ci+1;
    model.contrast(ci).vec  = [ 0 1 -1 0 -1 1];
    model.contrast(ci).name = 'intCSO STI > CSO SELF';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 -1 1 0 1 -1];
    model.contrast(ci).name = 'intCSO SELF > CSO STI';
       
    %% contrastes com baseline esforco
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 1 0 0 -1];
    model.contrast(ci).name = 'CSO TEAM > CSO EFFORT TEAM';

    ci = ci+1;
    model.contrast(ci).vec  = [ 0 1 0 0 -1];
    model.contrast(ci).name = 'CSO STI > CSO EFFORT STI';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 1 0 0 -1];
    model.contrast(ci).name = 'CSO SELF > CSO EFFORT SELF';


    %% contrastes com baseline sem esforco
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 1 0 0 0 0 0 -1];
    model.contrast(ci).name = 'CSO TEAM > CUEONLY TEAM';

    ci = ci+1;
    model.contrast(ci).vec  = [ 0 1 0 0 0 0 0 -1];
    model.contrast(ci).name = 'CSO STI > CUEONLY STI';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 1 0 0 0 0 0 -1];
    model.contrast(ci).name = 'CSO SELF > CUEONLY SELF';
    
    %% contrastes simples
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 1 0 0 0 0 0 0];
    model.contrast(ci).name = 'CSO TEAM';

    ci = ci+1;
    model.contrast(ci).vec  = [ 0 1 0 0 0 0 0 0];
    model.contrast(ci).name = 'CSO STI';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 1 0 0 0 0 0];
    model.contrast(ci).name = 'CSO SELF';
    
      %% contrastes direto cada condicao
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 1 -1 0 0 0 0 0];
    model.contrast(ci).name = 'CSO TEAM > CSO STI';

    ci = ci+1;
    model.contrast(ci).vec  = [ 1 0 -1 0 0 0 0 0];
    model.contrast(ci).name = 'CSO TEAM > CSO SELF';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 -1 1 0 0 0 0 0];
    model.contrast(ci).name = 'CSO SELF > CSO STI';    
    
    %% contrastes simples no reward
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 1 0 0 0 0 0 0];
    model.contrast(ci).name = 'CSO EFFORT TEAM';

    ci = ci+1;
    model.contrast(ci).vec  = [ 0 0 0 0 1 0 0 0 0 0 0];
    model.contrast(ci).name = 'CSO EFFORT STI';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 1 0 0 0 0 0];
    model.contrast(ci).name = 'CSO EFFORT SELF';
    
    %% contrastes simples cue only
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 1 0 0 0];
    model.contrast(ci).name = 'CUE ONLY TEAM';

    ci = ci+1;
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 1 0 0 0];
    model.contrast(ci).name = 'CUE ONLY STI';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 0 0 1 0 0];
    model.contrast(ci).name = 'CUE ONLY SELF';
    
    %% baseline
    ci= ci+1;
    
    model.contrast(ci).vec  = [ zeros(1,length(categories)-4) 1];
    model.contrast(ci).name = 'FIX';
    
    %% saldo
    ci= ci+1;
    
    model.contrast(ci).vec  = [ zeros(1,length(categories)-3) 1];
    model.contrast(ci).name = 'SALDO';
    
    %% videos
    ci = ci+1;
    model.contrast(ci).vec  = [ zeros(1,length(categories)-2) 1 0 ];
    model.contrast(ci).name = 'VIDEO TEAM';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ zeros(1,length(categories)-2) 0 1];
    model.contrast(ci).name = 'VIDEO AVAI';
    
    ci = ci+1;
    model.contrast(ci).vec  = [ zeros(1,length(categories)-2) 1 -1 ];
    model.contrast(ci).name = 'VIDEO TEAM > AVAI';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ zeros(1,length(categories)-2) -1 1];
    model.contrast(ci).name = 'VIDEO AVAI > TEAM';

    model.regressor_function_handle = '';

end