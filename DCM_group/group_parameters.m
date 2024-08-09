% **** This script gathers the selected model's parameter values and performs a t-test ****

% Put all the parameter Eps in a matrix


num_participants = 10;
num_parameters = 8;
parameter_matrix = zeros(num_participants, num_parameters);

% Use the parameters estimated in first level DCM

for i = 1:num_participants
filename = sprintf('/Users/almila/Desktop/stats project copy 4/groupleveldcm/sub-%03d/sub-%03d_DCM_model_simplified_IMG.mat', i, i);
    load(filename);
    
    parameter_matrix(i, 1) = DCM.Ep.A(1,1); % SC: lBA1/2 - self-conection
    parameter_matrix(i, 2) = DCM.Ep.A(1,2); % EC: lBA1/2 SMA - endogenous connection
    parameter_matrix(i, 3) = DCM.Ep.A(2,1); % EC: SMA lBA1/2
    parameter_matrix(i, 4) = DCM.Ep.A(2,2); % SC: SMA
    parameter_matrix(i, 5) = DCM.Ep.B(1,2); % MC: lBA1/2 SMA - imagery modulatory connection
    parameter_matrix(i, 6) = DCM.Ep.B(2,1); % MC: SMA lBA1/2
    parameter_matrix(i, 7) = DCM.Ep.C(1,1); % DI: lBA1/2
    parameter_matrix(i, 8) = DCM.Ep.C(2,1); % DI: SMA
end

% One sample t-test to see if the parameters are significant on group level

[h, p, ci, stats] = ttest(parameter_matrix);

data_dir = '/Users/almila/Desktop/stats project copy 4/bms1';
cd(data_dir)
save('ttest_results.mat', 'h', 'p', 'ci', 'stats');

for param_idx = 1:num_parameters
    fprintf('Parameter %d: t = %.4f, p = %.4f\n', param_idx, stats.tstat(param_idx), p(param_idx));
end

% FDR correction (Bioinformatix Toolbox)

q = mafdr(p, 'BHFDR', true);


h_fdr = q < 0.05; % is parameter significant after FDR? 

formatted_h_fdr = cell(8, 1);
for i = 1:8
    if h_fdr(i)
        formatted_h_fdr{i} = 'True';
    else
        formatted_h_fdr{i} = 'False';
    end
end
    
save('ttest_results_fdr.mat', 'h', 'p', 'ci', 'stats', 'q', 'h_fdr');

% Make a table
T = table((1:num_parameters)', p' , q', formatted_h_fdr', ...
    'VariableNames', {'Parameter', 'p value', 'FDR Corrected p', 'Significant FDR'});

% Make a figure
fig = uifigure('Name', 'Connectivity Parameters Results');
uit = uitable(fig, 'Data', T, 'ColumnName', T.Properties.VariableNames, 'RowName', {});
uit.Position = [20 20 600 200];

