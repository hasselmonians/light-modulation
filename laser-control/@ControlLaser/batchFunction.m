function batchFunction(location, batchname, outfile, test)

    % Test for significance of mean firing rate changes
    % between laser stimulated and unstimulated epochs.

    if ~test
      addpath(genpath('/projectnb/hasselmogrp/ahoyland/RatCatcher'))
      addpath(genpath('/projectnb/hasselmogrp/ahoyland/srinivas.gs_mtools'))
      addpath(genpath('/projectnb/hasselmogrp/ahoyland/CMBHOME'))
      addpath(genpath('/projectnb/hasselmogrp/ahoyland/light-modulation'))
    end

    %% Load the raw data

    % acquire all filenames and filecodes
    [filenames, filecodes] = RatCatcher.read([], location, batchname);

    %% Perform the main loop

    parfor index = 1:length(filenames)

        % for each cell, load the data
        % expect a 1x1 CMBHOME.Session object named "root"
        % and two structs named "Inh" and "Non"

        if test
            this = load(strrep(filenames{index}, 'projectnb', 'mnt'));
        else
            this = load(filenames{index});
        end

        % extract individual variables
        root = this.root;
        lightON = this.Inh.S1;
        lightOFF = this.Non.S1;
        this = [];

        % set up the correct cell number / tetrode number
        root.cel = filecodes(index, :);

        % acquire the epoch sets
        [epoch_sets, keep_these] = getEpochs(lightON, lightOFF, ...
            'MinEpochDuration', 0, ...
            'MaxEpochDuration', 1e9, ...
            'Trim', true, ...
            'Verbosity', false);

        %% Compare adjacent epochs
        % in stimulated/unstimulated conditions

        % mean firing rate (computed via averaging over the entire epoch)
        mean_firing_rate = NaN(length(epoch_sets{1}), 2); % Hz

        for ii = 1:2 % over both experimental conditions
            % gather all of the spike times for each of the epochs of that condition
            root.epoch = epoch_sets{ii};
            % iterate through the epochs and compute the mean firing rate
            % by number of spikes per unit time
            for qq = 1:size(root.epoch, 1)
                mean_firing_rate(qq, ii) = length(root.cel_ts{qq}) / diff(epoch_sets{ii}(qq, :));
            end
        end

        % get the mean firing rate differences and perform pairwise t-tests
        % l2d means the nth stim epoch compared to the nth unstim epoch (stim minus unstim)
        % d2l means the (n+1)th stim epoch compared to the nth unstim epoch (stim minus unstim)
        [l2d, d2l, ttest_l2d, ttest_d2l] = getLightDarkStats(mean_firing_rate);

        %% Write output

        output = NaN(1, 8);
        this_struct_vec = [ttest_l2d, ttest_d2l];

        % hypothesis test result (1 => significance)
        output(1:2) = [this_struct_vec.h];
        % p-value
        output(3:4) = [this_struct_vec.p];
        % t-statistic (+ve => mean firing rate in the light is greater than in the dark)
        output(5:6) = [this_struct_vec(1).stats.tstat, this_struct_vec(2).stats.tstat];
        % degrees of freedom
        output(7:8) = [this_struct_vec(1).stats.df, this_struct_vec(2).stats.df];

        % write output to file
        writematrix(output, [outfile, '-', num2str(index), '.csv'])

    end % parfor

end % function
