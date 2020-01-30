function root = loadGridCell(n)

  % loads a grid cell from Holger's raw data
  % requires that the cluster is mounted to /mnt/hasselmgrp
  % the argument 'n' determines which file to load

  prefix = '/mnt/hasselmogrp/hdannenb_1/UnitRecordingData/Grid_cells_lightVSdarkness_merged_across_sessions/';

  raw_data = { ...
    [prefix, 'ArchTWT14_181127_to_181210/Merged_sessions.mat'], ...
    [prefix, 'ArchTChAT22_191030_to_191108/Cell1/merged_sessions_ArchTChAT#22_cell1.mat'], ...
    [prefix, 'ArchTChAT22_191030_to_191108/Cell2/merged_sessions_ArchTChAT22_cell2.mat'], ...
    [prefix, 'ArchTChAT22_191030_to_191108/Cell3/merged_session_ArchTChAT22_cell3.mat'], ...
    [prefix, 'ArchTChAT22_191030_to_191108/Cell4/merged_session_ArchTChAT22_cell4.mat'] ...
  };

  if ~exist('n', 'var')
    n = 1;
  end

  load(raw_data{n});

end % function
