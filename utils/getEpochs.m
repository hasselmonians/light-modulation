function varargout = getEpochs(epoch_sets_1, epoch_sets_2, varargin)

    %% Description:
    %   Generates a 1x2 cell array of epochs from two n x 2 matrices
    %   containing start and stop times
    %
    %% Arguments:
    %   epochs: should be n x 2 matrices of start and stop times in seconds
    %       each describing a different condition
    %       we're assuming that there are only two conditions
    %       which alternate
    %
    %% Outputs:
    %   options: a struct of options, which the function accepts as a single
    %       struct argument, or as Name-Value pairs
    %       MinEpochDuration: numerical scalar, minimum duration of an epoch to be accepted, default: 0
    %       MaxEpochDuration: numerical scalar, maximum duration of an epoch to be accepted, default: Inf
    %       Trim: logical scalar, whether to trim uneven epochs to the smaller size, default: false
    %       Verbosity: logical scalar, whether to print textual output, default: false
    %   epoch_sets: a 1x2 cell array containing the filtered epoch times (start and stop)
    %       you can collapse them into a matrix with [epoch_sets{:}]
    %       this should always be true: epoch_sets{1}(:, 2) <= epoch_sets{2}(:, 1)
    %
    %% Examples:
    %   options = getEpochs();
    %   epoch_sets = getEpochs(epoch_sets_1, epoch_sets_2, options);
    %   epoch_sets = getEpochs(epoch_sets_1, epoch_sets_2);
    %   epoch_sets = getEpochs(epoch_sets_1, epoch_sets_2, 'Name', value, ...);
    %
    % See Also: spliceEpochs, getLightDarkStats

    %% Preamble

    % instantiate options
    options = struct;
    options.MinEpochDuration = 0; % s
    options.MaxEpochDuration = Inf; % s
    options.Trim = false;
    options.Verbosity = false;

    if ~nargin & nargout
        varargout{1} = options;
        options = orderfields(options);
        return
    end

    options = corelib.parseNameValueArguments(options, varargin{:});

    %% Pre-processing

    assert(size(epoch_sets_1, 2) == 2, 'epoch set 1 must be an n x 2 matrix')
    assert(size(epoch_sets_2, 2) == 2, 'epoch set 2 must be an n x 2 matrix')

    if options.Trim
        % trim epochs so that they are the same dimension
        minDim = min(size(epoch_sets_1, 1), size(epoch_sets_2));
        epoch_sets_1 = epoch_sets_1(1:minDim, :);
        epoch_sets_2 = epoch_sets_2(1:minDim, :);
        corelib.verb(options.Verbosity, 'grid-cell-spiking/getEpochs', 'epochs trimmed')
    else
        corelib.verb(options.Verbosity && all(size(epoch_sets_1) == size(epoch_sets_2)), ...
        'grid-cell-spiking/getEpochs', ...
        'epoch sets are differently-sized')
    end

    %% Determine which epoch set came first

    if all(epoch_sets_2(:,1) >= epoch_sets_1(:, 2))
        % the epochs in epoch_set_1 come first
        corelib.verb(options.Verbosity, 'grid-cell-spiking/getEpochs', 'epochs sets #1 comes first')
        epoch_sets = {epoch_sets_1, epoch_sets_2};
    elseif all(epoch_sets_2(:, 1) <= epoch_sets_1(:, 2))
        corelib.verb(options.Verbosity, 'grid-cell-spiking/getEpochs', 'epochs sets #2 comes first')
        epoch_sets = {epoch_sets_2, epoch_sets_1};
    else
        error('something isn''t right with the epoch sets; are you sure they make sense causally?')
    end

    %% Exclude epochs that don't match filter criteria

    % time lapses between epochs in the first condition
    time_lapses = diff(epoch_sets{1}');

    % go through filter criteria
    keep_these = time_lapses >= options.MinEpochDuration;
    keep_these = keep_these & time_lapses <= options.MaxEpochDuration;

    epoch_sets{1} = epoch_sets{1}(keep_these, :);
    epoch_sets{2} = epoch_sets{2}(keep_these, :);

    %% Outputs

    varargout{1} = epoch_sets;
    varargout{2} = keep_these;
