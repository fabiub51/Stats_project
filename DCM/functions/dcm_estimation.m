function dcm_estimation(data_path, dcm_models)

matlabbatch{1}.spm.dcm.fmri.estimate.dcmmat = {...
    fullfile(data_path, dcm_models{1}); ...
    fullfile(data_path, dcm_models{2});
    fullfile(data_path, dcm_models{3})};

% Run and save the results
spm_jobman('run', matlabbatch);