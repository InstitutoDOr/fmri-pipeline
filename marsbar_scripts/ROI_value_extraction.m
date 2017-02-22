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
data_dir = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PREPROC_DATA/fMRI/NORM_ANAT/';
rois_dir = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/ROIs/Solid Spheres';
out_dir  = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/ROIs/MARSBAR_OUT/';

[~, model_name, ~] = fileparts(data_dir);

%(2) the names of the participant subfolders
subjs = [2 4:16 18:19 21:26 28:32];
%subjs = [28];
nsub = length(subjs);

second_level = 0;

%(3) the ROI you have created in marsbar. You can put multiple ROIs in
%here, but I thought it was easier to put in one at a time as the output is
%messy as is.
%roi_files = {'dMPFC_5-0_54_36_roi', 'FPC1_5--6_52_18_roi', 'FPC2_5-0_62_10_roi', 'vMPFC1_5--10_42_-18_roi', 'vMPFC2_5-4_58_-8_roi'};
%roi_files = {'SG_sphere_10mm_0_26_-5_roi', 'lAccumbens_10-12_10_-6_roi', 'FPC_10-0_62_19_roi_SF_roi', 'vmPFC_Bzdok_-4_52_-2_roi', 'lAccumbens_10-12_10_-6_roi'};
roi_files = {'SG_sphere_10mm_0_26_-5_roi'};
%roi_files = { 'STI_FPC_roi' };
%roi_files = {'lTPJ-STI_-51_-52_32_roi'};
n_roi = length(roi_files);
pcs_data = zeros(length(subjs),1);

spm('Defaults', 'fmri')
b=[];
addpath( '/dados3/SOFTWARES/Blade/toolbox_IDOR/spm8/toolbox/marsbar' );

fmap = {'fcmap_Main_Effect_Task_OFC_0_53_-13_roi_1.nii', 'fcmap_Main_Effect_Task_OFC_0_53_-13_roi_2.nii', 'fcmap_Main_Effect_Task_OFC_0_53_-13_roi_4.nii', 'fcmap_Main_Effect_Task_OFC_0_53_-13_roi_5.nii'};
    
% global defaults
for n = 1: n_roi
    fprintf( 'loading ROI %s\n', roi_files{n} );
    roi_file = fullfile( rois_dir, roi_files{n} );
    load( roi_file );
    
    % pcs_data = [];
    for k = 1:length(subjs)
        subjid = sprintf('SUBJ%03d', subjs(k));
    
        for fm=1:length(fmap)
    
            fname = fullfile( data_dir, subjid, 'OUT_BetaSeries_apriori', fmap{fm});
            
            % Make marsbar ROI object
            R = maroi( roi_file );
            % Fetch data into marsbar data object
            Y = getdata(R, fname,'l');
            
            fprintf('%s: Mean = %.4f STD %.4f over %i voxels\n',subjid, nanmean(Y), nanstd(Y), length(Y) );
            
            data(k,n,fm) = nanmean(Y);
            meta_full{k,n,fm} = [fname '_X_' roi_file];
            meta{n,fm} = [fmap{fm} '_X_' roi_files{n}];
        end
        
    end
    
end

%% write to file
fid = fopen( fullfile(out_dir, ['out_fcmap_' datestr(now, 'yyyymmdd_HHMM') '.txt']), 'w');
fprintf( fid, 'SUBJECT\t' );
for n=1:size(data,2) % rois
    for fm=1:size(data,3) % input files
        fprintf( fid, '%s\t', meta{n,fm} );
    end
end

for k=1:length(subjs)
    subjid = sprintf('SUBJ%03d', subjs(k));
    fprintf( fid, '\n%s\t', subjid );

    for n=1:size(data,2) % rois
        for fm=1:size(data,3) % input files
            fprintf( fid, '%.4f\t', data(k,n,fm) );
        end
    end
    
    
end;
