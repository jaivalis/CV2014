function [RMS, idxs] = calculateRMS(tree, idxs, base, target, neighbors)
    RMS = 0;
    for i = 1:size(target, 1)
        nn  = kdtree_k_nearest_neighbors(tree, target(i,:), neighbors);
        RMS = RMS + sqrt(base(nn,:) * target(i,:)');
        idxs(i,:) = nn';
    end
    RMS = RMS / size(target, 1);
    
end