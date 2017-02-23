mricronCmd = 'mricron';
template = '/usr/local/mricron/templates/ch2bet.nii.gz';
dir_ativs = '/dados1/PROJETOS/PRJ1411_NFB_VR/03_PROCS/EXPORTED_IMGS/bruno/FIXED_EFFECT';
overlays = {
    '"/dados2/PROJETOS/PRJ1411_NFB_VR/03_PROCS/EXPORTED_IMGS/bruno/ROIS/Anguish_ROI.nii" -c red'
    '"/dados2/PROJETOS/PRJ1411_NFB_VR/03_PROCS/EXPORTED_IMGS/bruno/ROIS/Tenderness_ROI.nii" -c blue'
    };

p_thr = '005';
algos = {'ROI', 'SVM'};
%algos = {'ROI'};
contrasts = {'A - T - All Sessions', 'T - A - All Sessions'};

patterns = {};
for algo = algos
    for contrast = contrasts
        patterns{end+1} = ['.*' algo{1} '.*\/.*' contrast{1} '.*' ];
    end
end


%Defining subjs
for pattern = patterns
    files = idor.utils.find( dir_ativs, [pattern{1} '\/.*.' p_thr '.*.nii$'], 'f' );
    for file = files
        fprintf('** Arquivo: %s\n\n', file{1})
        sOverlays = sprintf(' -o %s -l 0.1 -h 0.1', overlays{:});
        cmd = sprintf('%s "%s" -o "%s" -c green -l 0.1 -h 2 %s -x -b 20 -t -1', mricronCmd, template, file{1}, sOverlays);
        system( cmd );
    end
end