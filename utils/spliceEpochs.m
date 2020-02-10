function varargout = spliceEpochs(epoch_sets, varargin)

    %% Description:
    %   Splices a cell array of epochs into a single n x 3 matrix,
    %   where the first column contains the starts of the light times,
    %   the second column contains the transition times,
    %   and the third column contains the end of the dark times (in seconds).
    %
    %% Arguments:
    %   epoch_sets: a 1x2 or 2x1 cell array of n x 2 matrices
    %       each matrix contains the start and stop times
    %       for each experimental condition (e.g. light and dark)
    %   options: a struct of options, or
    %   Name-Value argument pairs
    %
    %% Outputs:
    %   options: a struct of options, which the function accepts as a single
    %       struct argument, or as Name-Value pairs
    %       Verbosity: logical scalar, print textual output, default: false
    %   spliced_epochs: an n x 3 matrix
    %       where the first column contains the starts of the light times,
    %       the second column contains the transition times,
    %       and the third column contains the end of the dark times
    %       (in seconds)
    %
    %% Examples:
    %
    %   options = spliceEpochs()
    %   spliced_epochs = spliceEpochs(epoch_sets)
    %   spliced_epochs = spliceEpochs(epoch_sets, options)
    %   spliced_epochs = spliceEpochs(epoch_sets, 'Name', value, ...)
    %
    % See Also: getEpochs, getLightDarkStats

    %% Preamble

    % instantiate options
    options = struct;
    options.Verbosity = false;

    if ~nargin & nargout
        varargout{1} = options;
        options = orderfields(options);
        return
    end

    options = corelib.parseNameValueArguments(options, varargin{:});

    assert(all(size(epoch_sets{1}), size(epoch_sets{2})), 'epoch sizes must be the same')

    %% Main

    spliced_epochs = NaN(size(epoch_sets{1}, 1), 3);
    spliced_epochs(:, 1:2) = epoch_sets{1}(:, 1:2);
    spliced_epochs(:, 3) = epoch_sets{2}(:, 2);

    %% Outputs

    varargout{1} = spliced_epochs;

end % function
