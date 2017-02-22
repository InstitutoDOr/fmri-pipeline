function subdir_name = get_subdir_name( config , subdir_name )

if nargin < 2
    subdir_name = ''; 
end

if config.outlier_regressor 
    subdir_name = ['OUT_' subdir_name ];
end

if config.mov_regressor 
    subdir_name = ['MOV_' subdir_name ];
end

if config.resp_regressor
    subdir_name = ['RESP_' subdir_name ];
end