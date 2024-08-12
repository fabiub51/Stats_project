%% Decoding batch
addpath('C:\Users\berne\Documents\MATLAB\spm12'); % add SPM12 to current path
addpath('C:\Users\berne\Documents\MATLAB\decoding_toolbox') % add TDT to current path
subs = 1:10; % Specify subjects 

%% Searchlight analysis - stimulus condition 

for i = 1:length(subs)
    decoding_participant_level_stim(subs(i))
end

%% Searchlight analysis - imagery condition 

for i = 1:length(subs)
    decoding_participant_level_imag(subs(i))
end

%% Smoothing - stimulus and imagery
% Top-level folder 
data_path = 'C:\Users\berne\Documents\Master FU\2. Semester\Stats\Decoding\data\sub-0';

%smoothing images 8x8x8mm
smoothing_stim(data_path, length(subs));
smoothing_imag(data_path, length(subs));

%% 2nd level analysis - stimulus and imagery 

% Specification - stimulus
mkdir 'C:\Users\berne\Documents\Master FU\2. Semester\Stats\Decoding\data\2nd_level_analysis'
output_path_stim = 'C:\Users\berne\Documents\Master FU\2. Semester\Stats\Decoding\data\2nd_level_analysis';
specification_2nd_level_stim(output_path_stim, data_path, subs);

% Specification - imagery
mkdir 'C:\Users\berne\Documents\Master FU\2. Semester\Stats\Decoding\data\2nd_level_imag'
output_path_imag = 'C:\Users\berne\Documents\Master FU\2. Semester\Stats\Decoding\data\2nd_level_imag';
specification_2nd_level_imag(output_path_imag, data_path, subs);

% Estimation - stimulus and imagery
estimation_stim(output_path_stim);
estimation_imag(output_path_imag);

% Simple t-contrast for stimulus and imagery
one_sample_t_contrast(output_path_stim) % stimulus
one_sample_t_contrast(output_path_imag) % imagery

%% Inspect results in the GUI 
% no masking
% p <= 0.001 (uncorr.)
% extent threshold = 1000 voxels (stim), 100 voxels (imagery) 
% extract ROIs using GUI
    % 3 in the stimulus condition
    % 2 in the imagery condition 

%% Accuracies of extracted clusters using the GUI
% y = raw y-data for every participant extracted from respective clusters through the GUI

% stimulus condition 
% Calculate mean accuracy and standard deviation for Right S2 Cluster
Inc_right = mean(y,2);
overall_mean_cluster_right = mean(Inc_right);
sd_right = std(mean(y,1));

% Calculate mean accuracy and standard deviation for Left S2 Cluster
Inc_left = mean(y,2);
overall_mean_cluster_left = mean(Inc_left);
sd_left = std(mean(y,1));

% Calculate mean accuracy and standard deviation for occipital cluster 
Inc_occipital_p = mean(y,2);
overall_mean_cluster_occipital = mean(Inc_occipital_p);
sd_occipital = std(mean(y,1));

% imagery condition 
% Calculate mean accuracy and standard deviation for Left BA1 and BA2
% Cluster 
Inc_imag_left = mean(y,2);
overall_mean_cluster_left_imag = mean(Inc_imag_left);
sd_left_imag = std(mean(y,1));

% Calculate mean accuracy and standard deviation for Occipital Cluster 
Inc_imag_post = mean(y,2);
overall_mean_cluster_post_imag = mean(Inc_imag_post);
sd_post_imag = std(mean(y,1));

%% ROI analyses
% Circular check if clusters do contain information 
% once for every cluster

% function extracting decoding accuracies from confusion matrix of every participant 
% then, one-sample t-tests are calculated for every condition (Does cluster
% decode significantly above chance level?)
% accounting for multiple comparisons: 
bonferroni = 0.05/3;

% returning statistics and p-values for every condition 
%% ROI analysis - Stimulus Left S2 ROI

% Decoding ROI analysis
for i = 1:length(subs)
    decoding_participant_level_roi_stim_left_S2(subs(i))
end

roi_type = '_roi_stim_left_S2\res_confusion_matrix.mat'; % specify which ROI is analyzed

[stats_1,p_1,stats_2,p_2,stats_3,p_3] = roi_test(subs, roi_type); % function conducting t-tests

% gather p-values and statistics in arrays
p_values_left_S2 = [p_1,p_2,p_3];
stats_left_S2 = [stats_1, stats_2, stats_3];

% function returning if t-tests were significant 
left_S2 = p_value_check(p_values_left_S2, bonferroni);

%% ROI analysis - Stimulus Right S2 ROI 

% Decoding ROI analysis
for i = 1:length(subs)
    decoding_participant_level_roi_stim_right_S2(subs(i))
end

roi_type = '_roi_stim_right_S2\res_confusion_matrix.mat'; % specify which ROI is analyzed

[stats_1,p_1,stats_2,p_2,stats_3,p_3] = roi_test(subs, roi_type); % function conducting t-tests

