function d = sampsonDistance( P1, P2, F )
%SAMPSONDISTANCE Calculates the sampson distance for two points clouds as
%                given in section 1.3

    X2tFX1 = sum( (P2' * F) .* P1', 2 );
    FP1 = F * P1;
    FP2 = F' * P2;

    a = X2tFX1.^2;
    b = (FP1(1,:).^2 + FP1(2,:).^2 + FP2(1,:).^2 + FP2(2,:).^2);

    d = a' ./ b;

end