function F = normalizedEightPoint(points1, points2, matches)
%NORMALIZEDEIGHTPOINT Summary of this function goes here
%   Detailed explanation goes here

    % normalize
    n_points1 = normalizePoints(points1);
    n_points2 = normalizePoints(points2);
    
    % get F
    F = eightPoint(n_points1, n_points2, matches);
end

