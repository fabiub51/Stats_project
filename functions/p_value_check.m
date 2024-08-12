function array = p_value_check(p_values, alpha_level)

for i = 1:length(p_values)
    if p_values(i) < alpha_level
        array{i} = strcat(num2str(i), ' is significant');
    else 
        array{i} = strcat(num2str(i), ' is not significant');
    end
end