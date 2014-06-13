 function ret = merge(base, target, nn)
 %MERGE two pointclouds given the nearest neighbors of the 2nd to the 1st
    tic
    ret = target;

    distan = (target(nn,:) - base) .^2;
    distances = sqrt(distan(:, 1) + distan(:, 2) + distan(:, 3));
    
    filter    = distances > .5;
    ret       = [ret; base(filter, :)];
    
    % printouts
    b_sz = size(target,1);
    t_sz = size(base,1);
    r_sz = size(ret, 1);
    disp(strcat('___|B|:', num2str(b_sz), ' |T|:', ...
                num2str(t_sz), ' |merged|:', num2str(r_sz), ...
                ' discarded:', num2str(b_sz + t_sz - r_sz) ...
            ));
    toc
end