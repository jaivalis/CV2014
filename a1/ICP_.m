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
        [R_temp,t_temp] = getTransformation(matches, base_prime);

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


function [R,t] = getTransformation(target,base)
% get mean from base and mean from target, correct
mu_base = mean(base, 2);
base_new = base - repmat(mu_base, 1, size(base, 2));
mu_target = mean(target, 2);
target_new = target - repmat(mu_target, 1, size(target, 2));

% compute A
A = base_new*target_new';

% perform SVD
[U,~,V] = svd(A);

% return R and t
R = V*U';
t = mu_target - R*mu_base;
end