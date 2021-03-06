function [ conditions ] = extract_conditions( events_tsv, conds, handlers )
%EXTRACT_CONDITIONS
%   events_tsv: Filename in TSV format (Tab-Separated Value)
%   names: List of conditions names to be used
if nargin < 2, conds = []; end
try
    conditions.names = unique( {conds.name} );
catch
    conditions.names = unique( conds );
end
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
pos_names = utils.cell.contains(header, {'trial_type' 'condition' 'name'}); % Looking for one of these names
if isempty(conds)
    conditions.names = unique( events(:,pos_names)' );
end

data = struct('header', {header}, 'events', {events});
for k = 1:length( conditions.names )
    name = conditions.names{k};
    if isempty(handlers)
        if strcmp(name, 'single')
            idxs = 1:size(events,1);
        else
            idxs = utils.cell.contains( events(:,pos_names), name );
        end
        conditions.onsets{k} = [events{idxs, pos_onset}];
        conditions.durations{k} = [events{idxs, pos_duration}];
        if isfield(conds(k), 'pmod') && ~isempty(conds(k).pmod)
            conditions.pmod{k} = conds(k).pmod;
            for pk = 1:length(conds(k).pmod)
                pos_pmod = utils.cell.contains(header, conds(k).pmod(pk).name);
                conditions.pmod{k}(pk).param = [events{idxs, pos_pmod}];
            end
        end
    else
        % Handlers will define the conditions
        params = handlers.(name);
        handler = params{1};
        [onsets, durations, pmod] = handler(data, params{2:end} );
        conditions.onsets{k} = onsets;
        conditions.durations{k}= durations;
        conditions.pmod{k}= pmod;
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