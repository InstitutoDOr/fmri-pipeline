function [conds] = correct_condition_ignore( conditions )

melhores = vertcat(conditions.onsets{1:6});
for k=melhores'
    idx = (conditions.onsets{7} == k);
    conditions.onsets{7}(idx) = [];
    conditions.durations{7}(idx) = [];
end
conds = conditions;

end

