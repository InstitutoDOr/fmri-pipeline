% List of open inputs
nrun = X; % enter the number of runs here
jobfile = {'/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/SCRIPTS/batch_modules/secondlevel/ANOVA_One-way_COV_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('serial', jobs, '', inputs{:});
