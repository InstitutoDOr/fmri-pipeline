function run_second_level( config )

for m = 1:length(config.model)

    subdir_name = config.model(m).name ;
    subdir_name = get_subdir_name( config, subdir_name );

    for ci=1:length(config.model(m).contrast)

        contrast_name = strtrim(strrep( config.model(m).contrast(ci).name, '>' , '-' ));

        dest_dir = fullfile( config.proc_base, 'STATS', 'SECOND_LEVEL',  subdir_name, config.sec.name, contrast_name );
        if ~isdir(dest_dir), mkdir(dest_dir), end
        cd ( dest_dir );

        disp (['Second level for Design: ', subdir_name, ' and contrast: ', contrast_name, '. Results written to: ', contrast_name]); 

        subjs = config.sec.g1;
       
        clear matlabbatch;
        ttest_spm_flex;
        save( fullfile( dest_dir, 'BATCH_SECOND_LEVEL.mat'), 'matlabbatch' );
        spm_jobman('run',matlabbatch);
    end
    

end

end


