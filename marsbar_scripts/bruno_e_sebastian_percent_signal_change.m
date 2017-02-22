% Extraction of Percent signal change using marsbar and SPM8: BATCH.
% The file structures are in this script are in Mac OS X format.
% PC users should find all the '/' in the script and replace with '\'.
% Also make sure your directory works in MATLAB as '/Volumes/Disk/Data'
% works on Mac where as 'C:\Data\' is a typical PC configuration.
% This script assumes you have a first level fMRI design which has been
% estimated in SPM, and has a set of contrasts specified.
% This script assumes your design is stored in /my/path/SPM.mat and you
% have an ROI stored in /my/path/my_roi.mat.
% The only four things you will hopefully need to change are:
% (1) the data root directory (a folder that contains all the participant subfolders);
% (2) the names of the participant subfolders; and,
% (3) the ROI you have created in marsbar.
% (4) the file name and type to which you want your percent signal change values to be saved.
% These are indicated below. See (5) if the script doesn't use all the
% contrasts available.
% The output file is saved as a single row and is comma delimited,
% so all you need to do is delete the first item (the title) that is delimited by a comma,
% insert a return before each of the 'sub' IDs (participant subfolders) so that each
% participants' data is on a new row, and then save the file.
% The final step is to import the data into Excel. File > Import... > Text
% file > Choose your file > Delimited Start import at row 1 > Delimiters
% tick comma > Finish > OK. The first column should be the participant subfolder
% and the last column should be '/n'. As Excel may find the values with minus signs
% as a formula, just Find All '=' and replace with nothing, and while you are at it
% do the '/n' as well.

%(1) Directories:
curdir = pwd;
data_dir = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL/RESP_MOV_AR_EFFORT_SEP_CSO_TIAGO';
%data_dir = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL/RESP_MOV_AR_EFFORT_SEP_CSO_ANNR';
%data_dir = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/SECOND_LEVEL/ANOVAS/One_Way_02_32_CSO';
%rois_dir = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/ROIs/Bzdok_Moral_2012';
rois_dir = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/ROIs/Solid Spheres';
out_dir  = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/ROIs/MARSBAR_OUT/';

[~, model_name, ~] = fileparts(data_dir);

%(2) the names of the participant subfolders
subjs = [2:16 18:26 28:32];
nsub = length(subjs);

second_level = 0;

%(3) the ROI you have created in marsbar. You can put multiple ROIs in
%here, but I thought it was easier to put in one at a time as the output is
%messy as is.
%roi_files = {'dMPFC_5-0_54_36_roi', 'FPC1_5--6_52_18_roi', 'FPC2_5-0_62_10_roi', 'vMPFC1_5--10_42_-18_roi', 'vMPFC2_5-4_58_-8_roi'};
roi_files = {'SG_sphere_10mm_0_26_-5_roi', 'lAccumbens_10-12_10_-6_roi', 'FPC_10-0_62_19_roi_SF_roi', 'vmPFC_Bzdok_-4_52_-2_roi', 'lAccumbens_10-12_10_-6_roi'};
%roi_files = { 'STI_FPC_roi' };
%roi_files = {'lTPJ-STI_-51_-52_32_roi'};
n_roi = length(roi_files);
pcs_data = zeros(length(subjs),1);

spm('Defaults', 'fmri')
b=[];
addpath( '/dados3/SOFTWARES/Blade/toolbox_IDOR/spm8/toolbox/marsbar' );

