box_data = [Inc_right, Inc_imag_post, Inc_left, Inc_imag_left, Inc_occipital_p];

colors = ['k';   % Color for group 1 
          'b']; % Color for group 2 
group = [1, 2, 1, 2, 1];

outlierColor = [0 0 0];

h = boxplot(box_data, 'Colors', colors(group, :), 'ColorGroup', group, 'Labels', {'Right S2', 'Occipital Imagery', 'Left S2',  'Left BA1/2 Imagery', 'Occipital Stimulus'})
ylabel('Accuracy Above Chance [%]')
title('Comparison of Decoding Accuracies in All Clusters')
set(findobj(h, 'Tag', 'Outliers'), 'MarkerEdgeColor', outlierColor);

% Add legend
hold on; % Hold on to add legend items

% Plot invisible lines for legend entries
h_a = plot(nan, nan, 'Color', colors(1, :), 'LineWidth', 1.5);
h_b = plot(nan, nan, 'Color', colors(2, :), 'LineWidth', 1.5);

% Create the legend
legend([h_a, h_b], {'Stimulus', 'Imagery'}, 'Location', 'northeast');

hold off; % Release hold