run('C:\Users\T\Downloads\vlfeat-0.9.14-bin\vlfeat-0.9.14\toolbox\vl_setup');
base = readPcd('data\data\0000000000.pcd');
target = readPcd('data\data\0000000001.pcd');
t = 0;
% filter out z-values greater than 2
index = (base(:,3) < 2);
base = base(index,:);
clear index;
index = (target(:,3) < 2);
target = target(index,:);
%R = eye(size(base,1));

% base, target with ony x,y,z values
base_coords = base(:,1:3);
target_coords = target(:,1:3);

%% find closest points
kdtree = vl_kdtreebuild(base_coords');
for i = 1 : size(target_coords,1)
    [index(i), distance(i)] = vl_kdtreequery(kdtree, base_coords', target_coords(i,:)',...
        'MaxComparisons', 5);
end
%closest_points = 


%plot3(a(:,1),a(:,2),a(:,3))
%plot(a(:,1),a(:,2))
%scatter(a(:,1),a(:,2))