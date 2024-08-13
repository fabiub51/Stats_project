function specification(subs, baseDir, groupDir)

contrastFiles = cell(length(subs), 1);
for i = 1:length(subs)
    subjectDir = fullfile(baseDir, subs{i}, '1st_level_good_bad_Imag');
    contrastFiles{i} = fullfile(subjectDir, 'con_0001.nii,1'); 
end

clear matlabbatch;
% Set up the factorial design specification
matlabbatch{1}.spm.stats.factorial_design.dir = {groupDir};
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = contrastFiles;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

% save and run the batch
save(fullfile(groupDir, 'group_GLM_batch.mat'), 'matlabbatch');
spm_jobman('run', matlabbatch);