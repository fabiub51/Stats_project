function specification_2nd_level_stim(output_path, data_path, sub_no)

file_dir = {};

for i = 1:length(sub_no)
    if sub_no(i) < 10
        file_dir{i} = strcat(data_path,num2str(0),num2str(sub_no(i)), '\results_decoding\sres_accuracy_minus_chance.nii');
    else
        file_dir{i} = strcat(data_path,num2str(sub_no(i)), '\results_decoding\sres_accuracy_minus_chance.nii');
    end

end

file_dir = file_dir';

clear matlabbatch

matlabbatch{1}.spm.stats.factorial_design.dir = {output_path};
%%
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = file_dir;
%%
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

spm_jobman('run', matlabbatch);