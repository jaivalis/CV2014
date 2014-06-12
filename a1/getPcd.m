function pcd = getPcd( id, type, sampleSize )
%GETPCD Returns a pointcloud
%   Detailed explanation goes here

    filename = sprintf('data/%010d.pcd', id);
    
    if strcmp(type, 'none')
        pcd   = readPcd( filename );
        % filter out z-values greater than 2
        index = (pcd(:, 3) < 2);
        pcd   = pcd(index, :);
        % base with only x,y,z values
        pcd   = pcd(:, 1:3);
        
    elseif strcmp(type, 'uniform')
        pcd   = readPcd( filename );
        % filter out z-values greater than 2
        index = (pcd(:, 3) < 2);
        pcd   = pcd(index, :);
        % base with only x,y,z values
        pcd   = pcd(:,1:3);
        sampleIDs = randsample(1:size(pcd, 1), sampleSize);
        pcd   = pcd(sampleIDs, :);
        
    elseif strcmp(type, 'random')
        filename = sprintf('data/%010d_normal.pcd', id);
        pcd   = readPcd( filename );
        % filter out z-values greater than 2
        index = (pcd(:, 3) < 2);
        pcd   = pcd(index, :);
        % base with only x,y,z values
        pcd   = pcd(:,1:3);
        sampleIDs = datasample(1:size(pcd, 1), sampleSize);
        
        pcd   = pcd(sampleIDs, :);
    else
         error('Unrecognised type in getPcd');
    end
end
