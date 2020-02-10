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



end % function
