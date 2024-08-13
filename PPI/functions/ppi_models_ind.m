function ppi_models_ind(subs, baseDir, i)

    subjectDir = fullfile(baseDir, subs{i}, '1st_level_good_bad_Imag');
    cd(subjectDir)
 
    load('BA2_time_series_combined.mat') %Load the time series
    load(fullfile(baseDir, subs{i}, 'stats_test', 'SPM.mat')) % Load the SPM.mat file

    % Define the psych variables
    Stim_combined = [];
    Imag_combined = [];

    for runIndex = 1:6
        Stim = SPM.xX.X((runIndex-1)*242 + 1 : runIndex*242, 1);  
        Imag = SPM.xX.X((runIndex-1)*242 + 1 : runIndex*242, 2);
        
        Stim_combined = [Stim_combined; Stim];
        Imag_combined = [Imag_combined; Imag];
    end

    Psych_combined = Stim_combined - Imag_combined;    % difference between the conditions 

    % create the interaction term
    Interaction_combined = Psych_combined .* Y_combined;

    % create PPI-model
    X = [Psych_combined Y_combined Interaction_combined];

    % predict PPI-Model
    [betas, ~, stats] = glmfit(X, Y_combined);  

    % save results
    save(fullfile(subjectDir, 'PPI_results_combined.mat'), 'betas', 'stats')