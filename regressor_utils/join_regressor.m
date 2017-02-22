function [reg_new col_new] = join_regressor( regA, regB, ztransform )

if ~isempty( regA ) && exist( regA, 'file' )
    datA = load( regA );
    datB = load( regB );
    
    if isfield( datA, 'R' ), datA = datA.R; end;
    if isfield( datB, 'R' ), datB = datB.R; end;
    
    if nargin > 2 && ztransform 
        datB = zscore( datB );
    end
    
    col_new = size(datB,2);
    
    dat = [datA datB];
    
    [p fname] = fileparts( regA );
    [pB fB] = fileparts( regB );
    reg_new = fullfile( p, [fname '_' fB '.txt']);
    dlmwrite( reg_new, dat );
else
    reg_new = regB;
end

end