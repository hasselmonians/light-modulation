%% generates filenames.txt and filecodes.csv
% from the laser control dataset

% load the filenames list from Holger
data = load('~/code/light-modulation/data/filenames_laserControl_sessions.mat');

% rename the files to get the absolute paths
prefix = '/mnt/hasselmogrp/hdannenb_1/UnitRecordingData';
unique_filenames = cell(length(data.filenames), 1);

for ii = 1:length(unique_filenames)
    relative_path = data.filenames{ii};
    relative_path = strrep(relative_path, '\', '/');
    unique_filenames{ii} = fullfile(prefix, relative_path);
end

% wrangle the data
[filenames, filecodes, file_missing] = RatCatcher.wrangle(unique_filenames, ...
    'Verbosity', true, ...
    'SavePath', '~/code/light-modulation/data/laser-control');
