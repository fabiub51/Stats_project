% Created with Lorenz's Script, run over all participants

data_path = '/Users/almila/Desktop/stats project copy 4/data/';

for sub_no = 1:10
    sub_dir = sprintf('%ssub-%03d', base_dir, sub_no);
    cd (sub_dir)

    fileName = sprintf('all_onsets_goodImag_sub%03d.mat', sub_no);

% Check if the file exists 
    if exist(fileName, 'file')
        % Load the .mat file for the current subject
        load(fileName);

        % Print a message
        disp(['Loaded file for subject: ', num2str(sub_no), ' from ', fileName]);
        
    else
        % Print a warning message if the file does not exist
        warning(['File not found for subject: ', num2str(sub_no), ' (', fileName, ')']);
    end
    TR = 2;
sessions = 6;
conc_onsets = {};

conc_onsets(1,:) = onsets(1,:);
session_vols = [242 242 242 242 242];
for k = 2:sessions
    for j = 1:length(onsets)
        conc_onsets{k,j} = onsets{k,j}+sum(session_vols(1:k-1))*TR;
    end
end

conc_onsets_fin = cell(1,length(onsets));

for n = 1:length(onsets)
    columnData = conc_onsets(:, n);
    
    combinedArray = [];
    for row = 1:length(columnData)
        combinedArray = [combinedArray; columnData{row}(:)];
    end
    

    conc_onsets_fin{n} = combinedArray;
end

 saveFileName = sprintf('conc_onsets_sub%03d.mat', sub_no);

        % Save the data with the subject number in the file name
        save(saveFileName, 'conc_onsets_fin');


end
