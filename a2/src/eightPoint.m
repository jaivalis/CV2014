function F = eightPoint(i_points1, i_points2, matches)
%EIGHTPOINT Eight-point Algorithm
    
    A = getA(i_points1, i_points2, matches);
    
    % single Value Decomp. of A
    [~, ~, V] = svd(A);%Find the SVD of A: A = UDV T
    % The entries of F are the components of the column of V corresponding 
    % to the smallest singular value. 
    [~, f_ind] = find(V == min(min(V)));
    
    F      = V(:, f_ind);
    F = reshape(F, 3, 3);%change F to matrix
   
    % single Value Decomp. of F
    [U_f, D_f, V_f] = svd(F); %Find the SVD of F: F = UfDfVf^T
    
    %Set the smallest singular value in the diagonal matrix Df to zero in
    %order to obtain the corrected matrix D'_f
    D_f = diag(D_f);
    D_f(D_f == find(min(D_f))) = 0;
    D_f = diag(D_f);
    
    %Recompute F: F = UfD'fVf^T
    F = U_f * D_f * V_f;
end