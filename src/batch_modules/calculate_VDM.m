%-----------------------------------------------------------------------
% generated using SPM12 (6470)
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
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.sessname = fmap.suffix;

% input first volume of each run
for ns = 1:length(funcs)
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.session(ns).epi{1} = [funcs{ns}, ',1'];
    vdmname = sprintf('vdm5_sc%s_%s%d.nii', utils.path.basename(fmap.phase, 0), fmap.suffix, ns);
    vdms{ns,1} = fullfile(fileparts(fmap.phase), vdmname);
end
        
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.matchvdm = 1;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.writeunwarped = 1;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.anat{1} = [anat_file ',1'];
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.matchanat = 1;
