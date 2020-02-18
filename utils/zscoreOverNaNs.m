function z = zscoreOverNaNs(x)

    %% Description:
    %   z-scores each row in a matrix padded with NaNs
    %
    % Arguments:
    %   x: a matrix padded with NaNs
    %       each row should be a separate vector to be z-scored
    %
    %% Outputs:
    %   z: the z-scored matrix
    %       this respects NaNs, which remain NaN,
    %       but do not pollute the rest of the data
    %
    %% Examples:
    %   z = zscoreOverNaNs(x);
    %
    % See Also: averageOverNaNs

    for ii = 1:size(x, 1)
        z(ii, :) = (x(ii, :) - mean(x(ii, :), 'omitnan')) ./ std(x(ii, :), 'omitnan');
    end
