function [ n ] = get_num_frames( file )
%GET_NUM_FRAMES Summary of this function goes here
% Function get_nbframes from "spm_select.m"

N   = nifti(file);
dim = [N.dat.dim 1 1 1 1 1];
n   = dim(4);

end

