function [varargout] = overlayEpochs(root, epoch_times, varargin)

    %% Description:
    %   Stacks epochs and gathers binned spike counts from those epochs.
    %
    %% Arguments:
    %   root: a CMBHOME.Session object
    %   epoch_times: an n x 2 matrix
    %       where the first column contains the start times of the epochs,
    %       and the second column contains the end times of the epochs in seconds
    %   options: a struct of options, which the function accepts as a single
    %       struct argument, or as Name-Value pairs
    %       BinWidth: numerical scalar, how wide the bins should be in the PSTH (in seconds), default: 5 secs
    %       TimeShift: numerical vector, how much to time-shift the bin edges for plotting, default: [] secs
    %       Verbosity: logical scalar, whether to print textual output, default: false
    %
    %% Outputs:
    %   options: a struct of options
    %   spike_counts: cell array of numerical vectors,
    %       binned spike counts for each combined epoch
    %   edges: cell array of numerical vectors
    %       bin edges of the spike counts
    %
    %% Examples:
    %   options = overlayEpochs();
    %   [spike_counts, edges] = overlayEpochs(root, epoch_times);
    %   [spike_counts, edges] = overlayEpochs(root, epoch_times, options);
    %   [spike_counts, edges] = overlayEpochs(root, epoch_times, 'Name', value, ...);
    %
    % See Also: getEpochs, stitchEpochs, padSpikeCounts

    %% Preamble

    % instantiate options
    options = struct;
    options.BinWidth = 5; % seconds
    options.TimeShift = [];
    options.Verbosity = false;

    if ~nargin & nargout
        varargout{1} = options;
        options = orderfields(options);
        return
    end

    options = corelib.parseNameValueArguments(options, varargin{:});

    %% Acquire combined epochs

    % combine adjacent light and dark epochs
    root.epoch = epoch_times;

    %% Acquire peristimulus time histograms

    % container for peristimulus time histogram spike count data
    spike_counts    = cell(size(epoch_times, 1), 1);
    edges           = cell(size(epoch_times, 1), 1);

    % collect the peristimulus
    for ii = 1:length(spike_counts)
        [spike_counts{ii}, edges{ii}] = histcounts(root.cel_ts{ii}, ...
            'BinWidth', options.BinWidth, ...
            'Normalization', 'countdensity');
    end

    % time-shift edges if appropriate
    if ~isempty(options.TimeShift)
        if isscalar(options.TimeShift)
            for ii = 1:length(edges)
                edges{ii} = edges{ii} - options.TimeShift;
            end
        else
            for ii = 1:length(edges)
                edges{ii} = edges{ii} - options.TimeShift(ii);
            end
        end
    end

    %% Outputs

    varargout{1} = spike_counts;
    varargout{2} = edges;

end % function
