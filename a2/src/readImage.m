function img = readImage( dataset, i )
%READIMAGE Summary of this function goes here
%   Detailed explanation goes here
    single((imread(sprintf(dataset, i))));
    
    if strcmp(dataset, 'House/frame%08d.png')
        img_ = single(imread(sprintf(dataset, i)));
        %     if strcmp(dataset, 'TeddyBear/obj02_%03d.png')
        img = img_(70:end, 115:end);
%     elseif strcmp(dataset, 'House/frame%08d.png')
%         img = img(115:end, 70:end);
%     end

    elseif strcmp(dataset, 'TeddyBear/obj02_%03d.png')
        img_ = single(rgb2gray(imread(sprintf(dataset, i))));
        img = img_(340:1250, 700:1600);
    else
        error('(readImage:) This should not have happened');
    end
end

