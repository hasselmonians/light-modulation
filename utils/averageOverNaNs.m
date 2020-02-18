function [vec_mean, vec_std] = averageOverNaNs(padded_spike_counts)

    %% Description:
    %   Finds the mean and standard deviation of binned spike counts
    %
    %% Arguments:
    %   padded_spike_counts: numerical matrix,
    %       the first index is over the number of epochs,
    %       the second index is over the number of time bins
    %       the spike counts have been binned and padded to form a matrix
    %
    %% Outputs:
    %   vec_mean: the vector mean along the first dimension
    %   vec_std: the vector standard deviation along the first dimension
    %
    %% Examples:
    %   [vec_mean, vec_std] = averageOverEpochs(padded_spike_counts);
    %
    % See Also: padSpikeCounts, overlayEpochs

    % find the mean and standard deviation of the binned spike counts
    vec_mean = mean(padded_spike_counts, 1, 'omitnan');
    vec_std = std(padded_spike_counts, 0, 1, 'omitnan');

end % function
