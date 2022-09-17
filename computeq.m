function [q] = computeq(L1,L2,M,Tn,x,g,l,n_el)


for e = 1 : n_el

%LIFT - PES

if x(Tn(e,2),1) <= L1 
   
    lim1 = x(Tn(e,1),1);
    lim2 = x(Tn(e,2),1);
    f = @(x) l * ( 0.8 - 0.2 * cos(( pi .* x )/ L1 )) - g * ((M/(4*(L1+L2)))+(3*M/(2*L2^2)).*(L1-x));
    f = integral(f,lim1,lim2);

    f = f / (lim2-lim1);

else

    lim1 = x(Tn(e,1),1);
    lim2 = x(Tn(e,2),1);

    f = @(x) l * ( 1 - (( x - L1 )/ L2 )) .* ( 1 + (( x - L1 )/ L2 )) - g * (M/(4*(L1+L2)));
    f = integral(f,lim2,lim1);

    f = f / (lim2-lim1);

end

q(e) = f;

end