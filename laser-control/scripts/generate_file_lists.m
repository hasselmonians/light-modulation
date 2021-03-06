%% generates filenames.txt and filecodes.csv
% from the laser control dataset

% load the filenames list from Holger
data = load('~/code/light-modulation/data/filenames_laserControl_sessions.mat');

% fix broken filepaths
data.filenames = [data.filenames;
    'ChATControl_3/170228_s2_ls_control.mat'; ...
    'ChATControl_3/170303_s1_ls_control.mat'; ...
    'ChATControl_5/170317_s1_ls_control.mat'];

% rename the files to get the absolute paths
prefix = '/mnt/hasselmogrp/hdannenb_1/UnitRecordingData';
unique_filenames = cell(length(data.filenames), 1);

for ii = 1:length(unique_filenames)
    relative_path = data.filenames{ii};
    unique_filenames{ii} = strrep(relative_path, '\', '/');
end

% wrangle the data
[filenames, filecodes, file_missing] = RatCatcher.wrangle(unique_filenames, ...
    'PrefixLoad', '/mnt/hasselmogrp/hdannenb_1/UnitRecordingData', ...
    'PrefixSave', '/projectnb/hasselmogrp/hdannenb_1/UnitRecordingData', ...
    'Verbosity', true, ...
    'SavePath', '~/code/light-modulation/data/laser-control');

% !cp ~/code/light-modulation/data/laser-control/* /mnt/hasselmogrp/ahoyland/data/holger/laser-control/
