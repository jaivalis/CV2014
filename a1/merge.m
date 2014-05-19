 function ret = merge(base, target, nn)
 %MERGE two pointclouds given the nearest neighbors of the 2nd to the 1st
    tic
    ret = base;

    distan = target-base(nn, :) .^2;
    distances = sqrt(distan(:, 1) + distan(:, 2) + distan(:, 3));
    
    filter    = distances > .001;
    ret       = [ret; target(filter, :)];
    
    toc
end