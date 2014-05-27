
mat_ = load('a2/output/house.mat');
D = mat_.coordinates;
% TODO: Deal with missing data

%% 1. Normalize the point coords (translate them to the mean)
for i = 1:size(D, 1)
    X    = D(i, 1:2:end);
    Y    = D(i, 2:2:end);
    mu_x = mean(X);
    mu_y = mean(Y);
    
    D(1:2:end) = D(1:2:end) - mu_x;
    D(2:2:end) = D(2:2:end) - mu_y;
end

%% 2. SVD of D matrix
[U, W, V] = svd(D);
U_3 = U(:, 1:3);
W_3 = W(1:3, 1:3);
V_3 = V(1:3, :);

M = U_3 * sqrt(W_3);
S = sqrt(W_3) * V_3;

% Eliminate affine ambiguity !