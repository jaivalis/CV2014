function A = getA(points1, points2, matches)
%GETA returns an n x 9 matrix A
    A = ones(size(matches, 2), 9);
    
    X1      = points1(1, matches(1, :));
    Y1      = points1(2, matches(2, :));
    X1prime = points2(1, matches(1, :));
    Y1prime = points2(2, matches(2, :));
    
    A(:, 1) = X1 .* X1prime;
    A(:, 2) = X1 .* Y1prime;
    A(:, 3) = X1;
    A(:, 4) = Y1 .* X1prime;
    A(:, 5) = Y1 .* Y1prime;
    A(:, 6) = Y1;
    A(:, 7) = X1prime;
    A(:, 8) = Y1prime;
    A(:, 9) = 1;
end