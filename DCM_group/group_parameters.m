%% Evaluate the winning model parameters


% Put all the parameter Eps in a matrix


subs = 10
num_parameters = 8
parameter_matrix = zeros(subs, num_parameters);

% Use the parameters estimated in first level DCM

for i = 1:subs
filename = sprintf('/Users/almila/Desktop/stats project copy 4/groupleveldcm/sub-%03d/sub-%03d_DCM_model_simplified_IMG.mat', i, i);
    load(filename);
    
    parameter_matrix(i, 1) = DCM.Ep.A(1,1); % SC: lBA1/2 - self-conection
    parameter_matrix(i, 2) = DCM.Ep.A(1,2); % EC: lBA1/2 SMA - endogenous connection
    parameter_matrix(i, 3) = DCM.Ep.A(2,1); % EC: SMA lBA1/2
    parameter_matrix(i, 4) = DCM.Ep.A(2,2); % SC: SMA
    parameter_matrix(i, 5) = DCM.Ep.B(1,2); % MC: lBA1/2 SMA - imagery modulatory connection
    parameter_matrix(i, 6) = DCM.Ep.B(2,1); % MC: SMA lBA1/2
    parameter_matrix(i, 7) = DCM.Ep.C(1,1); % DI: lBA1/2 - Driving input
    parameter_matrix(i, 8) = DCM.Ep.C(2,1); % DI: SMA
end

% One sample t-test to see if the parameters are significant on group level

[h, p, ci, stats] = ttest(parameter_matrix);

data_path = '/Users/almila/Desktop/stats project copy 4/bms1'
cd(data_path)
save('ttest_results.mat', 'h', 'p', 'ci', 'stats');

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

% Round the values to two decimal places for display 

rounded_p = round(p, 2);
rounded_q = round(q, 2);


% Get rid of the last 2 zeros for display

formatted_p = arrayfun(@(x) num2str(x, '%.4g'), rounded_p, 'UniformOutput', false);
formatted_q = arrayfun(@(x) num2str(x, '%.4g'), rounded_q, 'UniformOutput', false);

% Make a table

parameter_names = {'SC: lBA 1/2','EC: lBA 1/2 SMA','EC: SMA lBA 1/2','SC: SMA','MC: lBA 1/2 SMA','MC: SMA lBA 1/2', 'DI: lBA1/2', 'DI: SMA'}

T = table(parameter_names', formatted_p' , formatted_q', formatted_h_fdr, ...
    'VariableNames', {'Parameter', 'p value', 'FDR Corrected p', 'Significant FDR'});

% Make a figure

fig = uifigure('Name', 'Connectivity Parameters Results');
uit = uitable(fig, 'Data', T, 'ColumnName', T.Properties.VariableNames, 'RowName', {});
uit.Position = [20 20 600 200];

%% Visualize the BMS Exceedence Probabilities

% Load the BMS data

load('/Users/almila/Desktop/stats project copy 4/groupleveldcm/BMS.mat');

% Xps

model_xp = BMS.DCM.rfx.model.xp ;
model_pxp = BMS.DCM.rfx.model.pxp ;

% Round the values to two decimal places for display 

rmodel_xp = round(model_xp,2);
rmodel_pxp = round(model_pxp,2);

% Get rid of the last 2 zeros for display

formatted_xp = arrayfun(@(x) num2str(x, '%.4g'), rmodel_xp, 'UniformOutput', false);
formatted_pxp = arrayfun(@(x) num2str(x, '%.4g'), rmodel_pxp, 'UniformOutput', false);


% Make a table xp & pxp

models = {'Model 1', 'Model 2', 'Model 3'};
T = table(models', formatted_xp' , formatted_pxp', ...
    'VariableNames', {'Models', 'Unprotected xp', 'Protected xp'});

% Make a figure xp & pxp

fig = uifigure('Name','Exceedance Probabilities')
uit = uitable(fig, 'Data', T, 'ColumnName', T.Properties.VariableNames, 'RowName', {});
uit.Position = [3 5 400 100];

