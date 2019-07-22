function [ n ] = get_num_frames( file )
%GET_NUM_FRAMES Summary of this function goes here
% Function get_nbframes from "spm_select.m"


try
    N = nifti(file);
    n = N.dat.dim(4);
catch
    if exist('niftijio.NiftiHeader', 'class')
        N = javaMethod('read', 'niftijio.NiftiHeader', file);
        n = double(N.dim(5));
    else
        error('SPM does not recognize the file format of %s', file)
    end
end

end

