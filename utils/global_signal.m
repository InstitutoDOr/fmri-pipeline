function global_signal( filein )

if ~exist( 'load_untouch_nii' )
     addpath( '/dados1/PROJETOS/PRJ1210_EMOCODE/03_PROCS/ENCODING_SCRIPTS/Encoding/NIFTI_20130306' );
end

nii = load_untouch_nii( filein );
RUNUnfiltered = nii.img;
tic
[RUNFiltered mask T F pF beta R] = subtract_global_signal(RUNUnfiltered);
toc
nii.img = RUNFiltered;

[a b c] = fileparts( filein ) ;

fileout = fullfile( a, ['g' b c ] );

save( fullfile( a, [ 'globalsignal_' b '.mat']), 'R' );

save_untouch_nii( nii, fileout );

end