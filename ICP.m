% we are supposed to use FLANN instead of vl_kdtree!
% download at http://www.cs.ubc.ca/research/flann/
addpath('C:\Users\T\Downloads\flann-1.8.4-src\flann-1.8.4-src\src\matlab')
base = readPcd('data\data\0000000000.pcd');
target = readPcd('data\data\0000000001.pcd');
t = 0;
% filter out z-values greater than 2
index_b = (base(:,3) < 2);
base = base(index_b,:);
index_t = (target(:,3) < 2);
target = target(index_t,:);

% base, target with ony x,y,z values
base_coords = base(:,1:3);
target_coords = target(:,1:3);

%% find closest points
build_params.algorithm = 'kdtree';
build_params.trees = 8;
% input_data: d x n-matrix containing n d-dimensional points,
% doesn't work for me, need the nearest_neighbors.mex-file
index = flann_build_index(base_coords', build_params);
result = flann_search( index, target_coords, 1, struct('checks',128));

% for i = 1 : size(target_coords,1)
%     
%     [index(i), distance(i)] = vl_kdtreequery(kdtree, base_coords', target_coords(i,:)',...
%         'MaxComparisons', 5);
% end