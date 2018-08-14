function libsetup()

fdir = fileparts(mfilename('fullpath'));
run( fullfile(fdir, '../matlab-utils/libsetup.m') );

utils.path.includeSubdirs( {
    'src'
    fullfile(fdir, '../jsonlab')
});