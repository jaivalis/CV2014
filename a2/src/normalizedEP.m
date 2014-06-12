function F = normalizedEP(points1, points2, matches)
%NORMALIZEDEP Summary of this function goes here

    % normalize
    [n_points1, T1] = normalizePoints(points1);
    [n_points2, T2] = normalizePoints(points2);
    
    % get F
    F = eightPoint(n_points1, n_points2, matches);
    
    % denormalize
    % 1.2.3 we're assuming that the F' is a typo
    F = T2' * F' * T1;
end

