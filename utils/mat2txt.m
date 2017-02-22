function mat2txt( file, col_fields, row_field_name, outfile )

if ~iscell(file)
    files{1} = file;
else
    files = file;
end

fid = fopen( outfile, 'a+' );
fprintf(fid, 'FILENAME\t');
fprintf(fid, '%s\t%', row_field_name);
for cols=1:length(col_fields)
    fprintf(fid, '%s\t', col_fields{cols});
end
fprintf(fid, '\n' );

for f=1:length(files)
a = load( files{f} );

[~, fname, ~ ] = fileparts(files{f});

row_fields = a.(row_field_name);
for r=1:length(row_fields)
    
    
    %% all lines for same condition
    ind = 1;
    while true
        
        myfprintf( fid, fname );
    
        myfprintf( fid, row_fields{r} );
    
        for k=1:length(col_fields)

           vals = a.(col_fields{k});
           try
               if isempty(vals{r})
                    myfprintf( fid, 0 );
               else
                    myfprintf( fid, vals{r}(ind) );
               end
           catch 
               myfprintf( fid, 0 );
               disp( sprintf( '%s - %s - %s - %i\n', fname, row_fields{r}, col_fields{k}, ind ) )
           end

        end
       
        fprintf( fid, '\n' );
        
        if length( vals{r} ) == ind
            break
        end

        ind = ind + 1;
   
    end

end

end
fclose(fid);

end



function myfprintf( fid, val )

if iscell(val)
    tmp = val{1};
else
    tmp = val;
end

if ischar(tmp)
    fprintf( fid, '%s\t', tmp);
else
    fprintf( fid, '%f\t', tmp);
end

end
    