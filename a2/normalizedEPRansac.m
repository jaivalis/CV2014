function F = normalizedEPRansac(P1, P2, matches)
%NORMALIZEDEPRANSAC See Section 1.3
    
    most_inliers = 0;
    improvementSteps = 0;
    
    while improvementSteps < 10
        matchesSample = matches(:, randi(size(matches,2),1,8));
        
        F_candidate = normalizedEP(P1, P2, matchesSample);
        inliers = 0;
        
        for i = 1:size( P1, 2 )
            p1 = P1(1:2, i);
            p2 = P2(1:2, i);
            
            d = sampsonDistance(p1, p2, F_candidate);
            if d < 200
                inliers = inliers + 1;
            end
        end
        
        if inliers > most_inliers
            F                = F_candidate;
            most_inliers     = inliers;
            improvementSteps = improvementSteps + 1;
        end
        
    end
    
end

