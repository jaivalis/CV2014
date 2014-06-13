function [ ret, idxs ] = getMatchingPoints( base, target )
%GETMATCHINGPOINTS returns the matching points given 2 pointclouds
%   Uses vl_kdtreebuild for that task
    kdtree = vl_kdtreebuild(target);
    idxs = [];
    ret = zeros(size(base));
    for j = 1:size(base, 2)
        p = base(:, j);
        [idxs(j, :), ~] = vl_kdtreequery(kdtree, target, p);
        ret(:,j)  = target(:, idxs(j,:));
    end
end

