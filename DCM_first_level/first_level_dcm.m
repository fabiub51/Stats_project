%% First level DCM estimation and model comparison

% Directory of the data
data_path = 'D:\project_stats\shared_data\sub-002\stats\conc_runs_IMG_selfcon';

% Load the SPM model
load(fullfile(data_path, 'SPM.mat'));

% Load regions of interest (ROIs)
load(fullfile(data_path, 'VOI_lBA1_2_1.mat'), 'xY');
DCM.xY(1) = xY;
load(fullfile(data_path, 'VOI_SMA_1.mat'), 'xY');
DCM.xY(2) = xY;

n_regions = 2;

DCM.n = length(DCM.xY);      % Number of regions
DCM.v = length(DCM.xY(1).u); % Number of time points

% Time series
DCM.Y.dt  = SPM.xY.RT;
DCM.Y.X0  = DCM.xY(1).X0;
for i = 1:DCM.n
    DCM.Y.y(:,i)  = DCM.xY(i).u;
    DCM.Y.name{i} = DCM.xY(i).name;
end

DCM.Y.Q    = spm_Ce(ones(1, DCM.n) * DCM.v);

% Experimental inputs
DCM.U.dt   = SPM.Sess(1).U.dt;
DCM.U.name = [SPM.Sess(1).U(2).name];
DCM.U.u    = [SPM.Sess(1).U(2).u];

% DCM parameters and options
DCM.delays = repmat(SPM.xY.RT / 2, DCM.n, 1);
DCM.TE     = 0.04;

DCM.options.nonlinear  = 0;
DCM.options.two_state  = 0;
DCM.options.stochastic = 0;
DCM.options.nograph    = 1;

%% Standard model
% Fixed connectivity (A-Matrix)
DCM.a = zeros(n_regions, n_regions);
% rBA2 influences SMA
% DCM.a(1, 2) = 1;
% % SMA influences rBA2
% DCM.a(2, 1) = 1;

DCM.a = [1 1
         1 1];

% Modulated connections (B-Matrix)
% For IMG condition
DCM.b = zeros(n_regions, n_regions);
% IMG enhances connections between rBA2 and SMA
DCM.b = [0 1;  % rBA2 influences SMA
         1 0]; % SMA influences rBA2

% Input connections (C-Matrix)
DCM.c = [1;  % rBA2 receives input
         1]; % SMA receives input

% Save the model
save(fullfile(data_path, 'DCM_model_simplified_IMG.mat'), 'DCM');
%% Alternative Model 1
% Fixed connectivity (A-Matrix)
DCM.a = zeros(n_regions, n_regions);
% rBA2 influences SMA
% DCM.a(2, 1) = 1;
DCM.a = [1 0
         1 1];

% Modulated connections (B-Matrix)
% For IMG condition
DCM.b = zeros(n_regions, n_regions);
% IMG enhances connection from rBA2 to SMA
DCM.b(2, 1) = 1;

% Input connections (C-Matrix)
DCM.c = [1;  % rBA2 receives input
         1]; % SMA receives input

% Save the model
save(fullfile(data_path, 'DCM_model_alternative_IMG_ff.mat'), 'DCM');
%% Alternative Model 2
% Fixed connectivity (A-Matrix)
DCM.a = zeros(n_regions, n_regions);
% rBA2 influences SMA
% DCM.a(1, 2) = 1;
DCM.a = [1 1
         0 1];

% Modulated connections (B-Matrix)
% For IMG condition
DCM.b = zeros(n_regions, n_regions);
% IMG enhances connection from SMA to rBA2
DCM.b(1, 2) = 1;


% Input connections (C-Matrix)
DCM.c = [1;  % rBA2 receives input
         1]; % SMA receives input

% Save the model
save(fullfile(data_path, 'DCM_model_alternative_IMG_fb.mat'), 'DCM');
%% DCM Estimation for all models

matlabbatch{1}.spm.dcm.fmri.estimate.dcmmat = {...
    fullfile(data_path, 'DCM_model_simplified_IMG.mat'); ...
    fullfile(data_path, 'DCM_model_alternative_IMG_ff.mat');
    fullfile(data_path, 'DCM_model_alternative_IMG_fb.mat')};

% Run and save the results
spm_jobman('run', matlabbatch);

%% Model comparison
% BMS
clear matlabbatch
matlabbatch{1}.spm.dcm.bms.inference.dir = {'D:\project_stats\shared_data\sub-002\stats\conc_runs_IMG_selfcon'};
matlabbatch{1}.spm.dcm.bms.inference.sess_dcm{1}.dcmmat = {
                                                           'D:\project_stats\shared_data\sub-002\stats\conc_runs_IMG_selfcon\DCM_model_simplified_IMG.mat'
                                                           'D:\project_stats\shared_data\sub-002\stats\conc_runs_IMG_selfcon\DCM_model_alternative_IMG_ff.mat'
                                                           'D:\project_stats\shared_data\sub-002\stats\conc_runs_IMG_selfcon\DCM_model_alternative_IMG_fb.mat'
                                                           };
matlabbatch{1}.spm.dcm.bms.inference.model_sp = {''};
matlabbatch{1}.spm.dcm.bms.inference.load_f = {''};
matlabbatch{1}.spm.dcm.bms.inference.method = 'FFX';
matlabbatch{1}.spm.dcm.bms.inference.family_level.family_file = {''};
matlabbatch{1}.spm.dcm.bms.inference.bma.bma_no = 0;
matlabbatch{1}.spm.dcm.bms.inference.verify_id = 1;

spm_jobman('run', matlabbatch);

