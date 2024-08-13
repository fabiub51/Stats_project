function extract_time_series(baseDir, subs, i)

    subjectDir = fullfile(baseDir, subs{i}, '1st_level_good_bad_Imag');

    clear matlabbatch;
    matlabbatch{1}.spm.util.voi.spmmat = {fullfile(baseDir, subs{i},'stats_test', 'SPM.mat')};
    matlabbatch{1}.spm.util.voi.adjust = 0;  % Adjust for effects of interest (0 = no adjustment)
    matlabbatch{1}.spm.util.voi.name = 'BA2';  % name VOI
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.centre = voiCoords;  
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.radius = 8;  
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.move.fixed = 1;
    matlabbatch{1}.spm.util.voi.expression = 'i1';

    %concatenate Y of all runs 
    Y_combined = [];
    Stim_combined = [];
    Imag_combined = [];

    % Loop through all runs
    for runIndex = 1:6 
        matlabbatch{1}.spm.util.voi.session = runIndex;  
        try
            spm_jobman('run', matlabbatch);
            
            %load and save the VOI-time series for this run
            voiFile = fullfile(baseDir,subs{i}, 'stats_test', sprintf('VOI_BA2_%d.mat', runIndex));
            load(voiFile)

            % concatenate the VOI time series
            Y_combined = [Y_combined; Y];
            
            % Load SPM.mat to extract psychological variables for the current run
            load(fullfile(baseDir, subs{i}, 'stats_test', 'SPM.mat'));

            % extract the psychological variables for specific run
            Stim = SPM.xX.X((runIndex-1)*242 + 1 : runIndex*242, 1);  
            Imag = SPM.xX.X((runIndex-1)*242 + 1 : runIndex*242, 2);
            
            %concatenate psychological variables
            Stim_combined = [Stim_combined; Stim];
            Imag_combined = [Imag_combined; Imag];
        catch ME
            fprintf('Error processing subject %s run %d: %s\n', subs{i}, runIndex, ME.message); %debugging try
            continue;
        end
    end

    % create psychological variable for all runs
    Psych_combined = Stim_combined - Imag_combined;

    % Save combined time series
    save(fullfile(subjectDir, 'BA2_time_series_combined.mat'), 'Y_combined')
    
    % Debugging try 2.0
    fprintf('Size of combined Y for subject %s: %d\n', subs{i}, length(Y_combined));