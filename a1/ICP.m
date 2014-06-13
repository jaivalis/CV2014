clear all;
addpath('kdtree')

% params
sampleTypes = {'uniformRandom', 'uniformRandomNormal', 'none'};


neighbors  = 1;
type       = sampleTypes{1};
sampleSize = 10000;
stepSize   = 1;
% \params
figure;
hold on;

base   = getPcd( 0, type, sampleSize );
for image = 1:stepSize:99
    disp(strcat('Image pair: [', num2str(image-1), ',', num2str(image), ']'))
    
    target = getPcd( image, type, sampleSize );

    %% find closest points
    tree = kdtree_build( base );
    % input_data: d x n-matrix containing n d-dimensional points,
    idxs = zeros(size(target, 1), neighbors);

    % calculate new RMS
    [RMS, idxs] = calculateRMS(tree, idxs, base, target, neighbors);

    %% Phase 2: Finding the geometric centroid of accepted matches
    size_base   = size(base,1);
    mu_base     = [mean(base(:,1)) mean(base(:,2)) mean(base(:,3))];

    % Shift the center of mass of the base point cloud to the origin of the coordinate system.
    basePrime   = [base(idxs,1) - mu_base(1) ...
                   base(idxs,2) - mu_base(2) ...
                   base(idxs,3) - mu_base(3) ];
    
    iteration   = 1;
    while 1
        prev_RMS = RMS;

        %% Phase 3: Applying Singular Value Decomposition
        disp(strcat('_Iteration: ',num2str(iteration)))
        % calculate A matrix

        % Shift the center of mass of the target point cloud to the origin of the coordinate system.
        size_target = size(target,1);
        mu_target   = [mean(target(:,1)) mean(target(:,2)) mean(target(:,3))];
        targetPrime = [target(:,1) - mu_target(1) ...
                       target(:,2) - mu_target(2) ...
                       target(:,3) - mu_target(3) ];

        A = basePrime' * targetPrime;

        % decompose A into U, Sigma and V
        [U, ~, V] = svd(A);

        % Initialize R & t
        T = zeros(1, 3);
        R = eye(3,3);

        %% Phase 4 finding out translation and rotation based on SVD result
        R = V * U;

        % calculate translation matrix T (1 x 3)
        B_c = mu_base;
        T_c = mu_target;
        T   = B_c - T_c * R;

        %% Phase 5: Calculate new average distances using the rotation and translation matrix
        temp = R * target';

        target = (R * target')';
        target = [target(:, 1) + T(1) ...
                  target(:, 2) + T(2) ...
                  target(:, 3) + T(3)];

        % calculate new RMS
        [RMS, idxs] = calculateRMS(tree, idxs, base, target, neighbors);  

        iteration = iteration + 1;

        disp(strcat('__RMS:', num2str(RMS), ' prevRMS:', num2str(prev_RMS),...
                    ' Difference:', num2str(abs(prev_RMS - RMS))));

        % Loop until RMS remains unchanged
        if abs(prev_RMS - RMS) < 0.0012 && RMS < 0.4
            break;
        end
    end
    
    % plot base and target point cloud
%     figure;
%     subplot(1,2,1);
%     scatter3(base_coords(1:100:end,1),base_coords(1:100:end,2),base_coords(1:100:end,3),'r')
%     subplot(1,2,2);
%     scatter3(target_coords(1:100:end,1),target_coords(1:100:end,2),target_coords(1:100:end,3),'b')
    
    hold on;
    points = floor(size(base, 1) * .75);
    sample = randsample(1:size(base, 1), points);
    ps     = base(sample, :);
    scatter3(ps(1:100:end,1), ps(1:100:end,2), ps(1:100:end,3), 'b')
%     hold on;
%     scatter3(target(1:100:end,1),target(1:100:end,2),target(1:100:end,3),'b')
%     hold off;
    
    % merge base and target
    base = merge(base, target, idxs);
    
    save('backup')
    
end
hold off