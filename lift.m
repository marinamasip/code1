function [l] = lift(L1,L2,M,Me,g)

weight = 0;
lift = 0;
syms l

%PES

w1 = @(x) (M/(4*(L1+L2)))+(3*M/(2*L2^2)).*(L1-x);
w1 = integral(w1,0,L1);

w2 = (M/(4*(L1+L2))) * (L2);

weight = (w1 + w2 + Me) * g;

% LIFT

l1 = @(x) ( 0.8 - 0.2 * cos(( pi .* x )/ L1 ));
l1 = integral(l1,0,L1);

l2 = @(x) ( 1 - (( x - L1 )/ L2 )) .* ( 1 + (( x - L1 )/ L2 ));
l2 = integral(l2,L1,(L1+L2));

lift = (l1 + l2);

eqn = l*lift - weight == 0;
l = solve(eqn,l);
l = double(l);