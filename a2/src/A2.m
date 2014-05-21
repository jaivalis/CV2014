clear all
addpath('../a1/kdtree')

% params
EPTypes    = {'EP', 'nEP', 'nEPRansac'};
Datasets   = {'TeddyBear/obj02_%03d.png', 'House/frame%10d.png'};

dataset    = Datasets{1};
EPType     = EPTypes(3);
sampleSize = 8;
plotF      = false;
% \params

pointView  = []; % images x points
pointsSeen = []; % points x 2 (xy)
offset = 0;
for i = 1 : 16
    i1 = single(rgb2gray(imread(sprintf(dataset, i))));
    if i == 16
        i2 = single(rgb2gray(imread(sprintf(dataset, 1))));
    else
        i2 = single(rgb2gray(imread(sprintf(dataset, i+1))));
    end

    %sample interest points for non background points
    [i_points1, d1] = getForegroundSift(i1);
    [i_points2, d2] = getForegroundSift(i2);

    % match the foreground points with eachother
    [matches, scores] = vl_ubcmatch(d1, d2) ; % extract and match the descriptors 

    %% Fundamental Matrix Estimation
    [F, sampl] = getF(i_points1, i_points2, matches, EPType, sampleSize);
    
    %% Plot matches
    if plotF
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

        plot(originPoints(:, 1), originPoints(:, 2), 'ro');
        plot(destinationPoints(:, 1), destinationPoints(:, 2), 'go');

        for j = 1:length(destinationPoints)
          plot([originPoints(j, 1) destinationPoints(j, 1)], ...
               [originPoints(j, 2) destinationPoints(j, 2)], 'b');
        end
        hold off
    end
    %% Chaining
    % Start from any two consecutive image matches. Add a new column to
    % point-view matrix for each newly introduced point.
    % If a point which is already introduced in the point-view matrix and an-
    % other image contains that point, mark this matching on your point-view
    % matrix using the previously defined point column. Do not introduce a new
    % column.
    if isempty(pointView)
        pointView = zeros(16, size(matches, 2));
        previousRight = matches(1, :);
    else
        for k = 1:size(matches, 2)
            Lmatch = matches(1, k);

            if ismember(Lmatch, previousRight)
                % not newly introduced - mark point in pointView
                index = find(previousRight == Lmatch);
                pointView(i-1, index + offset) = 1;
            else
                % newly introduced point
                pointView = [ pointView zeros(16,1) ];
            end
        end
        previousRight = matches(2, :);
        offset = offset + size(matches, 2);
    end
end