% gather p-values and statistics in arrays
p_values_right_S2 = [p_1,p_2,p_3];
stats_right_S2 = [stats_1, stats_2, stats_3];

% function returning if t-tests were significant 
right_S2 = p_value_check(p_values_right_S2, bonferroni);

%% ROI analysis - Stimulus Occiptial ROI 

% Decoding ROI analysis
for i = 1:length(subs)
    decoding_participant_level_roi_stim_occipital(subs(i))
end

roi_type = '_roi_stim_occipital\res_confusion_matrix.mat'; % specify which ROI is analyzed

[stats_1,p_1,stats_2,p_2,stats_3,p_3] = roi_test(subs, roi_type); % function conducting t-tests

% gather p-values and statistics in arrays
p_values_occipital = [p_1,p_2,p_3];
stats_occipital = [stats_1, stats_2, stats_3];

% function returning if t-tests were significant 
occipital = p_value_check(p_values_occipital, bonferroni);

%% ROI analysis - Imagery Occiptial ROI 

% Decoding ROI analysis
for i = 1:length(subs)
    decoding_participant_level_roi_imag_occipital(subs(i))
end

roi_type = '_roi_imag_occipital\res_confusion_matrix.mat'; % specify which ROI is analyzed

[stats_1,p_1,stats_2,p_2,stats_3,p_3] = roi_test(subs, roi_type); % function conducting t-tests

% gather p-values and statistics in arrays
p_values_occipital_imag = [p_1,p_2,p_3];
stats_occipital_imag = [stats_1, stats_2, stats_3];

% function returning if t-tests were significant 
occipital_imag = p_value_check(p_values_occipital_imag, bonferroni);
%% ROI analysis - Imagery Left BA1, BA2 ROI

% Decoding ROI analysis
for i = 1:length(subs)
    decoding_participant_level_roi_imag_left(subs(i))
end

roi_type = '_roi_imag_left\res_confusion_matrix.mat'; % specify which ROI is analyzed

[stats_1,p_1,stats_2,p_2,stats_3,p_3] = roi_test(subs, roi_type); % function conducting t-tests

% gather p-values and statistics in arrays
p_values_left_imag = [p_1,p_2,p_3];
stats_left_imag = [stats_1, stats_2, stats_3];

% function returning if t-tests were significant 
left_imag = p_value_check(p_values_left_imag, bonferroni);
%% 2nd level analysis - create 10 maps leaving one participant out each run 

matrix_participants = repmat(subs,10,1); % Create a matrix of all participants ten times
% leave one participant out each time to compare the clusters 

A = matrix_participants; % Example matrix
n = size(A, 1); % Number of rows (and columns, since A is square)

matrix_participant_leave_one_out = zeros(n, n-1); % Preallocate the result matrix with the appropriate size

for i = 1:n
    row = A(i, :); % Extract the current row
    row(i) = []; % Remove the diagonal element
    matrix_participant_leave_one_out(i, :) = row; % Assign the modified row to the result matrix
end


% Specification - stimulus
for i = 1:size(matrix_participant_leave_one_out,1)
    output_path_stim = strcat('C:\Users\berne\Documents\Master FU\2. Semester\Stats\Decoding\data\2nd_level_analysis\map_',num2str(i));
    specification_2nd_level_stim(output_path_stim, data_path, matrix_participant_leave_one_out(i,:));
end

% Specification - imagery
for i = 1:size(matrix_participant_leave_one_out,1)
    output_path_imag = strcat('C:\Users\berne\Documents\Master FU\2. Semester\Stats\Decoding\data\2nd_level_imag\map_',num2str(i));
    specification_2nd_level_imag(output_path_imag, data_path, matrix_participant_leave_one_out(i,:));
end

% Estimation - stimulus 
for i = 1:size(matrix_participant_leave_one_out,1)
    output_path_stim = strcat('C:\Users\berne\Documents\Master FU\2. Semester\Stats\Decoding\data\2nd_level_analysis\map_',num2str(i));
    estimation_stim(output_path_stim);
end

% Estimation - imagery 
for i = 1:size(matrix_participant_leave_one_out,1)
    output_path_imag = strcat('C:\Users\berne\Documents\Master FU\2. Semester\Stats\Decoding\data\2nd_level_imag\map_',num2str(i));
    estimation_stim(output_path_imag);
end

% Contrast t-contrast for stimulus and imagery
for i = 1:size(matrix_participant_leave_one_out,1)
    output_path_stim = strcat('C:\Users\berne\Documents\Master FU\2. Semester\Stats\Decoding\data\2nd_level_analysis\map_',num2str(i));
    one_sample_t_contrast(output_path_stim);
end

% Contrast - imagery 
for i = 1:size(matrix_participant_leave_one_out,1)
    output_path_imag = strcat('C:\Users\berne\Documents\Master FU\2. Semester\Stats\Decoding\data\2nd_level_imag\map_',num2str(i));
    one_sample_t_contrast(output_path_imag);
end
