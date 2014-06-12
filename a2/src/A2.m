clear all
addpath('../a1/kdtree')

% params
EPTypes    = {'EP', 'nEP', 'nEPRansac'};
Datasets   = {'TeddyBear/obj02_%03d.png', 'House/frame%08d.png'};

dataset    = Datasets{2};
EPType     = EPTypes(3);
sampleSize = 8;
plotF      = false;
% \params

pointView   = []; % images x points
coordinates = []; % x,y-coordinate of points in pointView
offset = 0;
p      = 0;
lim    = 16;
if strcmp(dataset, 'House/frame%08d.png')
    lim = 49;
end
for i = 1 : lim
    i1 = readImage(dataset, i);
    if i == lim
        i2 = readImage(dataset, 1);
    else
        i2 = readImage(dataset, i+1);
    end

    %sample interest points for non background points
%     [i_points1, d1] = vl_sift(i1);%getForegroundSift(i1);
%     [i_points2, d2] = vl_sift(i2);%getForegroundSift(i2);
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
        % first iteration
        pointView   = zeros(2*lim, size(matches,2));
        coordinates = zeros(2*lim, size(matches,2));
        pointView(1:2, :) = matches;
        coordinates(1:2, :) = i_points1(1:2, matches(1,:));
    else
        for k = 1:size(matches, 2)
            Lmatch = matches(1, k);
            Rmatch = matches(2, k);
            index = i + 2 * p - 1;
            if ismember(Lmatch, pointView(index, :)', 'rows')
                % not newly introduced - mark point in pointView
                [~, r] = ismember(Lmatch, pointView(index, :)', 'rows');
                pointView(index + 1, r) = Lmatch;
                pointView(index + 2, r) = Rmatch;
                % save coordinates of point
                coordinates(index + 1, r) = i_points1(1, Lmatch);
                coordinates(index + 2, r) = i_points1(2, Lmatch);
            else
                % newly introduced point
                pointView = [ pointView zeros(2*lim,1) ];
                pointView(index + 1, size(pointView, 2)) = Lmatch;
                pointView(index + 2, size(pointView, 2)) = Rmatch;
                % save coordinates of point
                coordinates(index + 1, size(pointView, 2)) = i_points1(1, Lmatch);
                coordinates(index + 2, size(pointView, 2)) = i_points1(2, Lmatch);
            end
        end
    end
    p = p + .5;
end
% i saved all the indexes of the matches, so convert indexes to 1
pointView(pointView>1) = 1;
% i saved Lmatch and Rmatch, so delete every second line now
pointView(1:2:end, :)  = [];

%% Save the pointView to file
if strcmp(dataset, 'TeddyBear/obj02_%03d.png')
    save(strcat(pwd, '/a2/output/teddy.mat'), 'coordinates');
    save(strcat(pwd, '/a2/output/teddyPV.mat'), 'pointView');
elseif strcmp(dataset, 'House/frame%08d.png')
    save(strcat(pwd, '/a2/output/house.mat'), 'coordinates');
    save(strcat(pwd, '/a2/output/housePV.mat'), 'pointView');
else
    error('This should not have happened');
end

imshow(pointView)