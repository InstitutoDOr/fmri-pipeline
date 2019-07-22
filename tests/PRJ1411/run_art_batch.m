datadir = '/dados2/PROJETOS/PRJ1411_NFB_VR/03_PROCS/PROC_DATA/fMRI_ANAT/STATS/FIRST_LEVEL/MOV_MBI_NFB';
artdir  = '/dados2/PROJETOS/PRJ1411_NFB_VR/03_PROCS/PROC_DATA/fMRI_ANAT/ART_6PARAMS/MBI';

subdir = [];

subjs = 1:10;
subjs = 5;
ignoreSubjs = [];
for s = setdiff(subjs, ignoreSubjs)
    name = sprintf('SUBJ%03d', s );
    spmFiles = utils.find( datadir, ['.*' name '.*ROI.*\/SPM\.mat'], 'f' );
    for spmFile = spmFiles
        spmFile = spmFile{1};
        [~, subjdir] = fileparts( fileparts( spmFile ) );
        artsubdir = fullfile( artdir, subjdir);
        
        fprintf( '\n### %s ###\n', subjdir);
        fprintf( '   %s\n\n', subjdir, spmFile );
        
        art_batch_IDOR( {spmFile}, {artsubdir}, s, 3, 9 );
        %   art_batch_IDOR( {spmFile}, {artsubdir}, sid, 2, 9 );
        
        close all
    end
end