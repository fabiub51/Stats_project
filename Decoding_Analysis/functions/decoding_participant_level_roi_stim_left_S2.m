function decoding_participant_level_roi_stim_left_S2(sub_no)

dir = strcat('C:\Users\berne\Documents\Master FU\2. Semester\Stats\Decoding\data\sub-00', num2str(sub_no));
 
mkdir(dir,'\results_decoding_roi_stim_left_S2')

%% Implementation of TDT
addpath('C:\Users\berne\Documents\MATLAB\decoding_toolbox');
assert(~isempty(which('decoding_defaults.m', 'function')), 'TDT not found in path, please add')
% SPM
addpath('C:\Users\berne\Documents\MATLAB\spm12');
assert((~isempty(which('spm.m', 'function')) || ~isempty(which('BrikInfo.m', 'function'))) , 'Neither SPM nor AFNI found in path, please add (or remove this assert if you really dont need to read brain images)')

% Set defaults
cfg = decoding_defaults;
cfg.decoding.method = 'classification';

% Set the analysis that should be performed (default is 'searchlight')
cfg.analysis = 'ROI'; 

% Set the output directory where data will be saved, e.g. 'c:\exp\results\buttonpress'
if sub_no < 10
    cfg.results.dir = strcat('C:\Users\berne\Documents\Master FU\2. Semester\Stats\Decoding\data\sub-00',num2str(sub_no),'\results_decoding_roi_stim_left_S2');
else
    cfg.results.dir = strcat('C:\Users\berne\Documents\Master FU\2. Semester\Stats\Decoding\data\sub-0',num2str(sub_no),'\results_decoding_roi_stim_left_S2');
end

% Set the filepath where your SPM.mat and all related betas are, e.g. 'c:\exp\glm\model_button'
if sub_no < 10
    beta_loc = strcat('C:\Users\berne\Documents\Master FU\2. Semester\Stats\Decoding\data\sub-00',num2str(sub_no),'\1st_level_good_bad_Imag');
else 
     beta_loc = strcat('C:\Users\berne\Documents\Master FU\2. Semester\Stats\Decoding\data\sub-0',num2str(sub_no),'\1st_level_good_bad_Imag');
end

% Set the filename of the brain mask; 
cfg.files.mask = 'C:\Users\berne\Documents\Master FU\2. Semester\Stats\Decoding\data\2nd_level_analysis\Left S2.nii';

% Set the label names to the regressor names 
labelnames1  = ['StimPress'];
labelnames2  = ['StimFlutt'];
labelnames3  = ['StimVibro'];

% Values for every type of stimulation/imagery 
labelvalue1 = 1; % value for labelname1
labelvalue2 = 2; % value for labelname2
labelvalue3 = 3; % value for labelname3

%% Decide whether to see the searchlight/ROI/... during decoding
cfg.plot_selected_voxels = 0; % 0: no plotting, 1: every step, 2: every second step, 100: every hundredth step...

%% Add additional output measures if you like
% See help decoding_transform_results for possible measures
cfg.results.overwrite = 1;
cfg.results.output = {'confusion_matrix'}; % select confusion matrix as output

% The following function extracts all beta names and corresponding run
% numbers from the SPM.mat
regressor_names = design_from_spm(beta_loc);

% Extract all information for the cfg.files structure (labels will be [1 -1] if not changed above)
cfg = decoding_describe_data(cfg,{labelnames1,labelnames2,labelnames3},[labelvalue1,labelvalue2,labelvalue3],regressor_names,beta_loc);

% This creates the leave-one-run-out cross validation design:
cfg.design = make_design_cv(cfg); 

% Run decoding
results = decoding(cfg);