clear all;
addpath('kdtree')

% params
sampleTypes = {'uniformRandom', 'uniformRandomNormal', 'none'};


neighbors  = 1;
type   = sampleTypes{1};
samples    = 10000;
% \params

t1 = [];
t2 = [];
t3 = [];
RMS1 = [];
RMS2 = [];
RMS3 = [];

%% 2.1 merge the results every 2, 4, 10 frames
stepSize = 1;
for image = 0:stepSize:98
    
    tic
    [~, ~, rms, ~, ~] = ICP_( image, image+1, sampleTypes{1}, samples, neighbors);
    t1 = [t1; toc];
    RMS1 = [RMS1; rms];
    
    tic
    [~, ~, rms, ~, ~] = ICP_( image, image+1, sampleTypes{2}, samples, neighbors);
    t2 = [t2; toc];
    RMS2 = [RMS2; rms];
    
    tic
    [~, ~, rms, ~, ~] = ICP_( image, image+1, sampleTypes{3}, samples, neighbors);
    t3 = [t3; toc];
    RMS3 = [RMS3; rms];
    
end

%% 2.2
for image = 0:stepSize:98
    
    tic
    [T, R, RMS, idxs, target] = ICP_( image, image+1, sampleTypes{1}, samples, neighbors);
    t1 = [t1; toc];
    base = merge(base, target, idxs);
    
end