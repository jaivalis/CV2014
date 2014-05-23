function img = readImage( dataset, i )
%READIMAGE Summary of this function goes here
%   Detailed explanation goes here
    single((imread(sprintf(dataset, i))));
    
    if strcmp(dataset, 'House/frame%08d.png')
        img = single(imread(sprintf(dataset, i)));
    elseif strcmp(dataset, 'TeddyBear/obj02_%03d.png')
        img = single(rgb2gray(imread(sprintf(dataset, i))));
    else
        error('(readImage:) This should not have happened');
    end

end

