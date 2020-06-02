% for loop over filenames
%      for loop over filecodes
%           load root (CMBHOME) object
%           root.cel=filecode; %set cell
%           root.epoch=lightON; %set the epoch to light
%            compute mean resultant vector lenght (circular statistics toolbox)
%            compute p-value from Rayleigh test
%            root.epoch=lightOFF; %set epoch to dark
%            repeat steps for light
%            if mean resultant vector length in dark or light > some threshold AND p-value in dark or light < some threshold
%            classfiy cell as head direction cell
%            end
% end
% end

%% Load the filename and filecode data

load('/projectnb/hasselmogrp/ahoyland/data/holger/light-dark/data-Holger-LightDark.mat')

% get the filenames and filecodes
filenames = data_table.filenames;
filecodes = data_table.filecodes;

%% Load one of the CMBHOME files

% loads a CMBHOME.Session object named "root"
% loads a numerical matrix called "lightON"
load(filenames{1})

% set the cell number
root.cel = filecode(1, :);

% set the epochs where the light is on
root.epoch = lightON;
