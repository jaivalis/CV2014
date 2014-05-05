run('C:\Users\T\Downloads\vlfeat-0.9.14-bin\vlfeat-0.9.14\toolbox\vl_setup.m');
i1 = single(rgb2gray(imread('TeddyBear/obj02_001.png')));
i2 = single(rgb2gray(imread('TeddyBear/obj02_002.png')));
[i_points1, d1] = vl_sift(i1);
[i_points2, d2] = vl_sift(i2);

% sample interest points for non background points
[i_points1, d1] = getForegroundSift(i_points1, d1);
[i_points2, d2] = getForegroundSift(i_points2, d2);

% match the foreground points with eachother
[matches, scores] = vl_ubcmatch(d1, d2) ; % extract and match the descriptors 

% sample 8 points from matches
rand8   = rand()
matches = matches()

n = size(matches, 2); % ::= 8

% get A matrix
A = getA(i_points1, i_points2, matches);



%% plot transformation
concat = cat(2, i1, i2); concat = concat / 255;
figure;  imshow(concat, 'InitialMagnification', 50);
hold on
% connecting line between original and transformed points
originPoints(:, 1) = i_points1( 1, matches(1, :) ); % x coordinate
originPoints(:, 2) = i_points1( 2, matches(1, :) ); % y coordinate

%destinationPoints = i_points2;
destinationPoints(:, 1) = i_points2( 1, matches(2, :) ); % x coordinate
destinationPoints(:, 2) = i_points2( 2, matches(2, :) ); % y coordinate
destinationPoints(:, 1) = destinationPoints(:, 1) + size(i1,2); % plus width

plot(originPoints(1:end, 1), originPoints(1:end, 2), 'ro');
plot(destinationPoints(1:end, 1), destinationPoints(1:end, 2), 'go');
% maybe without loop?
% only every 20th line, otherwise it's a mess
for i=1:25:length(destinationPoints),
  plot([originPoints(i, 1) destinationPoints(i, 1)], [originPoints(i, 2) destinationPoints(i, 2) ], 'b');
end
hold off