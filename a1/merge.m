function base = merge(base_coords, target_coords)
    size(base_coords, 1) + size(target_coords, 1)
    tree = kdtree_build( base_coords );
    toDelete = [];
    ind = 1;
    for i = 1 : size(target_coords, 1)
        [~, distance] = kdtree_ball_query(tree, target_coords(i,:), 0.2);
        if min(distance) < 0.01
            % delete point; decrease
            %target_coords(i, :) = [];
            %targetSize = targetSize - 1
            % add point to toDelete
            toDelete(ind) = i;
            ind = ind + 1;
        end
    end
    target_coords(toDelete, :) = [];
    base = cat(1, base_coords, target_coords);
    size(base)
end