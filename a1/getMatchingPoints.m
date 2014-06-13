function [ ret ] = getMatchingPoints( base, target )
%GETMATCHINGPOINTS returns the matching points given 2 pointclouds
%   Uses vl_kdtreebuild for that task
    kdtree = vl_kdtreebuild(target);

    ret = zeros(size(base));
    for j = 1:size(base, 2)
        p = base(:, j);
        [idxs, ~] = vl_kdtreequery(kdtree, target, p);
        ret(:,j)  = target(:, idxs);
    end
end

