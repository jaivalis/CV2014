function [norm_points, T] = normalizePoints( points )
%NORMALIZEPOINTS Normalizes a set of points so that their mean is 0
    m_x = mean(points(1, :));
    m_y = mean(points(2, :));
    
    d = sum((points(1,:) - m_x) .^ 2) + sum((points(2,:) - m_y) .^ 2);
    d = sqrt(d) / 8;
    
    sq2 = sqrt(2);
    T  = [ sq2/d   0    -m_x*sq2/d; 
           0     sq2/d  -m_y*sq2/d;
           0       0         1      ];

    for i = 1 : size(points,2)
        norm_points(:,i) = T * [points(1, i); points(2, i); 1];
    end
    
    %assert(mean(norm_points,2) == [0;0;1],...
    %    'normalizePoints(): mean is not zero');
end

