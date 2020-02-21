function varargout = stitchEpochs(epoch_sets, varargin)

    %% Description:
    %   Splices a cell array of epochs into a single n x 3 matrix,
    %   where the first column contains the starts of the first epoch start times,
    %   the second column contains the transition times,
    %   and the third column contains the end of the second epoch stop times.
    %
    %% Arguments:
    %   epoch_sets: a 1x2 or 2x1 cell array of n x 2 matrices
    %       each matrix contains the start and stop times
    %       for each experimental condition (e.g. light and dark)
    %   options: a struct of options,
    %       or as Name-Value pairs:
    %       FlipOrder: logical scalar, whether to flip the order of the epoch sets,
    %           results in an (n-2) x 3 matrix instead, default: false
    %       Verbosity: logical scalar, print textual output, default: false
    %
    %% Outputs:
    %   options: a struct of options
    %   stitched_epochs: an n x 3 matrix
    %       where the first column contains the starts of the light times,
    %       the second column contains the transition times,
    %       and the third column contains the end of the dark times
    %       (in seconds)
    %
    %% Examples:
    %
    %   options = stitchEpochs()
    %   stitched_epochs = stitchEpochs(epoch_sets)
    %   stitched_epochs = stitchEpochs(epoch_sets, options)
    %   stitched_epochs = stitchEpochs(epoch_sets, 'Name', value, ...)
    %
    % See Also: getEpochs, getLightDarkStats

    %% Preamble

    % instantiate options
    options = struct;
    options.FlipOrder = false;
    options.Verbosity = false;

    if ~nargin & nargout
        varargout{1} = options;
        options = orderfields(options);
        return
    end

    options = corelib.parseNameValueArguments(options, varargin{:});

    assert(all(size(epoch_sets{1}), size(epoch_sets{2})), 'epoch sizes must be the same')

    %% Main

    switch options.FlipOrder
    case false
        corelib.verb(options.Verbosity, 'grid-cell-spiking/stitchEpochs', 'stitching epochs...')
        stitched_epochs = NaN(size(epoch_sets{1}, 1), 3);
        stitched_epochs(:, 1:2) = epoch_sets{1}(:, 1:2);
        stitched_epochs(:, 3) = epoch_sets{2}(:, 2);
    case true
        corelib.verb(options.Verbosity, 'grid-cell-spiking/stitchEpochs', 'flipping epochs...')
        corelib.verb(options.Verbosity, 'grid-cell-spiking/stitchEpochs', 'stitching epochs...')
        stitched_epochs = NaN(size(epoch_sets{1}, 1), 3);
        stitched_epochs(:, 1:2) = epoch_sets{2}(:, 1:2);
        stitched_epochs(:, 3) = [epoch_sets{1}(2:end, 1); NaN];
        varargout{1} = stitched_epochs(1:end-1, :);
    case false
        varargout{1} = stitched_epochs;
    end

end % function
