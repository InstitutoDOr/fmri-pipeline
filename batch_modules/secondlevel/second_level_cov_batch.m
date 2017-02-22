%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
matlabbatch{1}.spm.stats.factorial_design.dir = {'/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/SECOND_LEVEL/RESP_MOV_EFFORT_SEP_CSO/CLEAN7_COV/CSO TEAM - CSO SELF/'};
%%
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = {
                                                          '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL/RESP_MOV_EFFORT_SEP_CSO/SUBJ002/con_0003.img,1'
                                                          '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL/RESP_MOV_EFFORT_SEP_CSO/SUBJ004/con_0003.img,1'
                                                          '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL/RESP_MOV_EFFORT_SEP_CSO/SUBJ005/con_0003.img,1'
                                                          '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL/RESP_MOV_EFFORT_SEP_CSO/SUBJ006/con_0003.img,1'
                                                          '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL/RESP_MOV_EFFORT_SEP_CSO/SUBJ007/con_0003.img,1'
                                                          '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL/RESP_MOV_EFFORT_SEP_CSO/SUBJ008/con_0003.img,1'
                                                          '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL/RESP_MOV_EFFORT_SEP_CSO/SUBJ009/con_0003.img,1'
                                                          '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL/RESP_MOV_EFFORT_SEP_CSO/SUBJ011/con_0003.img,1'
                                                          '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL/RESP_MOV_EFFORT_SEP_CSO/SUBJ012/con_0003.img,1'
                                                          '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL/RESP_MOV_EFFORT_SEP_CSO/SUBJ015/con_0003.img,1'
                                                          };
%%
matlabbatch{1}.spm.stats.factorial_design.cov.c = [3
                                                   6
                                                   0
                                                   5
                                                   4
                                                   2
                                                   4
                                                   1
                                                   2
                                                   5];
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'DiffID';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).sname = 'Factorial design specification: SPM.mat File';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep;
matlabbatch{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
matlabbatch{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'CSO TEAM - CSO SELF';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = 1;
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = '-CSO TEAM - CSO SELF';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = -1;
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'DiffID';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.convec = [0 1];
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
