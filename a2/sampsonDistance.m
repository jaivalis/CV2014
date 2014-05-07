function d = sampsonDistance( p1, p2, F )
%SAMPSONDISTANCE Calculates the sampson distance for two points as given in
%                section 1.3
    p1 = [p1(1); p1(2); 1];
    p2 = [p2(1); p2(2); 1];
    
    Fp1 = F * p1;
    Fp2 = F' * p2;
    
    d = (p2' * F * p1) ^ 2;
    d = d / (Fp1(1) ^ 2 + Fp1(2) ^ 2 + Fp2(1) ^ 2 + Fp2(1) ^ 2); 
end

