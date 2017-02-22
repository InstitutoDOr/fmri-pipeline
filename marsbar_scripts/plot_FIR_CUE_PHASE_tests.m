rdir = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/ROIs/MARSBAR_TIMECOURSES/';
%load( fullfile(rdir, 'timecourses_PSC_STI_FPC_roi_20150704_0850.mat' ));
load( fullfile(rdir, 'timecourses_PSC_RESP_MOV_CUE_SEP_MOTOR_SG_sphere_5mm_0_26_-5_roi_20150818_1127'));

targets = { 'CUE SELF', 'CUE TEAM', 'CUE STI' , 'CUE EFFORT SELF','CUE EFFORT TEAM', 'CUE EFFORT STI', 'CUEONLY TEAM','CUEONLY SELF','CUEONLY STI','CLIP TEAM', 'CLIP AVAI'};

%targets = { 'CUE SELF', 'CUE TEAM', 'CUE STI', 'CUE EFFORT SELF', 'CUE EFFORT TEAM', 'CUE EFFORT STI',   'CUEONLY SELF', 'CUEONLY TEAM', 'CUEONLY STI', 'CLIP TEAM', 'CLIP AVAI'};
colors    = { 'k', 'b', 'r', 'k', 'b', 'r', 'k', 'b', 'r', 'g', 'm'};
linestyle = { '-', '-', '-', '--', '--', '--', ':',':',':', '-.','-.'};


inds = [];
for t=1:length(targets)
    ti = find(strcmp( {out.ets.name}, targets{t}));
    inds(t) = ti;
end

fir_tc_ss_mean = squeeze( mean( out.fir_tc_subject(:,inds,:), 3 ) );
fir_tc_ss_std  = squeeze( std( out.fir_tc_subject(:,inds,:), 0, 3 ) );

x = [0:out.bin_size:out.fir_length-out.bin_size];
%x = [0:2:22];

figure, 
for k=1:size(fir_tc_ss_mean,2)
    plot( x, fir_tc_ss_mean(:,k) , 'color', colors{k}, 'linestyle', linestyle{k}, 'linewidth', 2),
    hold on
end
%plot( x, fir_tc_ss_mean + fir_tc_ss_std )
%plot( x, fir_tc_ss_mean - fir_tc_ss_std )
xlabel( 'time (s)' ), ylabel( '% signal change'), 
title( out.roi_file  ), 
legend( {out.ets(inds).name} )
