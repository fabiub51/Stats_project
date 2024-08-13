%% Specification and Estimation

% Script is used to concatenate all the runs to a single run in order
% to do the time-series extraction across all runs at once

clear matlabbatch

sub_dir = 'D:\project_stats\shared_data\sub-002';
cd(sub_dir)
load conc_onsets.mat
sub_folders = dir(fullfile(sub_dir, 'run*'));

run = {};

comma = ",";

for i = 1:length(sub_folders)
    run4D = cellstr(spm_select('FPList',fullfile(sub_dir,sub_folders(i).name),'^ds.*\d{2}\.nii$'));
    run(length(run)+1:length(run)+242,1) = spm_select('expand',run4D);
end

run = cellstr(run);


matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;

% The three stimulation and imagery conditions are each combined into a
% single condition, as we do not consider the vibration type in our analysis

onsets_stim = [[conc_onsets_fin{1}', conc_onsets_fin{2}', conc_onsets_fin{3}']'];
onsets_img = [[conc_onsets_fin{4}', conc_onsets_fin{5}', conc_onsets_fin{6}']'];
onsets_null_1 = conc_onsets_fin{7};
onsets_null_2 = conc_onsets_fin{8};
onsets_preCue = conc_onsets_fin{9};
onsets_motion = conc_onsets_fin{10};
onsets_badImg = conc_onsets_fin{11};
matlabbatch{1}.spm.stats.fmri_spec.dir = {'D:\project_stats\shared_data\sub-002\stats\conc_runs'};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = run;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).name = 'STIM';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).onset = onsets_stim;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).duration = 3;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).orth = 1;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).name = 'IMG';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).onset = onsets_img;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).duration = 3;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).orth = 1;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).name = 'Null_1';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).onset = onsets_null_1;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).duration = 3;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).orth = 1;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).name = 'Null_2';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).onset = onsets_null_2;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).duration = 3;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).orth = 1;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).name = 'preCue';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).onset = onsets_preCue;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).duration = 3;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).orth = 1;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).name = 'Motion';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).onset = onsets_motion;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).duration = 3;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).orth = 1;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(7).name = 'badImg';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(7).onset = onsets_badImg;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(7).duration = 3;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(7).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(7).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(7).orth = 1;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = {''};


matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';


spm_jobman('run',matlabbatch);

scans = [242 242 242 242 242 242];

cd D:\project_stats\shared_data\sub-002\stats\conc_runs

% The SPM.mat is adjusted for the concatenated runs

spm_fmri_concatenate('SPM.mat', scans);

clear matlabbatch

matlabbatch{1}.spm.stats.fmri_est.spmmat = {'D:\project_stats\shared_data\sub-002\stats\conc_runs\SPM.mat'};
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;

spm_jobman('run',matlabbatch);

