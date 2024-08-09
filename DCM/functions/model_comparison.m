function model_comparison(data_path, dcm_models)

clear matlabbatch
matlabbatch{1}.spm.dcm.bms.inference.dir = {data_path};
matlabbatch{1}.spm.dcm.bms.inference.sess_dcm{1}.dcmmat = {fullfile(data_path, dcm_models{1});
    fullfile(data_path, dcm_models{2});
    fullfile(data_path, dcm_models{3})};
matlabbatch{1}.spm.dcm.bms.inference.model_sp = {''};
matlabbatch{1}.spm.dcm.bms.inference.load_f = {''};
matlabbatch{1}.spm.dcm.bms.inference.method = 'FFX';
matlabbatch{1}.spm.dcm.bms.inference.family_level.family_file = {''};
matlabbatch{1}.spm.dcm.bms.inference.bma.bma_no = 0;
matlabbatch{1}.spm.dcm.bms.inference.verify_id = 1;

spm_jobman('run', matlabbatch);
