function init()

fdir = fileparts(mfilename('fullpath'));
run( fullfile(fdir, '../matlab-utils/setup.m') );

utils.path.includeSubdirs( {'src'});