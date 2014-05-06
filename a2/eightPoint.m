function F = eightPoint(i_points1, i_points2, matches)
    % Eight-point Algorithm
    % get A matrix
    A = getA(i_points1, i_points2, matches);
    
    % single Value Decomp. of A
    [~, ~, V]  = svd(A);
    [~, f_ind] = find(V == min(min(V)));
    f          = V(:, f_ind);
    
    F = [ f(1) f(4) f(7); f(2) f(5) f(8); f(3) f(6) f(9) ];
    % single Value Decomp. of F
    [U_f, D_f, V_f] = svd(F);
    
    % set smallest singular value in the diagonal matrix to 0 to obtain the
    % corrected matrix D_f'
    dD_f       = diag(D_f);
    [r, c]     = find(dD_f == min(min(dD_f)));
    dD_f(r, c) = 0;
    D_f        = diag(dD_f);
    F          = U_f * D_f * V_f';
end