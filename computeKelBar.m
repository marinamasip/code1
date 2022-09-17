function Kel = computeKelBar(n_ne,n_el,n_i,x,Tn,mat,Tmat)
Kel = zeros(4,4,n_el);
K = zeros(4,4);
for e = 1 : n_el
    x1 = x(Tn(e,1),1);
    x2 = x(Tn(e,2),1);
    l = abs(x2-x1);
    
    K = (mat(Tmat(e),1)*mat(Tmat(e),3)./l) .* [12 6*l -12 6*l;
        6*l (4*l)^2 -6*l (2*l)^2;
        -12 -6*l 12 -6*l;
        6*l (2*l)^2 -6*l (4*l)^2
        ];

    for r = 1 : (n_ne*n_i)
        for s = 1 : (n_ne*n_i)
            Kel(r,s,e) = K(r,s);
        
        end
    end
end

    
    