function apply_global_signal( rootdir, subjs , prefix )

for s=1:length(subjs)
    subdir = fullfile( rootdir, sprintf( 'SUBJ%03i', subjs(s) ) );
    
    rd = rdir( [subdir, '/**/', [prefix '*.nii']] );
    
    for k=1:length(rd)
        
        global_signal( rd(k).name );
        
    end
end
end