% global defaults
for n = 1: n_roi
    fprintf( 'loading ROI %s\n', roi_files{n} );
    roi_file = fullfile( rois_dir, roi_files{n} );
    load( roi_file );
    
    % pcs_data = [];
    for k = 1:length(subjs)
        subjid = sprintf('SUBJ%03d', subjs(k));
        subdir = fullfile( data_dir, subjid );
        if second_level, subdir = data_dir, end
        sprintf('Working on participant %s\n',subdir)
        cd(subdir);
        load SPM;
        % Make marsbar design object
        D = mardo(SPM);
        % Make marsbar ROI object
        R = maroi( roi_file );
        % Fetch data into marsbar data object
        Y = get_marsy(R, D, 'mean');
        % Get contrasts from original design
        xCon = get_contrasts(D);
        % Estimate design on ROI data
        E = estimate(D, Y);
        % Put contrasts from original design back into design object
        E = set_contrasts(E, xCon);
        % get design betas
        b(:,k) = betas(E);
        % get stats and stuff for all contrasts into statistics structure
        % (5) I edited this so stop at the basic contrasts for the events
        % as the script didn't work for me with my design otherwise.
        % The original script had: marsS = compute_contrasts(E, 1:length(xCon));
        % marsS = compute_contrasts(E, 1:4);
        % Get definitions of all events in model
        [e_specs, e_names] = event_specs(E);
        n_events = size(e_specs, 2);
        dur = 6.5;
        pct_ev = [];
        % Return percent signal esimate for all events in design
        for e_s = 1:n_events
            pct_ev(e_s) = event_signal(E, e_specs(:,e_s), dur);
        end
        %Aloca memoria para as matrizes
        if( k==1 )
            pcs_data = zeros(length(subjs), n_events);
            nEvtS = max(e_specs(2,:)); %number of events per session
            pcs_data_mean = zeros(length(subjs), nEvtS);
        end
        pcs_data(k,:) = pct_ev;
        pcs_data_mean(k,:) = mean( reshape( pct_ev, nEvtS, [] )' );
        
        % contrasts (pego dos scripts de Annerose
        marsS(k) = compute_contrasts(E, 1:length(xCon));
        cont = marsS.con;
        Tval = marsS.stat;
        pval = marsS.P;
        pcorr = marsS.Pc;
        
        %% FIR timecourses per session
        % Get definitions of all events in model
      %  [e_specs, e_names] = event_specs(E);
      %  n_events = size(e_specs, 2);
        % Bin size in seconds for FIR
      %  bin_size = tr(E);
        % Length of FIR in seconds
       % fir_length = 24;
        % Number of FIR time bins to cover length of FIR
      %  bin_no = fir_length / bin_size;
        % Options - here 'single' FIR model, return estimated
       % opts = struct('single', 1, 'percent', 1);
        % Return time courses for all events in fir_tc matrix
        %for e_s = 1:n_events
         %   fir_tc(:, e_s) = event_fitted_fir(E, e_specs(:,e_s), bin_size, ...
          %      bin_no, opts);
       % end
        
        %% FIR timecourses across session
        % Get compound event types structure
        %ets = event_types_named(E);
       % n_event_types = length(ets);
        % Bin size in seconds for FIR
        %bin_size = tr(E);
        % Length of FIR in seconds
       % fir_length = 24;
        % Number of FIR time bins to cover length of FIR
      %  bin_no = fir_length / bin_size;
        % Options - here 'single' FIR model, return estimated % signal change
     %   opts = struct('single', 1, 'percent', 1);
    %    for e_t = 1:n_event_types
     %       fir_tc_subject(:, e_t,k) = event_fitted_fir(E, ets(e_t).e_spec, bin_size, ...
      %          bin_no, opts);
    %    end


    end
    
    %fir_tc_ss_mean = squeeze( mean( fir_tc_subject, 3 ) );
    %fir_tc_ss_std  = squeeze( std( fir_tc_subject, 0, 3 ) );
    
    %x = [0:bin_size:fir_length-bin_size];
    
    %figure, plot( x, fir_tc_ss_mean ), xlabel( 'time (s)' ), ylabel( '% signal change'), title( roi_files{n}  ), legend( {ets.name} )

    %figure, 
    %cc=hsv(12);
    %for e_t = 1:n_event_types
    %    errorbar(x, fir_tc_ss_mean(:,e_t), fir_tc_ss_std(:,e_t), 'color',cc(e_t,:) );
    %    hold on,
    %end
    %xlabel( 'time (s)' ), ylabel( '% signal change'), title( roi_files{n}  )
    
    %out.fir_tc_ss_mean = fir_tc_ss_mean;
    %out.fir_tc_ss_std = fir_tc_ss_std;
    %out.fir_tc_subject = fir_tc_subject;
    %out.subjs = subjs;
    %out.ets = ets;
    %out.roi_file = roi_files{n};
    
    %save( fullfile(out_dir, ['timecourses_PSC_' out.roi_files{n} '_' datestr(now, 'yyyymmdd_HHMM') '.mat']), 'out' );
    
   % regname=char(SPM.xX.name(1,:));

    % (4) the file name (e.g., ROI co-ords) and type (e.g., .txt, .csv, .xls) to which you want your
    % percent signal change values to be saved.
    % regname = char (e_names);
    fvolumes = fopen( fullfile(out_dir, ['out_PSC_' model_name '_' roi_files{n} '_' datestr(now, 'yyyymmdd_HHMM') '.txt']), 'w');
    fprintf( fvolumes, 'ROI =\t%s\tMODEL=\t%s\n\n', roi_files{n}, model_name );
    fprintf( fvolumes, 'SUBJ x Eventos\t' );
    for nname=1:n_events
        nS = e_specs(1,nname);%numero da sessao
        fprintf(fvolumes, '%s (%d)\t',e_names{nname}, nS);
    end
    
    for nsub=1:length(subjs)
        subjid = sprintf('SUBJ%03d', nsub);
        fprintf( fvolumes, '\n%s\t', subjid );
        fprintf( fvolumes, '%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t', pcs_data(nsub,:));
    end;
    
    %Valores com as médias.
    fprintf( fvolumes, '\n\nMÉDIAS\n' );
    fprintf( fvolumes, 'SUBJ x Eventos\t' );
    for nname=1:n_events
        nS = e_specs(1,nname);%numero da sessao
        if ( nS > 1 ); break; end;
        fprintf(fvolumes, '%s\t',e_names{nname});
    end
    
    for nsub=1:length( subjs )
        subjid = sprintf('SUBJ%03d', nsub);
        fprintf( fvolumes, '\n%s\t', subjid );
        fprintf( fvolumes, '%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t', pcs_data_mean(nsub,:));
    end;
    
    fclose('all');
    
    
    %% betas
    fid = fopen( fullfile(out_dir, ['out_beta_' model_name '_' roi_files{n} '_' datestr(now, 'yyyymmdd_HHMM') '.txt']), 'w');
    fprintf( fid, 'ROI =\t%s\tMODEL=\t%s\n\n', roi_files{n}, model_name );
    fprintf( fid, 'SUBJ x BETA\t' );
    
    for nname=1:length(e_names)/3 %% we have three sessions in this project
        fprintf(fid, '%s\t',e_names{nname});
    end
    
    for nsub=1:length(subjs)
        subjid = sprintf('SUBJ%03d', nsub);
        fprintf( fid, '\n%s\t', subjid );
        
        for nname=1:length(e_names)/3 %% we have three sessions in this project
            
            beta_target = e_names{nname};
            
            beta_inds = find( ~cellfun( @isempty, regexp( [SPM.xX.name], ['Sn\([0-9]\) ' beta_target '\*bf\([0-9]+\)\>' ] ) ) );
            
            if length(beta_inds) ~= 3, error('three beta values expected'), end
            
            mean_beta = mean(b(beta_inds,nsub));
            fprintf( fid, '%.4f\t', mean_beta);

        end
        
    end;
   
    %% contrasts
    fid = fopen( fullfile(out_dir, ['out_contrasts_' model_name '_' roi_files{n} '_' datestr(now, 'yyyymmdd_HHMM') '.txt']), 'w');
    fprintf( fid, 'ROI =\t%s\tMODEL=\t%s\n\n', roi_files{n}, model_name );
    fprintf( fid, 'SUBJ x CONTRAST\t' );
 
    for c=1:length(marsS(1).rows)
        fprintf(fid, '%s\t',marsS(1).rows{c}.name);
    end
    
    for nsub=1:length(subjs)
        subjid = sprintf('SUBJ%03d', nsub);
        fprintf( fid, '\n%s\t', subjid );
        
        for c=1:length(marsS(nsub).rows)
             fprintf( fid, '%.4f\t', marsS(nsub).con(c) );
        end
        
    end
        
    % cont = marsS.con;
    % Tval = marsS.stat;
    % pval = marsS.P;
    % pcorr = marsS.Pc;
    
    fclose('all');
end
cd(curdir);