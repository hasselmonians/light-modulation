function [padded_spike_counts, timestamps] = padSpikeCounts(spike_counts, edges, direction)

    %% Description:
    %   Pad spike counts so that they can be compressed from a cell array
    %   into a matrix.
    %   Padding is done with NaNs.
    %
    %% Arguments:
    %   spike_counts: cell array of numerical vectors,
    %       binned spike counts for each combined epoch
    %   edges: cell array of numerical vectors
    %       bin edges of the spike counts
    %   direction: character vector
    %       which direction to pad towards ('pre', 'post', or 'both')
    %       default is 'both'
    %
    %% Outputs:
    %   padded_spike_counts: numerical matrix
    %       first dimension indexes the epochs
    %       second dimension indexes the spike counts
    %   timestamps: time bins for the spike counts, after padding
    %       length is determined by the longest epoch
    %
    %% Examples:
    %
    % See Also: getEpochs, stitchEpochs, overlayEpochs

    if ~exist('direction', 'var')
        direction = 'both';
    end

    % find the maximum number of bins (determines the size of the padded matrix)
    [nBins, bin_index] = max(cellfun('length', spike_counts));

    % extend spike counts and edges into matrices
    for ii = 1:length(spike_counts)
        nPads = (nBins - length(spike_counts{ii})) / 2;
        spike_counts{ii} = padarray(spike_counts{ii}, [0, nPads], NaN, direction);
    end

    % convert spike counts and bin edges into matrices
    padded_spike_counts = cell2mat(spike_counts);
    timestamps = edges{bin_index};

    % % find the mean and standard deviation of the spike counts
    % mean_spike_counts = mean(padded_spike_counts, 1, 'omitnan');
    % std_spike_counts = std(padded_spike_counts, 0, 1, 'omitnan');
