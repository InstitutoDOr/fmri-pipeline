function so = get_sliceorder( type, N)

if strcmp(type, 'interleaved')
    so = [1:2:N 2:2:N]; % interleaved Siemens
    if mod(N,2) == 0
        so = so([end/2+1:end 1:end/2]); % for even number of slices, even slices are aquired first
    end
elseif strcmp(type, 'ascending')
    so = 1:N;    
elseif strcmp(type, 'descending')
    so = N-1:1;
else
    error('sliceorder not known (should be ascending, descending or interleaved)')
end

end

