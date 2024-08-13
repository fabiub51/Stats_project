cd D:\project_stats\shared_data\sub-002\stats\conc_runs_IMG_selfcon
% Initialize the models
models = {'DCM_model_simplified_IMG.mat', 'DCM_model_alternative_IMG_ff.mat', 'DCM_model_alternative_IMG_fb.mat'};
colors = {'r', 'g', 'b'};
modelNames = {'Model 1', 'Model 2', 'Model 3'};

% Create a new figure
figure;

% Create an array to store the axes handles
axesHandles = gobjects(1, length(models));

% Initialize variables to store global y-axis limits
globalYMin = Inf;
globalYMax = -Inf;

% First loop to find the global y-axis limits
for k = 1:length(models)
    loadedData = load(models{k});
    DCM = loadedData.DCM;
    
    % Extract the A parameters
    try
        i = [1 2 3 4 6 7 9 10]';
    catch
        i = 1 + (1:DCM.n^2);
    end
    qE = spm_vec(DCM.Ep);
    qC = DCM.Cp;

    % Find the current y-axis limits
    currentYMin = min(qE(i) - sqrt(diag(qC(i, i))));
    currentYMax = max(qE(i) + sqrt(diag(qC(i, i))));

    % Update the global y-axis limits
    globalYMin = min(globalYMin, currentYMin);
    globalYMax = max(globalYMax, currentYMax);
end

% Expand the negative region of the y-axis
yOffset = 0.1; % Adjustment value to further lower the bottom limit
globalYMin = globalYMin - yOffset;

% Titles for the subplots
titles = {'Model 1: Bidirectional', 'Model 2: Feedforward', 'Model 3: Feedback'};

% Custom x-axis labels
xLabels = {'SC: lBA1/2', 'EC: lBA1/2 SMA', 'EC: SMA lBA1/2','SC: SMA', 'MC: lBA1/2 SMA', 'MC: SMA lBA1/2', 'DI: lBA1/2', 'DI: SMA'};

% Font size for the x-tick labels
xTickFontSize = 15; % Adjust this number as needed

% Second loop to plot and set the y-axis limits
for k = 1:length(models)
    loadedData = load(models{k});
    DCM = loadedData.DCM;
    
    % Extract the A parameters
    try
        i = [1 2 3 4 6 7 9 10]';
    catch
        i = 1 + (1:DCM.n^2);
    end
    qE = spm_vec(DCM.Ep);
    qC = DCM.Cp;

    if DCM.options.two_state
        qE = exp(qE);
    end
    
    % Create a subplot for the current model
    axesHandles(k) = subplot(1, 3, k);
    spm_plot_ci(qE(i), qC(i, i));
    
    % Set the global y-axis limits
    ylim([globalYMin, globalYMax]);

    % Add the y-axis label only to the first subplot
    if k == 1
        ylabel('Posterior Estimates', 'FontSize', 18);
    end
    
    % Add the x-axis label to all subplots
    xlabel('Parameters', 'FontSize', 18);
    
    % Add the title to each subplot
    title(titles{k}, 'FontSize', 20);
    
    % Add custom x-axis labels
    xticks(1:length(xLabels)); % Set the position of the x-ticks
    xticklabels(xLabels); % Set the labels of the x-ticks
    
    % Change the font size of the x-tick labels
    set(gca, 'XTickLabel', get(gca, 'XTickLabel'), 'FontSize', xTickFontSize);
end
