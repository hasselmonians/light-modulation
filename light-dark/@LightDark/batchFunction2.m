function batchFunction(location, batchname, outfile, test)

    % Acquire binned spike counts for combined adjacent light-dark epochs

    if ~test
      addpath(genpath('/projectnb/hasselmogrp/ahoyland/RatCatcher'))
      addpath(genpath('/projectnb/hasselmogrp/ahoyland/srinivas.gs_mtools'))
      addpath(genpath('/projectnb/hasselmogrp/ahoyland/CMBHOME'))
      addpath(genpath('/projectnb/hasselmogrp/ahoyland/grid-cell-spiking'))
    end

    %% Load the raw data

    % acquire all filenames and filecodes
    [filenames, filecodes] = RatCatcher.read([], location, batchname);

    %% Perform the main loop

    parfor index = 1:length(filenames)

        if test
            this = load(strrep(filenames{index}, 'projectnb', 'mnt'));
        else
            this = load(filenames{index});
        end

        % extract individual variables
        root = this.root;
        lightON = this.lightON;
        lightOFF = this.lightOFF;
        this = [];

        % set up the correct cell number / tetrode number
        root.cel = filecodes(index, :);

        % acquire the epoch sets
        [epoch_sets] = getEpochs(lightON, lightOFF, ...
            'MinEpochDuration', 0, ...
            'MaxEpochDuration', Inf, ...
            'Trim', true, ...
            'Verbosity', true);

        % acquire the start, transition, and stop times
        [epoch_times] = stitchEpochs(epoch_sets);

        %% Acquire the overlaid epochs

        % produces a cell array of spike counts binned at 5 s
        [spike_counts, edges] = overlayEpochs(root, epoch_times(:, [1, 3]), ...
            'BinWidth', 5, ...
            'TimeShift', epoch_times(:, 2), ...
            'Verbosity', true);

        %% Pad spike counts

        % produces a matrix of binned spike counts, padded by NaNs
        [padded_spike_counts, timestamps] = padSpikeCounts(spike_counts, edges, 'both');

    end % parfor

    %% Write Output

    % TODO

end % function
