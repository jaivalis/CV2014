clear all
addpath('../a1/kdtree')

% params
EPTypes = {'EP', 'nEP', 'nEPRansac'};
EPType  = EPTypes(3);
sampleSize = 8;
% \params

pointView  = []; % images x points
pointsSeen = []; % points x 2 (xy)
for i = 1 : 16
    i1 = single(rgb2gray(imread(strcat('TeddyBear/obj02_00', num2str(i),'.png'))));
    if i < 16
        i2 = single(rgb2gray(imread(strcat('TeddyBear/obj02_00', num2str(i + 1),'.png'))));
    else
        i2 = single(rgb2gray(imread(strcat('TeddyBear/obj02_00', num2str(1),'.png'))));
    end
    [i_points1, d1] = vl_sift(i1);
    [i_points2, d2] = vl_sift(i2);

    %sample interest points for non background points
    [i_points1, d1] = getForegroundSift(i_points1, d1);
    [i_points2, d2] = getForegroundSift(i_points2, d2);

    % match the foreground points with eachother
    [matches, scores] = vl_ubcmatch(d1, d2) ; % extract and match the descriptors 

    %% Fundamental Matrix Estimation
    [F, sampl] = getF(i_points1, i_points2, matches, EPType, sampleSize);
    
    %% plot matches [TODO: can be removed/commented]
    concat = cat(2, i1, i2); concat = concat / 255;
    figure;  imshow(concat, 'InitialMagnification', 20);
    hold on
    % connecting line between original and transformed points
    originPoints(:, 1) = i_points1( 1, sampl(1, :) ); % x coordinate
    originPoints(:, 2) = i_points1( 2, sampl(1, :) ); % y coordinate

    %destinationPoints = i_points2;
    destinationPoints(:, 1) = i_points2( 1, sampl(2, :) ); % x coordinate
    destinationPoints(:, 2) = i_points2( 2, sampl(2, :) ); % y coordinate
    destinationPoints(:, 1) = destinationPoints(:, 1) + size(i1,2); % plus width

    plot(originPoints(1:end, 1), originPoints(1:end, 2), 'ro');
    plot(destinationPoints(1:end, 1), destinationPoints(1:end, 2), 'go');

    for j = 1:length(destinationPoints)
      plot([originPoints(j, 1) destinationPoints(j, 1)], ...
           [originPoints(j, 2) destinationPoints(j, 2)], 'b');
    end
    hold off
    
    %% Chaining
    % Start from any two consecutive image matches. Add a new column to
    % point-view matrix for each newly introduced point.
    % If a point which is already introduced in the point-view matrix and an-
    % other image contains that point, mark this matching on your point-view
    % matrix using the previously defined point column. Do not introduce a new
    % column.
    for k = 1:size(matches, 2)
        coord = [i_points2(1, matches(2,k)) i_points2(2, matches(2,k))];
        if isempty(pointsSeen)
            pointsSeen = [pointsSeen; coord];
            pointView  = cat(2, pointView, zeros(16, 1));
            pointView(1, 1) = 1;
            continue;
        end
        
        if ~sum(ismember(coord, pointsSeen, 'rows'))
            % add a new column for any newly introduced point
            pointsSeen = [pointsSeen; coord];
            pointView  = cat(2, pointView, zeros(16, 1));
            pointView(i, size(pointView,2)) = 1;
        else
            % mark the point of points that have already been seen
            % find point in pointsSeen
            size(pointsSeen)
            
            [c,r] = ismember(coord, pointsSeen, 'rows');
            % mark point in pointView
            pointView(i, r) = 1;
        end
    end
    imshow(pointView)
end