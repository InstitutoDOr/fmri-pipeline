function [ conditions ] = extract_conditions( events_tsv, names, handlers )
%EXTRACT_CONDITIONS
%   events_tsv: Filename in TSV format (Tab-Separated Value)
%   names: List of conditions names to be used
if nargin < 2, names = []; end
conditions.names = unique( names );
events = {};

% Extracting all values
fh = fopen( events_tsv );
header = get_row( fh );
while ~feof( fh )
    events = [events; get_row( fh )];
end
fclose( fh );

% Basic variables
pos_onset = utils.cell.contains(header, 'onset');
pos_duration = utils.cell.contains(header, 'duration');
pos_names = utils.cell.contains(header, {'condition' 'trial_type' 'name'});
if isempty(names)
    conditions.names = unique( events(:,pos_names)' );
end

for k = 1:length( conditions.names )
    name = conditions.names{k};
    
    if isempty(handlers)
        idxs = utils.cell.contains( events(:,pos_names), name );
        conditions.onsets{k} = [events{idxs, pos_onset}];
        conditions.durations{k} = [events{idxs, pos_duration}]; 
    else
        % Handlers will define the conditions
        params = handlers.(name);
        handler = params{1};
        [onsets, durations] = handler( events, params{2:end} );
        conditions.onsets{k} = onsets;
        conditions.durations{k}= durations;
    end
end
end

% Extract values, converting to numbers when necessary
function row = get_row( fid )
line = fgetl(fid);
items = regexp(line, '\t', 'split');

row = cell(1, length(items));
for n = 1:length(items)
    row{n} = str2double( items{n} );
    if isnan(row{n})
        row{n} = items{n};
    end
end

end