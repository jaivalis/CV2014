function [ foreground_points, foreground_desc ] = getForegroundSift( img )
%GETSIFTSAMPLE Returns a subset of the interest points eliminating
%background points

%     forgFilter = 1 - im2bw(img / 255);
%     filtered   = img .* forgFilter;
%     [i_points, desc] = vl_sift(filtered);
    [i_points, desc] = vl_sift(img);

    centerOfMass = [ mean(i_points(1,:)); mean(i_points(2,:)) ];
    xy = i_points(1:2,:)';
    tree = kdtree_build( xy );
    IDX  = kdtree_k_nearest_neighbors(tree, centerOfMass', 2000);
    foreground_points = i_points(:, IDX);
    foreground_desc = desc(:,IDX);

end