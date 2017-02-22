% List of open inputs
% fMRI model specification (design only): Directory - cfg_files
% fMRI model specification (design only): Units for design - cfg_menu
% fMRI model specification (design only): Interscan interval - cfg_entry
% fMRI model specification (design only): Data & Design - cfg_repeat
nrun = X; % enter the number of runs here
jobfile = {'/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/SCRIPTS/test_batch_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(4, nrun);
for crun = 1:nrun
    inputs{1, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification (design only): Directory - cfg_files
    inputs{2, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification (design only): Units for design - cfg_menu
    inputs{3, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification (design only): Interscan interval - cfg_entry
    inputs{4, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification (design only): Data & Design - cfg_repeat
end
spm('defaults', 'FMRI');
spm_jobman('serial', jobs, '', inputs{:});
