 function ret = merge(base, target, nn)
 %MERGE two pointclouds given the nearest neighbors of the 2nd to the 1st
    ret = target;
    if nn == -1
        kdtree = vl_kdtreebuild(target');
        idxs = [];
        ret = zeros(size(base'));
        for j = 1:size(base, 1)
            p = base(j, :);
            [idxs(j, :), ~] = vl_kdtreequery(kdtree, target', p');
            ret(:,j)  = target(idxs(j,:), :);
        end
        nn = idxs;
        distan = target(nn,:) - base .^2;
        distances = sqrt(distan(:, 1) + distan(:, 2) + distan(:, 3));

        filter    = distances > .5;
        ret       = [ret base(filter, :)'];
        ret = ret';
    else
        distan = target - base(nn,:) .^2;
        distances = sqrt(distan(:, 1) + distan(:, 2) + distan(:, 3));

        filter    = distances > .5;
        ret       = [ret; base(filter, :)];
    end
    % printouts
    b_sz = size(base,1);
    t_sz = size(target,1);
    r_sz = size(ret, 1);
    disp(strcat('___|B|:', num2str(b_sz), ' |T|:', ...
                num2str(t_sz), ' |merged|:', num2str(r_sz), ...
                ' discarded:', num2str(b_sz + t_sz - r_sz) ...
            ));
end