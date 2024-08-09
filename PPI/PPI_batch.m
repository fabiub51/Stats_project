%% Psycho-Physiological Interaction 
% Setting up paths and directories 
spm_path = 'C:\Users\lealo\Documents\MatLab\SPM\spm12 (1)\spm12';
baseDir = 'C:\Users\lealo\Documents\Master Cog Neuro\statsproject\'; 
functionDir = 'C:\Users\lealo\Documents\Master Cog Neuro\statsproject\functions';
groupDir = fullfile(baseDir, 'group_analysis');
voiCoords = [-40 -40 60]; % coordinates for the left BA1/2 from decoding 

% Initialize SPM
addpath(spm_path); 
spm_jobman('initcfg')
spm fmri

% definition of the subjects and conditions
subs = {'sub-001','sub-002','sub-003','sub-004','sub-005','sub-006','sub-007','sub-008','sub-009','sub-010' }; 
conditions = {'Stim', 'Imag'}; 

%% extracting the time series of the VOI for each subject

for i = 1:length(subs)    
    % function extracting time series and saving it in the subject's 
    % directory
    extract_time_series(baseDir, subs, i) 
end

%% Individual PPI models for each subject
for i = 1:length(subs)
    % function creating individual PPI models and saving it in the
    % subject's directory
    ppi_models_ind(subs, baseDir, i)
end

%% Group analysis
% Specification 
specification(subs, baseDir, groupDir)

%Estimation: manually with the GUI

% Setting up contrast manager
contrasts(groupDir)

% visualized manually using the GUI

