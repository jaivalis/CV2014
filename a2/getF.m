function F = getF( p1, p2, matches, type )
%GETF Returns the Fundamental matrix based on the type of method requested

    m8 = matches(:, randi(size(matches, 2), 1, 8)); % not used in nepransac
    
    if strcmp(type, 'EP')
        F  = eightPoint(p1, p2, m8);
    elseif strcmp(type, 'nEP')
        F  = normalizedEP(p1, p2, m8);
    elseif strcmp(type, 'nEPRansac')
        F = normalizedEPRansac(p1, p2, matches);
    end

     % verification of F
    test1 = cat(2, i_points1(1:2,:)', ones(2000,1));
    test2 = cat(2, i_points2(1:2,:)', ones(2000,1));
    for match = 1 : size(matches8, 2)
        verif = test2(matches8(2,match),:) * F * test1(m8(1,match),:)';
        if verif ~= 0
            verif
        end
    end
    
end

