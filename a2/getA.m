function A = getA(points1, points2, matches)
%GETA returns an n x 9 matrix A
    A = ones(8, 9);
    
    % this is wrong needs matches of points1/2
    X1      = points1(1, :);
    Y1      = points1(2, :);
    X1prime = points2(1, :);
    Y1prime = points2(2, :);
    
    A(:, 1) = X1 .* X1prime;
    A(:, 2) = X1 .* Y1prime;
    A(:, 3) = X1;
    A(:, 1) = Y1 .* X1prime;
    A(:, 2) = Y1;
    A(:, 3) = X1prime;
    A(:, 3) = Y1prime;
end