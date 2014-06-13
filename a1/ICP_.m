function [t, R] = ICP_(target, base)
% ICP_ Performs the ICP algorithm for two pointclouds
    t = zeros(3,1);
    R = eye(3,3);

    rms        = 1000;
    iterations = 1;
    
    while 1
        disp(strcat('_Iteration: ',num2str(iterations)));
        prev_rms = rms;

        % transform base by previous rotation and translation
        base_prime = R * base + repmat(t, 1, size(base, 2));


        % get matches between the transformed base and the target
        tic
        matches = getMatchingPoints(base_prime, target);
        toc

        % get transformation through SVD
        [R_temp,t_temp] = getTransformationParams(matches, base_prime);        

        % refine rotation and translation
        R = R_temp * R;
        t = R_temp * t + t_temp;

        rms = calculateRMS(matches, base_prime);
        
        % end loop
        disp(strcat('__RMS:', num2str(rms), ' prevRMS:', num2str(prev_rms), ...
                        ' Difference:', num2str(abs(prev_rms - rms))));
        iterations = iterations + 1;
        if abs(prev_rms - rms) < .0012
            break;
        end
    end
end