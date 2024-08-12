function one_sample_t_contrast(output_path)

file_dir = strcat(output_path, '\SPM.mat');

matlabbatch{1}.spm.stats.con.spmmat = {file_dir};
matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'One sample t-test stim';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = 1;
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.delete = 0;

spm_jobman('run', matlabbatch);