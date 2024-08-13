function contrasts(groupDir)

clear matlabbatch;

%set up contrast manager
matlabbatch{1}.spm.stats.con.spmmat = {fullfile(groupDir, 'SPM.mat')};
matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'PPI-Interaction';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = 1; % Adjust the weights as needed
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

% Save and run the batch
save(fullfile(groupDir, 'group_GLM_contrast.mat'), 'matlabbatch');
spm_jobman('run', matlabbatch);