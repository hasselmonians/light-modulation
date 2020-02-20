%% Load the first-pass datasets for the two conditions

data_lightdark = load('~/code/grid-cell-spiking/data/data-Holger-LightDark.mat');
data_darklight = load('~/code/grid-cell-spiking/data/data-Holger-DarkLight.mat');

%% Are the two data sets actually different?

% Yes, they are different.
differences = setdiff(data_lightdark.data_table, data_darklight.data_table);
isempty(differences)

% But not by much
height(differences) / height(data_lightdark.data_table) * 100

%% Load the second-pass datasets for the two conditions

data_lightdark2 = load('~/code/grid-cell-spiking/data/data-Holger-LightDark2-1.mat');
data_darklight2 = load('~/code/grid-cell-spiking/data/data-Holger-DarkLight2-1.mat');

%% Are the two data sets actually different?

iseq = false(height(data_lightdark2.data_table), 1);

for ii = 1:height(data_lightdark2.data_table)
    iseq(ii) = all(isequaln(data_lightdark2.data_table.spike_counts{ii}(:), data_darklight2.data_table.spike_counts{ii}(:)));
end

% No they aren't different at all...
