% timestamps3 is the correct way to do it

% constants
nBins = 84;
binWidth = 5;

% create various timestamp vectors
% which vary in their degree of shift
timestamps1 = binWidth * ((1:nBins) - nBins/2);
timestamps2 = binWidth * ((1:nBins) - (nBins - 1)/2);
timestamps3 = binWidth * ((1:nBins) - (nBins + 1)/2);

% create fake data
data = zeros(nBins, 1);
data(1:nBins/2) = 1 + 0.3*randn(nBins/2, 1);
data(nBins/2+1:nBins) = -1 + 0.3*randn(nBins/2, 1);

% visualize
figure;
hold on
plot(timestamps1, data);
plot(timestamps2, data);
plot(timestamps3, data);
figlib.pretty('PlotBuffer', 0.1);
