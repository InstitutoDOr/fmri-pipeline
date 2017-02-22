function update_docs()
% UPDATE_DOCS Function to update documentation for this library
curdir = pwd;
root_dir = 'fmri-pipeline';

cd ../..
addpath( fullfile(pwd, 'm2html') );
m2html('mfiles', root_dir, 'htmldir', fullfile(root_dir, '/docs/html'), ...
    'recursive','on', 'global','on', ...
    'template','frame', 'index','menu');

cd(curdir);

end