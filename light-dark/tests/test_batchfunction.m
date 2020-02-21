%% test_batchfunction.m
% 1. Run this script from ~/code/light-modulation/light-dark/tests/
% 2. Have the SCC mounted at /mnt/hasselmogrp

location = '/mnt/hasselmogrp/ahoyland/light-modulation/light-dark/cluster/';
batchname = 'Holger-LightDark';
outfile = '../cluster/outfile-Holger-LightDark';
test = true;

%% Test the analysis

% LightDark.batchFunction(location, batchname, outfile, test);
[light_ons, light_offs] = test_function(location, batchname, outfile, test);

%% Gather the data

files = dir([outfile, '*']);
nFiles = length(files);

% output matrix
data = NaN(nFiles, 8);

for ii = 1:nFiles
    data(ii, :) = readmatrix(fullfile(files(ii).folder, files(ii).name));
end

% data_table = table(data);
% data_table.Properties.VariableNames = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
