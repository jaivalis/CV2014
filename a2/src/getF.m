function [F, sampl] = getF( p1, p2, matches, type, sampleSize )
%GETF Returns the Fundamental matrix based on the type of method requested

    sampl = matches(:, randi(size(matches, 2), 1, sampleSize)); % not used in nepransac
    
    if strcmp(type, 'EP')
        p1_ = p1(:, sampl(1, :));
        p2_ = p2(:, sampl(2, :));
        F  = eightPoint(p1_, p2_);
    elseif strcmp(type, 'nEP')
        F  = normalizedEP(p1, p2, sampl);
    elseif strcmp(type, 'nEPRansac')
        [F, sampl] = normalizedEPRansac(p1, p2, matches);
    end

     % verification of F
%     test1 = cat(2, p1(1:2,:)', ones(size(p1, 2),1));
%     test2 = cat(2, p2(1:2,:)', ones(size(p2, 2),1));
%     avgError = 0;
%     for match = 1:size(sampl, 2)
%         verif = test2(sampl(2,match),:) * F * test1(sampl(1,match),:)';
%         avgError = avgError + abs(verif);
%     end
%     disp(strcat('(getF.m:) Average error: ', num2str(avgError / size(sampl, 2))));

end

