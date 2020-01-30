function [root, lightON, lightOFF] = loadLightDarkCell()

    % loads a light/dark cell from Holger's raw data
    % requires that the cluster is mounted to /mnt/hasselmogrp

    % root is a CMBHOME.Session object
    % lightON is a matrix of start and stop times in seconds
    %   for when the light is on for the mouse
    % lightOFF is a matrix of start and stop times in seconds
    %   for when the light is off for the mouse

    load('/mnt/hasselmogrp/hdannenb_1/UnitRecordingData/ArchTChAT_18/190710_S1_LightVSdarkness_2min_30sec.mat');
    root.cel = [1, 1];

end
