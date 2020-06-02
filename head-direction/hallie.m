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
root.cel = filecodes(1, :);

% set the epochs where the light is on
root.epoch = lightON;

[headdirTuning, angleDeg] = root.DirectionalTuningFcn(root.cel, 'binsize', 6, 'Continuize', 1);
angleRad = pi / 180 * angleDeg;
% directional tuning
[headdirTuning, angleDeg] = root.DirectionalTuningFcn(cel, 'binsize', 6, 'Continuize', 1);

% mean resultant vector length
headDir.meanResultantVectorLength = circ_r(angleRad,headdirTuning);

% computing the mean angle
headDir.meanAngle = circ_mean(angleRad,headdirTuning);

% Rayleigh test
[headDir.pValueRayleighTest, headDir.zStatRayleighTest]=circ_rtest(angleRad,headdirTuning);
