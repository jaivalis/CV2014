clear all
addpath('../a1/kdtree')

% params
EPTypes = {'EP', 'nEP', 'nEPRansac'};
EPType  = EPTypes(1);
sampleSize = 50;
plot       = true;
% \params

pointView  = []; % images x points
pointsSeen = []; % points x 2 (xy)
for i = 1 : 1%16
    i1 = single(rgb2gray(imread(strcat('TeddyBear/obj02_00', num2str(i),'.png'))));
    if i < 16
        i2 = single(rgb2gray(imread(strcat('TeddyBear/obj02_00', num2str(i + 1),'.png'))));
    else
        i2 = single(rgb2gray(imread(strcat('TeddyBear/obj02_00', num2str(1),'.png'))));
    end

    %sample interest points for non background points
    [i_points1, d1] = getForegroundSift(i1);
    [i_points2, d2] = getForegroundSift(i2);

    % match the foreground points with eachother
    [matches, scores] = vl_ubcmatch(d1, d2) ; % extract and match the descriptors 

    %% Fundamental Matrix Estimation
    F = getF(i_points1, i_points2, matches, sampleSize, EPType, plot, i1, i2);
    
    %% Chaining
    % Start from any two consecutive image matches. Add a new column to
    % point-view matrix for each newly introduced point.
    % If a point which is already introduced in the point-view matrix and an-
    % other image contains that point, mark this matching on your point-view
    % matrix using the previously defined point column. Do not introduce a new
    % column.
%     for k = 1:size(matches, 2)
%         if ~sum(ismember(pointsSeen', [i_points2(1, matches(2,k)) i_points2(2, matches(2,k))]', 'rows'))
%             % add a new column for any newly introduced point
%             pointsSeen = cat(2, pointsSeen, i_points2(1, matches(2,k)));
%             pointView  = cat(2, pointView, zeros(16, 1));
%         else 
%             % mark the point of points that have already been seen
%             % find point in pointsSeen
%             [c,r] = find(pointsSeen == [i_points2(1, matches(2,k)) i_points2(2, matches(2,k))]);
%             % mark point in pointView
%             pointView(c, i) = 1;
%         end
%     end
end