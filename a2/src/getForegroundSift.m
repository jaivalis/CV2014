function [ foreground_points, foreground_desc ] = getForegroundSift( img )
%GETSIFTSAMPLE Returns a subset of the interest points eliminating
%background points

%     [i_points, desc] = vl_sift(img, 'edgethresh', 30, 'levels', 30);
    [i_points, desc] = vl_sift(img);
    
    centerOfMass = [ mean(i_points(1,:)); mean(i_points(2,:)) ];
    temp = i_points(1:2,:)';
    tree = kdtree_build( temp );
    IDX  = kdtree_k_nearest_neighbors(tree, centerOfMass', floor(2*size(i_points,2)/3));
    foreground_points = i_points(:, IDX);
    foreground_desc = desc(:,IDX);
    
end