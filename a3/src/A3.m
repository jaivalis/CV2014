clear all

% params
Datasets   = {'TeddyBear', 'House'};

dataset    = Datasets{2};
sampleSize = 8;
plotF      = false;
% \params
% 
% % if strcmp(dataset, 'TeddyBear') == 1
% %     mat_ = load('a2/output/teddy.mat');
% %     D = mat_.coordinates;
% %     mat_ = load('a2/output/teddyPV.mat');
% %     PV = mat_.pointView;
% % elseif strcmp(dataset, 'House') == 1
% %     mat_ = load('a2/output/house.mat');
% %     D = mat_.coordinates;
% %     mat_ = load('a2/output/housePV.mat');
% %     PV = mat_.pointView;
% % end
D = load('a2/output/measurement_matrix.txt');
%TODO: Deal with missing data
%PV = measurement_matrix;
% for i = 1 : size(PV, 2)
%     a(i) = sum(PV(:,i));
% end
% 
% index = 1;
% for k = 1 : size(a,2)
%     if (a(k)) == 49
%         coord(:,index) = D(:,k);
%         index = index + 1;
%     end
% end
% % 
% D = coord;
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
V = V';
U_3 = U(:, 1:3);
W_3 = W(1:3, 1:3);
V_3 = V(1:3, :);

M = U_3 * sqrt(W_3);
S = sqrt(W_3) * V_3;
scatter3(S(1, :), S(2, :), S(3, :));
%scatter3(M(:, 1)', M(:, 2)', M(:, 3)');
% Eliminate affine ambiguity !