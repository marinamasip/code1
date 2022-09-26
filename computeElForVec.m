function Fel = computeElForVec(q,n_ne,n_el,n_i,x,Tn)

for e = 1 : n_el
    x1 = x(Tn(e,1),1);
    x2 = x(Tn(e,2),1);
    l = abs((x2-x1));
  

    F = ( q(e) * l / 2) * [1; (l/6); 1; -(l/6)];

    for r = 1 : (n_ne * n_i)
        Fel(r,e) = F(r);
    end
end
