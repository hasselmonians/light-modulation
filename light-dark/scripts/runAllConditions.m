% set up jobs on the cluster for all four conditions

for ii = 4:-1:1
    r(ii) = getSecondPassRatCatcher(ii);
    r(ii) = r(ii).batchify;
end
