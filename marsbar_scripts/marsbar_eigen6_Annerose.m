clear all;
%
%subj       = {'SUBJ002'};




savpath = 'C:\\ANNEROSE\marsbar\results_design1_p001k5';



roipath = 'C:\\Annerose\marsbar\ROI_p001k5' ;

roi_files = {   ...
%'VaT-VnT_-45_-1_7'
% 'Pleasure_NAcc_12_8_-10'
% 'Pleasure_SGC_-3_17_-10'
% 'SGCsphere_10mm_-2_15_-5'
% 'aHYPsphere_10--3_2_-14'
% 'lvSTR_-9_9_-8'
% 'rvSTR_9_9_-8'

'Levels_pos_18_-10_-25_roi'
'Levels_pos_27_2_-1_roi'
'Levels_pos_27_-25_68_roi'
'Levels_pos_30_23_50_roi'
'Levels_pos_45_-70_-40_roi'
'Levels_pos_48_-16_56_roi'
'Levels_pos_57_-4_17_roi'
'Levels_pos_-3_-31_38_roi'
'Levels_pos_-12_-16_68_roi'
'Levels_pos_-18_35_53_roi'
'Levels_pos_-18_-13_-19_roi'
'Levels_pos_-21_-34_59_roi'
'Levels_pos_-30_17_56_roi'
'Levels_pos_-30_-70_38_roi'
'Levels_pos_-51_-10_47_roi'

};

savefile_all = 'Beta_TC_all_m1';


for i=1%:24 SUBJ6 - 1 and 3 and 5,6 nao funciona
    
    subj{i} = sprintf( 'SUBJ%03i', i );
    
    for j =1: length(roi_files)
        
        
        clear SPM.mat
        %%
        %load(['Z:\\PRJ1209_SAMBASYNC\03_PROCS\PROC_DATA\FIRST_LEVEL\design3_subjrat\' subj{i} '\SPM.mat' ]);
        %D =
        %mardo(SPM);
        D = mardo(['Z:\\PRJ1209_SAMBASYNC\03_PROCS\PROC_DATA\FIRST_LEVEL\design1_only_picresp_movparam_noslicetime\' subj{i} '\SPM.mat' ]);
        D = cd_images(D, ['Z:\\PRJ1209_SAMBASYNC\03_PROCS\PREPROC_DATA\' subj{i} ]);
        R = maroi(fullfile(roipath , [roi_files{j} '.mat']));
        Y = get_marsy(R,D,'eigen1');
        savestruct( Y, fullfile(savpath , [ subj{i}  '_' roi_files{j} '_timecourse.mat']));
        E = estimate(D,Y);
        xCon = get_contrasts(D);
        E = set_contrasts(E,xCon);
        b = betas(E);
        allbetas(:,j,i) = betas(E);
        alltimecourses(:,j,i) = summary_data(Y);
        

%%%y = summary_data(Y); % get summary time course(s)

      
        marsS = compute_contrasts(E, 1:length(xCon));
        cont = marsS.con;
        Tval = marsS.stat;
        pval = marsS.P;
        pcorr = marsS.Pc;
        
        f = length(Tval);
        Roinr = zeros(1,f)'+i;      
        
        
        
        connr=zeros(1,f)';
        for k = 1:length(connr)            
            connr(k,1)=k;
        end
        
        
        
    fid = fopen(fullfile(savpath , [subj{i}  '_' roi_files{j} '_eigen.txt']),'w');
    for k=1:length(Tval),
        fprintf(fid,'%3f %3f %3f %6.3f %6.3f %6.3f %6.3f\n', ...
        i, Roinr(k), connr(k), cont(k), Tval(k), pval(k), pcorr(k));
    end
    fclose(fid);
    
    

    end
 
end

save (savefile_all,'allbetas','alltimecourses')




    





