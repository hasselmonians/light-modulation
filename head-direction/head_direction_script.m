addpath('/projectnb/hasselmogrp/ahoyland/srinivas.gs_mtools')
addpath('/projectnb/hasselmogrp/ahoyland/light-modulation')
LightModulation.init(true);

computeHeadDirectionStatistics(true, '/projectnb/hasselmogrp/hlazaro/MATLAB/head-direction-lightON.mat');
computeHeadDirectionStatistics(false, '/projectnb/hasselmogrp/hlazaro/MATLAB/head-direction-lightOFF.mat');
