function [ foreground_points, foreground_desc ] = getForegroundSift( i_points, desc )
%GETSIFTSAMPLE Returns a subset of the interest points eliminating
%background points
    centerOfMass = [ mean(i_points(1,:)); mean(i_points(2,:)) ];
    temp = i_points(1:2,:)';
    tree = kdtree_build( temp );
    IDX = kdtree_k_nearest_neighbors(tree, centerOfMass', 2000);
    foreground_points = i_points(:, IDX);
    foreground_desc = desc(:,IDX);
end