function [zscored_spike_counts, zscored_timestamps] = averageOverEpochsCells(data_table, binSize)

    %% Description:
    %   Take the concatenated binned spike counts (concatenated over paired epochs)
    %   Average over epochs to get the binned spike count for each cell.
    %   Then average over cells to get the mean binned spike count for all cells.
    %
    %% Arguments:
    %   data_table: a data table with the spike_counts variable
    %   binSize: numerical scalar, width of the spike bins in seconds, default: 5 seconds
    %
    %% Outputs:
    %   zscored_spike_counts: z-zscored binned spike counts averaged over all epochs & cells
    %   zscored_timestamps: timestamps for the z-scored binned spike counts
    %
    %% Examples:
    %
    % See Also: padSpikeCounts, zscoreOverNaNs

    %% Preamble

    if ~exist('binSize', 'var')
        binSize = 5; % seconds
    end

    %% Collect the binned spike counts averaged over epochs for each cell

    mean_binned_spike_counts = cell(height(data_table), 1);

    for ii = 1:height(data_table)
        mean_binned_spike_counts{ii} = averageOverNaNs(data_table.spike_counts{ii});
    end

    %% Pad spike counts and compress into a matrix

    padded_mean_binned_spike_counts = padSpikeCounts(mean_binned_spike_counts, data_table.timestamps, 'both');

    %% Average over padded mean binned spike counts

    % z-score before averaging
    zscored_spike_counts = zscoreOverNaNs(padded_mean_binned_spike_counts);

    % create a timestamp vector
    nBins = size(zscored_spike_counts, 2);
    zscored_timestamps = binSize * (colon(0, nBins-1) - nBins/2);

end % function
