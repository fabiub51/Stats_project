function estimation_stim(output_path)

file_dir = strcat(output_path, '\SPM.mat');

matlabbatch{1}.spm.stats.fmri_est.spmmat = {file_dir};
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;

spm_jobman('run', matlabbatch);