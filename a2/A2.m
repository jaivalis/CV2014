clear all
addpath('../a1/kdtree')
i1 = single(rgb2gray(imread('TeddyBear/obj02_001.png')));
%i1 = single(imread('House/frame00000001.png'));
i2 = single(rgb2gray(imread('TeddyBear/obj02_002.png')));
%i2 = single(imread('House/frame00000002.png'));
[i_points1, d1] = vl_sift(i1);
[i_points2, d2] = vl_sift(i2);
size(i_points1)

%sample interest points for non background points
[i_points1, d1] = getForegroundSift(i_points1, d1);
[i_points2, d2] = getForegroundSift(i_points2, d2);
size(i_points1)

% match the foreground points with eachother
[matches, scores] = vl_ubcmatch(d1, d2) ; % extract and match the descriptors 
size(matches)
% % sample 8 points from matches
% use the scores in order to get the 8 points instead of random sampling
% score = squared Euclidean distance between the matches => useless
matches = matches(:, randi(size(matches,2),1,8));

%% plot matches
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

for i=1:length(destinationPoints),
  plot([originPoints(i, 1) destinationPoints(i, 1)], [originPoints(i, 2) destinationPoints(i, 2) ], 'b');
end
hold off

%% Eight-point Algorithm
% get A matrix
A = getA(i_points1, i_points2, matches);
% single Value Decomp. of A
[U,D,V] = svd(A);
V = V';
% single 
[~,f_ind] = find(V == min(min(V)));
F = V(:, f_ind);
% single Value Decomp. of F
[U_f,D_f,V_f] = svd(F);
D_f(min(D_f)) = 0;