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

function data_table = hallie(epochs, save_file_name, parallel)

    %% Arguments:
    %   epochs: a matrix of epoch start times and end times
    %   save_file_name: full path to where the data table should be saved
    %   if parallel == true, try running the loop in parallel

    if nargin < 3
        parallel = false;
    end

    %% Load the filename and filecode data

    load('/projectnb/hasselmogrp/ahoyland/data/holger/light-dark/data-Holger-LightDark.mat')

    % get the filenames and filecodes
    filenames = data_table.filenames;
    filecodes = data_table.filecodes;

    %% Instantiate outputs

    mean_resultant_vector_length    = zeros(length(filenames), 1);
    mean_angle                      = zeros(length(filenames), 1);
    p_value                         = zeros(length(filenames), 1);
    z_statistic                     = zeros(length(filenames), 1);

    %% Load one of the CMBHOME files

    % loads a CMBHOME.Session object named "root"
    % loads a numerical matrix called "lightON"
    if parallel
        parfor ii = 1:length(filenames)

            load(filenames{ii})

            % set the cell number
            root.cel = filecodes(ii, :);

            % set the epochs where the light is on
            root.epoch = epochs;

            % directional tuning
            [headdirTuning, angleDeg] = root.DirectionalTuningFcn(root.cel, 'binsize', 6, 'Continuize', 1);

            % convert from degrees to radians
            angleRad = pi / 180 * angleDeg;

            % mean resultant vector length
            mean_resultant_vector_length(ii) = circ_r(angleRad, headdirTuning);

            % computing the mean angle
            mean_angle(ii) = circ_mean(angleRad, headdirTuning);

            % Rayleigh test
            [p_value(ii), z_statistic(ii)] = circ_rtest(angleRad, headdirTuning);

        end
    else
        for ii = 1:length(filenames)

            load(filenames{ii})

            % set the cell number
            root.cel = filecodes(ii, :);

            % set the epochs where the light is on
            root.epoch = epochs;

            % directional tuning
            [headdirTuning, angleDeg] = root.DirectionalTuningFcn(root.cel, 'binsize', 6, 'Continuize', 1);

            % convert from degrees to radians
            angleRad = pi / 180 * angleDeg;

            % mean resultant vector length
            mean_resultant_vector_length(ii) = circ_r(angleRad, headdirTuning);

            % computing the mean angle
            mean_angle(ii) = circ_mean(angleRad, headdirTuning);

            % Rayleigh test
            [p_value(ii), z_statistic(ii)] = circ_rtest(angleRad, headdirTuning);

        end
    end

    %% Create a data structure to hold our results

    data_table = table(mean_resultant_vector_length, ...
                      mean_angle, ...
                      p_value, ...
                      z_statistic, ...
                      filenames, ...
                      filecodes);

    save(save_file_name, 'data_table');

end
