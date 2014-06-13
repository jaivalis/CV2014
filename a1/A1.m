clear all;
addpath('kdtree')

% params
sampleTypes = {'uniformRandom', 'uniformRandomNormal', 'none'};


neighbors  = 1;
type   = sampleTypes{1};
samples    = 10000;
% \params

all = [];

%% 2.1 merge the results every 1, 2, 4, 10 frames
stepSize = 1;
for image = 0:stepSize:98
    
    base   = getPcd( image, sampleTypes{1}, samples );
    target = getPcd( image + 1, sampleTypes{1}, samples );
    [t, R, idxs] = ICP_( target', base'); %sampleTypes{1}, samples, neighbors);
    merg = merge(base, target, idxs);
    if size(all, 2) == 0
        all = [all; merg];
    else
        all = merge(all, merg, -1);
    end
end

%% 2.2 merge clouds and use result as new base
% base   = getPcd( image, sampleTypes{1}, samples );
% for image = 0:98
%
%     target = getPcd( image + 1, sampleTypes{1}, samples );
%     [t, R, rms] = ICP_( target', base', 10);
%     base = merge(base, target, -1);
%     
% end