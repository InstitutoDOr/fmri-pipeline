function [ conditions ] = extract_conditions( events_tsv, names )
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

% Preparing conditions
pos_onset = contains(header, 'onset');
pos_duration = contains(header, 'duration');
pos_names = contains(header, {'condition' 'trial_type'});

if isempty(names)
    conditions.names = unique( events(:,pos_names)' );
end

for k = 1:length( conditions.names )
    name = conditions.names{k};
    idxs = contains( events(:,pos_names), name );
    conditions.onsets{k} = [events{idxs, pos_onset}];
    conditions.durations{k} = [events{idxs, pos_duration}];
end

end

% Function to find elements in a cell
function idx = contains( elems, items )
if ~iscell(items), items = {items}; end

for item = items
    IndexC = strfind(elems, item{1});
    idx = find(not(cellfun('isempty', IndexC)));
    if idx > 0
        break
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