fmri_hdr = neuro.bids.loadjson( funcs{1} );
nslices = length(fmri_hdr.SliceTiming);
TR = task_details.RepetitionTime;
[~, slice_order] = sort(fmri_hdr.SliceTiming);

for ns = 1:length(funcs)
    matlabbatch{1}.spm.temporal.st.scans{ns} = expand_volumes( funcs(ns), [], current_prefix );
end
matlabbatch{1}.spm.temporal.st.nslices = nslices;
matlabbatch{1}.spm.temporal.st.tr = task_details.RepetitionTime;
matlabbatch{1}.spm.temporal.st.ta = TR-(TR/nslices);
matlabbatch{1}.spm.temporal.st.so = slice_order;
matlabbatch{1}.spm.temporal.st.refslice = ceil(nslices/2);
matlabbatch{1}.spm.temporal.st.prefix = 'a';



