function [light2dark, dark2light, ttest_light2dark, ttest_dark2light] = getLightDarkStats(mean_firing_rate)

    %% Arguments
    %   mean_firing_rate: an n x 2 matrix of mean firing rates
    %       during the light and dark conditions
    %
    %% Outputs
    %   light2dark: mean firing rate difference going from light to dark conditions
    %   dark2light: mean firing rate difference going from dark to light conditions
    %   ttest_light2dark: paired t-test results from light to dark conditions
    %   ttest_dark2light: paired t-test results from dark to light conditions

    %% Compute the mean firing rate differences

    % light(t) to dark(t)
    light2dark = mean_firing_rate(:, 1) - mean_firing_rate(:, 2);

    % light(t+1) to dark(t)
    dark2light = mean_firing_rate(2:end, 1) - mean_firing_rate(1:end-1, 2);
    dark2light = [dark2light; NaN];

    %% Paired t-test

    % light to dark conditions
    ttest_light2dark = struct;
    [h, p, ci, stats] = ttest(mean_firing_rate(:, 1), mean_firing_rate(:, 2));
    ttest_light2dark.h      = h;
    ttest_light2dark.p      = p;
    ttest_light2dark.ci     = ci;
    ttest_light2dark.stats  = stats;

    % dark to light conditions
    ttest_dark2light = struct;
    [h, p, ci, stats] = ttest(mean_firing_rate(2:end, 1), mean_firing_rate(1:end-1, 2));
    ttest_dark2light.h      = h;
    ttest_dark2light.p      = p;
    ttest_dark2light.ci     = ci;
    ttest_dark2light.stats  = stats;
