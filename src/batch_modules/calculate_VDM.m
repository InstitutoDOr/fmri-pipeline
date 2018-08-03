%-----------------------------------------------------------------------
% Job saved on 06-Mar-2017 14:33:06 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (6470)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.presubphasemag.phase{1} = fmap.phase;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.presubphasemag.magnitude{1} = fmap.mag;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.et = fmap.TEs;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.maskbrain = 1;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.blipdir = -1;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.tert = fmap.readoutTime;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.epifm = 0;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.ajm = 0;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.uflags.method = 'Mark3D';
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.uflags.fwhm = 10;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.uflags.pad = 0;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.uflags.ws = 1;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.template = {fullfile( spm('Dir'), 'toolbox/FieldMap/T1.nii')};
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.fwhm = 5;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.nerode = 2;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.ndilate = 4;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.thresh = 0.5;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.reg = 0.02;

% input first volume of each run
scans = get_scans( config, preproc_dir, nrun, nvol, run_file_prefix, run_file_suffix, current_prefix );
for ns = 1:length(scans)
    
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.session(ns).epi = scans{ns}(1);
    vdms{ns,1} = fullfile(fileparts(fmap.phase), sprintf('vdm5_scPHASE_session%i.nii', ns));
end
        
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.matchvdm = 1;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.sessname = 'session';
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.writeunwarped = 1;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.anat{1} = fmap.anat;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.matchanat = 1;
