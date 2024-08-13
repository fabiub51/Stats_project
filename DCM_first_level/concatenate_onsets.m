% Script is used to concatenate the onsets for all conditions

cd D:\project_stats\shared_data\sub-002
load all_onsets_goodImag_sub002.mat

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

save conc_onsets.mat conc_onsets_fin