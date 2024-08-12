function smoothing_imag(data_path, sub_no)

file_dir = {};
for r = 1:sub_no
    if r < 10
        file_dir{r} = strcat(data_path,num2str(0),num2str(r), '\results_decoding_imag\res_accuracy_minus_chance.nii');
    else
        file_dir{r} = strcat(data_path,num2str(r), '\results_decoding_imag\res_accuracy_minus_chance.nii');
    end
end

file_dir = file_dir';

clear matlabbatch

matlabbatch{1}.spm.spatial.smooth.data = file_dir;
matlabbatch{1}.spm.spatial.smooth.fwhm = [8 8 8];
matlabbatch{1}.spm.spatial.smooth.dtype = 0;
matlabbatch{1}.spm.spatial.smooth.im = 0;
matlabbatch{1}.spm.spatial.smooth.prefix = 's';

spm_jobman('run', matlabbatch);