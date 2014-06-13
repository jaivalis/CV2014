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
    [t, R] = ICP_( target', base'); %sampleTypes{1}, samples, neighbors);
    t1 = [t1; toc];
   
    
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