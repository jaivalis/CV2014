function [RMS] = calculateRMS(base, target)
%CALCULATERMS returns the root mean squared error for two pointclouds
    RMS = sum(power((base - target), 2));

    RMS = sqrt(mean(RMS));
end