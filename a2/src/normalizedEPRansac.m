function [F, most_inliers] = normalizedEPRansac(P1, P2, matches)
%NORMALIZEDEPRANSAC See Section 1.3
    
    most_inliers = [];
    F = [];
    sampl = [];
    improvementSteps = 0;
    
    loopcount = 0;
    while loopcount < 1001
        loopcount = loopcount + 1;
        matchesSample = matches(:, randi(size(matches,2),1,8));
        P1_ = P1(1:2, matchesSample(1,:));
        P2_ = P2(1:2, matchesSample(2,:));
        F_candidate = eightPoint(P1_, P2_);
%         F_candidate = normalizedEP(P1, P2, matchesSample);
        
        P1_ = P1(1:2, matches(1,:));
        P2_ = P2(1:2, matches(2,:));
        % verify matchesSample are in matches and stuff like that
        
        P1_ = [P1_;  ones(1, size(matches, 2))];
        P2_ = [P2_;  ones(1, size(matches, 2))];

        d = sampsonDistance(P1_, P2_, F_candidate);
        inliers = find(abs(d) < .5);     % Indices of inlying points
        if size(inliers, 2) == 0
            continue
        end
        if size(inliers, 2) > size(most_inliers, 2)
            F                = F_candidate;
            most_inliers     = inliers;
            sampl            = matchesSample;
        end
    end
    disp (strcat('(Ransac:) Inliers:_', num2str(size(most_inliers, 2)), ...
        '_outliers:_', num2str(size(matches, 2) - size(most_inliers, 2))))
end