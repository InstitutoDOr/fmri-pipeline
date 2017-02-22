matlabbatch{1}.spm.stats.factorial_design.dir = {dest_dir};
    
contr = sprintf( 'con_%04i.img,1', ci );

for s=1:length(subjs)
    
    subj = sprintf( '/SUBJ%03i/', subjs(s) );
    matlabbatch{1}.spm.stats.factorial_design.des.t1.scans{s,1} = fullfile( config.proc_base, 'STATS', 'FIRST_LEVEL',  subdir_name, subj, contr );
    
end

%%
if isfield( config.sec, 'covariate' )
    apply_covariate = ~isempty( find( config.sec.covariate.apply_contrasts == ci ) );
else
   apply_covariate = 0; 
end

if apply_covariate && isfield( config.sec.covariate, 'vec' ) && ~isempty( config.sec.covariate.vec )
    matlabbatch{1}.spm.stats.factorial_design.cov.c = config.sec.covariate.vec;
    matlabbatch{1}.spm.stats.factorial_design.cov.cname = config.sec.covariate.name;
    matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
    matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;   
else
    matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
end

matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;


matlabbatch{2}.spm.stats.fmri_est.spmmat = {fullfile( dest_dir,'SPM.mat')};
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;



matlabbatch{3}.spm.stats.con.spmmat = {fullfile( dest_dir,'SPM.mat')};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = contrast_name;
matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = 1;
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = ['-',contrast_name];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = -1;
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

if apply_covariate && isfield( config.sec, 'covariate' ) && isfield( config.sec.covariate, 'vec' ) && ~isempty( config.sec.covariate.vec )
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = config.sec.covariate.name;
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.convec = [0 1];
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = ['-',config.sec.covariate.name];
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.convec = [0 -1];
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
end

matlabbatch{3}.spm.stats.con.delete = 1;
