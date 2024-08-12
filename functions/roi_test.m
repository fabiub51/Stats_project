function [stats1, p1, stats2, p2, stats3, p3] = roi_test(subs, roi_result)

bonferroni = 0.05/3;

% specify empty lists to store accuracies of all participants
Group_results_1 = []; 
Group_results_2 = [];
Group_results_3 = [];

for i = 1:length(subs)
    % If else statement for different lengths of the file path
    if i < 10
        i = num2str(i);

        ROI_Results = load([strcat('C:\Users\berne\Documents\Master FU\2. Semester\Stats\Decoding\data\sub-00', i ,'\results_decoding', roi_result)]);
    else
        i = num2str(i);

        ROI_Results = load([strcat('C:\Users\berne\Documents\Master FU\2. Semester\Stats\Decoding\data\sub-0', i ,'\results_decoding', roi_result)]);
    end

    Group_results_1 = [Group_results_1, ROI_Results.results.confusion_matrix.output{1}(1,1)]; % extract accuracies of top left field in confusion matrix
    Group_results_2 = [Group_results_2, ROI_Results.results.confusion_matrix.output{1}(2,2)]; % extract accuracies of central field in confuison matrix
    Group_results_3 = [Group_results_3, ROI_Results.results.confusion_matrix.output{1}(3,3)]; % extract accuracies of bottom right field in confusion matrix

end

% One-sample t-tests 
% subtracting chance level from all accuracies first to test against zero
Group_results_1 = Group_results_1 - 100/3;
Group_results_2 = Group_results_2 - 100/3;
Group_results_3 = Group_results_3 - 100/3;

[h_1_l, p_1_l, ci_1_l, stats_1_l] = ttest(Group_results_1, 0, 'Alpha', bonferroni); % Get stats for Press condition
[h_2_l, p_2_l, ci_2_l, stats_2_l] = ttest(Group_results_2, 0, 'Alpha', bonferroni); % Get stats for flutter condition
[h_3_l, p_3_l, ci_3_l, stats_3_l] = ttest(Group_results_3, 0, 'Alpha', bonferroni); % Get stats for vibration condition

stats1 = stats_1_l;
stats2 = stats_2_l;
stats3 = stats_3_l;

p1 = p_1_l;
p2 = p_2_l;
p3 = p_3_l;