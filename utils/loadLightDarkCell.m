function root = loadLightDarkCell()

    % loads a light/dark cell from Holger's raw data
    % requires that the cluster is mounted to /mnt/hasselmogrp

    load('/projectnb/hasselmogrp/hdannenb_1/UnitRecordingData/ArchTChAT_18/190710_S1_LightVSdarkness_2min_30sec.mat');
    root.cel = [1, 1];

end
