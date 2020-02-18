function data_table = gather(r, filekey)

    %% Description:
    %   The standard RatCatcher gather algorithm doesn't work with LightDark2
    %   when the maximum epoch size is changing between experiments.
    %   This function will always work under those conditions.
    %
    %% Arguments:
    %   r: the RatCatcher object
    %       requires the r.localpath property to be set
    %       and for the output files to exist
    %   filekey: a search keyword for finding the output files
    %     by default, it is set by examining the batchname property of r
    %     this is usually correct
    %
    % Outputs:
    %   data_table: a table containing the timestamps and the binned spike times
    %       centered at the transition times
    %
    %% Examples:
    %   data_table = LightDark2.gather(r);
    %
    % See Also: RatCatcher.gather, LightDark2.batchFunction

    %% Preamble

    if ~exist('filekey', 'var')
        filekey = [];
    end

    returnToCWD = pwd;

    % move to where the output files are stored
    if ~isempty(r.localpath)
      cd(r.localpath)
    else
      corelib.verb(r.verbose, 'RatCatcher::gather', ['No local path set, not changing directories'])
    end

    %% Generate the filekey

    if isempty(filekey)
      % check the batchname property first
      if isempty(r.batchname)
        filekey = r.getBatchScriptName();
        for ii = 1:length(filekey)
          filekey{ii} = ['output-' filekey{ii} '*'];
        end
        corelib.verb(r.verbose, 'RatCatcher::gather', ['filekey determined automatically: ' filekey])
      else
        % if the batchname exists, that's the filekey
        filekey = r.batchname;
        if iscell(filekey)
          for ii = 1:length(filekey)
            filekey{ii} = ['output-' filekey{ii} '*'];
          end
        else
          filekey = ['output-' filekey '*'];
        end
        corelib.verb(r.verbose, 'RatCatcher::gather', ['filekey set by batchname property'])
      end
    else
      corelib.verb(r.verbose, 'RatCatcher::gather', ['filekey set by user: ' '''' filekey ''''])
    end

    % filekey is a cell, operate recursively over filekeys
    if iscell(filekey)

      if exist('dataTable0', 'var')
        dataTable = dataTable0;
        for ii = 1:length(filekey)
          fk = filekey{ii};
          dataTable = r.gather(fk, dataTable);
        end
        return

      else
        qq = 1;
        for ii = 1:length(filekey)
          fk = filekey{ii};
          if ii == qq
            dataTable = r.gather(fk);
            if isempty(dataTable)
              qq = qq + 1;
            end
          else
            dataTable = r.gather(fk, dataTable);
          end
        end
        return

      end
    end

    %% Gather output files

    % gather together all data files, then load data into a cell array
    % they can't be in a matrix because they might not be the same size
    files = dir(filekey);

    % exit early if no files can be found
    if numel(files) == 0
      data_table = table();
      corelib.verb(r.verbose, 'LightDark2::gather', ['no files found with filekey: ' '''' filekey ''''] )
      return
    end

    % acquire the outfiles
    outfiles = {files.name};
    % sort the outfiles in a sensible manner
    outfiles = r.natsortfiles(outfiles);

    % instantiate a data array
    data = cell(length(outfiles), 1);

    %% Collect the data from the outfiles

    if r.verbose
      for ii = 1:length(data)
        corelib.textbar(ii, length(data))
        data{ii} = readmatrix(outfiles{ii});
      end
    else
      for ii = 1:length(data)
        data{ii} = readmatrix(outfiles{ii});
      end
    end

    %% Package the data

    % output cell arrays
    timestamps = cell(length(data), 1);
    spike_counts = cell(length(data), 1);

    for ii = 1:length(data)
      timestamps{ii} = data{ii}(1, :);
      spike_counts{ii} = data{ii}(2:end, 1:end-1);
    end

    data_table = table(timestamps, spike_counts);

    %% Cleanup

    % return from whence you came
    cd(returnToCWD)

    % append to extant data table, if there is one
    if exist('dataTable0') && ~isempty(dataTable0)
      if ~isempty(dataTable)
        data_table = [dataTable0; dataTable];
      else

        data_table = dataTable0;
      end
    end

  end % function
