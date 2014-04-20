addpath('\kdtree')
base   = readPcd('data\0000000000.pcd');
target = readPcd('data\0000000001.pcd');

% params
neighbors = 1;

% filter out z-values greater than 2
index_b = (base(:,3) < 2);
base = base(index_b,:);
index_t = (target(:,3) < 2);
target = target(index_t,:);

% base, target with ony x,y,z values
base_coords = base(:,1:3);
target_coords = target(:,1:3);

%% find closest points
tree = kdtree_build( base_coords );
% input_data: d x n-matrix containing n d-dimensional points,
idxs = zeros(size(target_coords, 1), neighbors);
for i = 1 : size(target_coords, 1)
    nn = kdtree_k_nearest_neighbors(tree, target_coords(i,:), neighbors);
    RMS = RMS + sqrt(base_coords(nn,:) * target_coords(i,:)');
    idxs(i,:) = nn';
end
RMS = RMS / size(target_coords, 1);

%% Phase 2: Finding the geometric centroid of accepted matches
size_base   = size(base_coords,1);
mu_base   = [sum(base_coords(:,1)) sum(base_coords(:,2)) sum(base_coords(:,3))] / size_base;

size_target = size(target_coords,1);
mu_target   = [sum(target_coords(:,1)) sum(target_coords(:,2)) sum(target_coords(:,3)) ] / size_target;


% Shift the center of mass of the base point cloud to the origin of the coordinate system.
basePrime   = [ base_coords(idxs,1) - mu_base(1) base_coords(idxs,2) - mu_base(2) base_coords(idxs,3) - mu_base(3) ];
while 1
    %% Phase 3: Applying Singular Value Decomposition
    
    % calculate A matrix
    
    % Shift the center of mass of the target point cloud to the origin of the coordinate system.
    targetPrime = [ target_coords(:,1) - mu_target(1) target_coords(:,2) - mu_target(2) target_coords(:,3) - mu_target(3) ];
    A = basePrime * targetPrime';
    
    % decompose A into U, Sigma and V
    [U, ~, V] = svd(A);
    
    % Initialize R & t
    T = zeros(1, 3);
    R = eye(3,3);
    
    prevRMS = RMS;

    %% Phase 4 finding out translation and rotation based on SVD result
    R = U * V';

    % calculate translation matrix T (1 x 3)
    B_c = mu_base;
    T_c = mu_target;
    T   = B_c - T_c * R;
    
    %% Phase 5: Calculate new average distances using the rotation and translation matrix
    target_coords = R * target_coords + T;
    
    % calculate new RMS
    RMS = -1;
    
    % Loop until RMS remains unchanged
    if prev_RMS == RMS
        break
    end
end