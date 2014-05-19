function F = getF( p1, p2, matches, sampleSize, type, plotflag, i1, i2 )
%GETF Returns the Fundamental matrix based on the type of method requested

    m_sample = matches(:, randi(size(matches, 2), 1, sampleSize)); % not used in nepransac
    
    if strcmp(type, 'EP')
        F = eightPoint(p1, p2, m_sample);
    elseif strcmp(type, 'nEP')
        F = normalizedEP(p1, p2, m_sample);
    elseif strcmp(type, 'nEPRansac')
        [F, m_sample] = normalizedEPRansac(p1, p2, matches);
    end

     % verification of F
    test1 = cat(2, p1(1:2,:)', ones(size(p1, 2),1));
    test2 = cat(2, p2(1:2,:)', ones(size(p2, 2),1));
    avgError = 0;
    for match = 1:size(m_sample, 2)
        verif = test2(m_sample(2,match),:) * F * test1(m_sample(1,match),:)';
        avgError = avgError + abs(verif);
    end
    disp(strcat('Average error: ', num2str(avgError / size(m_sample, 2))));
    
    if plotflag
        concat = cat(2, i1, i2); concat = concat / 255;
        figure;  imshow(concat, 'InitialMagnification', 25);
        hold on
        % connecting line between original and transformed points
        originPoints(:, 1) = p1( 1, m_sample(1, :) ); % x coordinate
        originPoints(:, 2) = p2( 2, m_sample(1, :) ); % y coordinate

        %destinationPoints = i_points2;
        destinationPoints(:, 1) = p2( 1, m_sample(2, :) ); % x coordinate
        destinationPoints(:, 2) = p2( 2, m_sample(2, :) ); % y coordinate
        destinationPoints(:, 1) = destinationPoints(:, 1) + size(i1,2); % plus width

        plot(originPoints(:, 1), originPoints(:, 2), 'ro');
        plot(destinationPoints(1:end, 1), destinationPoints(1:end, 2), 'go');

        for j = 1:length(destinationPoints)
          plot([originPoints(j, 1) destinationPoints(j, 1)], ...
               [originPoints(j, 2) destinationPoints(j, 2)], 'b');
        end
        hold off 
    end
end

