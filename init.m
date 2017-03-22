function init()

fdir = fileparts(mfilename('fullpath'));
run( fullfile(fdir, '../matlab-utils/init.m') );

utils.path.includeSubdirs( {'src'});