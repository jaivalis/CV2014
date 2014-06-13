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

%% 2.1 merge the results every 1, 2, 4, 10 frames
stepSize = 1;
for image = 4:stepSize:98
    
    base   = getPcd( image, sampleTypes{1}, samples );
    target = getPcd( image + 1, sampleTypes{1}, samples );
    tic
    [t, R, rms] = ICP_( target', base', 10); %sampleTypes{1}, samples, neighbors);
    t1 = [t1; toc];
    RMS1 = [RMS1; rms];
    
    base   = getPcd( image, sampleTypes{2}, samples );
    target = getPcd( image + 1, sampleTypes{2}, samples );
    tic
    [t, R, rms] = ICP_( target', base', 10);%sampleTypes{2}, samples, neighbors);
    t2 = [t2; toc];
    RMS2 = [RMS2; rms];
    
    base   = getPcd( image, sampleTypes{3}, samples );
    target = getPcd( image + 1, sampleTypes{3}, samples );
    tic
    [t, R, rms] = ICP_( target', base', 10);%sampleTypes{3}, samples, neighbors);
    t3 = [t3; toc];
    RMS3 = [RMS3; rms];
    m = merge(base, target);
    all = merge(all, m);
    
end

%% 2.2 merge clouds and use result as new base
% base   = getPcd( image, sampleTypes{1}, samples );
% for image = 0:98
%
%     target = getPcd( image + 1, sampleTypes{1}, samples );
%     [t, R, rms] = ICP_( target', base', 10);
%     base = merge(base, target, idxs);
%     
% end