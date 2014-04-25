function [rms] = calculateRMS(tree, idxs, base_coords, target_coords, neighbors)
    RMS = 0;
    addpath('.\kdtree')
    for i = 1 : size(target_coords, 1)
        nn = kdtree_k_nearest_neighbors(tree, target_coords(i,:), neighbors);
        RMS = RMS + sqrt(base_coords(nn,:) * target_coords(i,:)');
        idxs(i,:) = nn';
    end
    RMS = RMS / size(target_coords, 1);
    rms = RMS;