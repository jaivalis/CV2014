clear all
addpath('../a1/kdtree')
pointView = zeros(0);
for i = 1 : 1%16
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
    % Sample 8 points from matches
    matches8 = matches(:, randi(size(matches,2),1,8));

    %% plot matches
    concat = cat(2, i1, i2); concat = concat / 255;
    figure;  imshow(concat, 'InitialMagnification', 50);
    hold on
    % connecting line between original and transformed points
    originPoints(:, 1) = i_points1( 1, matches8(1, :) ); % x coordinate
    originPoints(:, 2) = i_points1( 2, matches8(1, :) ); % y coordinate

    %destinationPoints = i_points2;
    destinationPoints(:, 1) = i_points2( 1, matches8(2, :) ); % x coordinate
    destinationPoints(:, 2) = i_points2( 2, matches8(2, :) ); % y coordinate
    destinationPoints(:, 1) = destinationPoints(:, 1) + size(i1,2); % plus width

    plot(originPoints(1:end, 1), originPoints(1:end, 2), 'ro');
    plot(destinationPoints(1:end, 1), destinationPoints(1:end, 2), 'go');

    for j = 1:length(destinationPoints)
      plot([originPoints(j, 1) destinationPoints(j, 1)],...
          [originPoints(j, 2) destinationPoints(j, 2) ], 'b');
    end
    hold off

    %% Fundamental Matrix Estimation
    %F = eightPoint(i_points1, i_points2, matches8);
    %F = normalizedEP(i_points1, i_points2, matches8);
    F = normalizedEPRansac(i_points1, i_points2, matches);

    %% Chaining

    pointView = cat(2,pointView, F);
end