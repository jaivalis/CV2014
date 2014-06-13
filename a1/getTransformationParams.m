function [ R, t ] = getTransformationParams( target, base )
%GETTRANSFORMATIONPARAMS Returns R and t given two point clouds
%   Detailed explanation goes herefunction [R,t] = getTransformation(target,base)
    % Phase2: Find centroid
    mu_base   = mean(base, 2);
    mu_target = mean(target, 2);
    base_new   = base - repmat(mu_base, 1, size(base, 2));
    target_new = target - repmat(mu_target, 1, size(target, 2));

    % compute A
    A = base_new * target_new';
    [U, ~, V] = svd(A);

    % Phase4: Finding out rotation and translation based on svd result
    R = V * U';
    t = mu_target - R * mu_base;

end

