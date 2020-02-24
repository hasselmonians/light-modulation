function varargout = filterDataTable(data_table, varargin)

    %% Description:
    %   Filters the data table produced by the LightDark protocol
    %   to find cells that are modulated by the light/dark conditions.
    %
    %% Arguments:
    %   data_table: the n x 10 data table created by the LightDark protocol
    %   options: a struct of options, which the function accepts as a single
    %       struct argument; or as Name-Value pairs
    %       p: numerical scalar, the p-value threshold for significance, default: 0.05
    %       Modulation: character vector, if 'positive', finds only positively-modulated cells,
    %           cells which fire more in darkness/unstimulated conditions.
    %           if 'negative', finds only negatively-modulated cells,
    %           cells which fire more in light/stimulated conditions.
    %           if 'both', finds all modulated cells, default: 'negative'
    %       Mode: character vector, either 'l2d' (light to dark conditions),
    %           or 'd2l' (dark to light) or 'both', default: 'both'
    %       Verbosity: logical scalar, whether to print textual output, default: false
    %
    %% Outputs:
    %   filtered_data_table: the filtered data table
    %   I: logical index from data_table into filtered_data_table
    %
    %% Examples:
    %   options = filterDataTable();
    %   [filtered_data_table, I] = filterDataTable(data_table);
    %   [filtered_data_table, I] = filterDataTable(data_table, options);
    %   [filtered_data_table, I] = filterDataTable(data_table, 'Name', value, ...)
    %
    % See Also: RatCatcher.gather, RatCatcher.stitch, LightDark.batchFunction, getLightDarkStats

    %% Preamble

    options = struct;
    options.p = 0.05;
    options.Modulation = 'negative';
    options.Mode = 'both';
    options.Verbosity = false;

    if ~nargin & nargout
        varargout{1} = options;
        varargout = options;
        options = orderfields(options);
        return
    end

    options = corelib.parseNameValueArguments(options, varargin{:});

    % assert options.Modulation
    options.Modulation = lower(options.Modulation);
    assert(any(strcmp(options.Modulation, {'positive', 'negative', 'both'})), ...
        '''Modulation'' must be ''positive'', ''negative'', or ''both''');

    % assert options.Mode
    options.Mode = lower(options.Mode);
    assert(any(strcmp(options.Mode, {'l2d', 'd2l', 'both'})), ...
        '''Modulation'' must be ''l2d'', ''d2l'', or ''both''');

    %% Filter the data table

    switch options.Mode
    case {'l2d', 'd2l'}
        switch options.Modulation
        case 'negative' % negatively modulated by darkness
            keep_these = data_table.([options.Mode '_p']) < options.p & data_table.([options.Mode '_tstat']) > 0;
        case 'positive' % positively modulated by darkness
            keep_these = data_table.([options.Mode '_p']) < options.p & data_table.([options.Mode '_tstat']) < 0;
        case 'both'
            keep_these = data_table.p < options.p;
        end
    case 'both'
        switch options.Modulation
        case 'negative' % negatively modulated by darkness
            keep_these = (data_table.l2d_p < options.p & data_table.d2l_p < options.p) & (data_table.l2d_tstat > 0 & data_table.d2l_tstat > 0);
        case 'positive' % positively modulated by darkness
            keep_these = (data_table.l2d_p < options.p & data_table.d2l_p < options.p) & (data_table.l2d_tstat < 0 & data_table.d2l_tstat < 0);
        case 'both'
            keep_these = (data_table.l2d_p < options.p & data_table.d2l_p < options.p);
        end
    end


    %% Outputs

    varargout{1} = data_table(keep_these, :);
    varargout{2} = keep_these;

end % function
