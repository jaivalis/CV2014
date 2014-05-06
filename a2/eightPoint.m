function F = eightPoint(i_points1, i_points2, matches)
    % Eight-point Algorithm
    % get A matrix
    A = getA(i_points1, i_points2, matches);
    % single Value Decomp. of A
    [U, D, V] = svd(A);
    % single 
    [~,f_ind] = find(V == min(min(V)));
    F = V(:, f_ind);
    % single Value Decomp. of F
    [U_f, D_f, V_f] = svd(F);
    [D_f_ind_r, D_f_ind_c] = find(D_f == min(min(D_f)));
    D_f(D_f_ind_r, D_f_ind_c) = 0;
    F = U_f * D_f * V_f';
end