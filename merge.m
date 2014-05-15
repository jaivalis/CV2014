function pointCloud = merge(tree, baseCloud, targetCloud)
    for i = 1 : size(targetCloud, 1)
        [idxs, distances] = kdtree_ball_query(tree, targetCloud(i,:), 0.2);
        [ind,~] = min(distance);
    end
end

for i = 1 : size(target_coords, 1)
    [idxs, distances] = kdtree_ball_query(tree, target_coords(i,:), 0.15);
    [ind(i),~] = min(distance);
end