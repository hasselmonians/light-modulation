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

    % collect unique filenames and a linear index vector map
    [unique_filenames, ~, filename_index] = unique(filenames);

    %% Perform the main loop over all unique filenames

    parfor ii = 1:length(unique_filenames)

        % find the linear indices into 'filenames' and 'filecodes'
        % for all filecodes associated with the unique filename
        these_indices = find(filename_index == ii);

        % load the correct data file
        if test
            this = load(strrep(unique_filenames{ii}), 'projectnb', 'mnt');
        else
            this = load(unique_filenames{ii});
        end

        % extract individual variables
        root = this.root;
        lightON = this.lightON;
        lightOFF = this.lightOFF;
        this = [];

        %% Sub-loop over all filecodes, given a unique filename

        % iterate over all filecodes and perform the analysis
        for qq = 1:length(these_indices)

            % set up the correct cell number / tetrode number
            root.cel = filecodes(these_indices(qq), :);

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

            %% Write Output

            this_outfile = [outfile, '-', num2str(these_indices(qq)) '.csv'];
            writematrix([timestamps; padded_spike_counts], this_outfile);

        end % qq

    end % parfor


end % function
