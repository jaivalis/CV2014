function [norm_points, T] = normalizePoints( points )
%NORMALIZEPOINTS

% points at this point have 2000 entries (should have 8)
    m_x = mean(points(1, :));
    m_y = mean(points(2, :));
    
    d = sum((points(1,:) - m_x) .^ 2) + sum((points(2,:) - m_y) .^ 2);
    d = sqrt(d) / 8;
    
    sq2 = sqrt(2);
    T  = [ sq2/d   0    -m_x*sq2/d; 
           0     sq2/d  -m_y*sq2/d;
           0       0         1      ];
    tic
    for i = 1 : size(points,2)
        norm_points(:,i) = T * [points(1, i); points(2, i); 1];
    end
    toc
    % check for mean = 0
    %mean(norm_points,2)
    
end

