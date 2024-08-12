% **** DCM for every subject ****

% Created with Lorenz's script

base_dir = '/Users/almila/Desktop/stats project copy 4/data';
cd (base_dir)

for sub_no = 1:10
    clear matlabbatch
    
    data_path = sprintf('%s/sub-%03d/conc_runs_IMG_STIM', base_dir, sub_no);
    cd(data_path);
    model_output= sprintf('/Users/almila/Desktop/stats project copy 4/groupleveldcm/sub-%03d', sub_no);
    % Load the SPM model
    load(fullfile(data_path, 'SPM.mat'));
    
    % Load regions of interest (ROIs)
    load(fullfile(data_path, 'VOI_left_BA1_BA2_1.mat'), 'xY');
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
    
    DCM.a = [1 1
             1 1];
    
    % Modulated connections (B-Matrix)
    % For IMG condition
    DCM.b = zeros(n_regions, n_regions);
    % IMG enhances connections between lBA1_2 and SMA
    DCM.b = [0 1; 
             1 0]; 
    
    % Input connections (C-Matrix)
    DCM.c = [1;  % lBA1_2 receives input
             1]; % SMA receives input
    
    % Save the model
    modelfile1_name= sprintf('sub-%03d_DCM_model_simplified_IMG.mat', sub_no);
    save(fullfile(model_output, modelfile1_name), 'DCM');
    %% Alternative Model 1
    % Fixed connectivity (A-Matrix)
    DCM.a = zeros(n_regions, n_regions);
    DCM.a = [1 0
             1 1];
    
    % Modulated connections (B-Matrix)
    % For IMG condition
    DCM.b = zeros(n_regions, n_regions);
    % IMG enhances connection from lBA1_2 to SMA
    DCM.b(2, 1) = 1;
    
    % Input connections (C-Matrix)
    DCM.c = [1;  % lBA2_1 receives input
             1]; % SMA receives input
    
    
    % Save the model
    modelfile2_name= sprintf('sub-%03d_DCM_model_alternative_IMG_ff.mat', sub_no);
    save(fullfile(model_output, modelfile2_name), 'DCM');

    %% Alternative Model 2
    % Fixed connectivity (A-Matrix)
    DCM.a = zeros(n_regions, n_regions);
    DCM.a = [1 1
             0 1];
    
    % Modulated connections (B-Matrix)
    % For IMG condition
    DCM.b = zeros(n_regions, n_regions);
    % IMG enhances connection from SMA to lBA1_2
    DCM.b(1, 2) = 1;
    
    
    % Input connections (C-Matrix)
    DCM.c = [1;  % lBA1_2 receives input
             1]; % SMA receives input

    % Save the model
    modelfile3_name= sprintf('sub-%03d_DCM_model_alternative_IMG_fb.mat', sub_no);
    save(fullfile(model_output, modelfile3_name), 'DCM');
    %% DCM Estimation for both models
    
    matlabbatch{1}.spm.dcm.fmri.estimate.dcmmat = {...
        fullfile(model_output, modelfile1_name); ...
        fullfile(model_output, modelfile2_name);
        fullfile(model_output, modelfile3_name)};
    
    % Run and save the results
    spm_jobman('run', matlabbatch);

end


