function [KG, Fext] = assemblyKG(n_ne,n_dof,n_el,n_i,Td,Kel,Fel,Me,g)

Fext = zeros(n_dof,1);
Fext((n_el)*(2/3)+2,1) = - Me * g;
KG = zeros(n_dof,n_dof);

for e = 1 : n_el
    for i = 1 : (n_ne*n_i)
        I = Td(e,i);
        Fext(I) = Fext(I) + Fel(i,e);
        for j = 1 : (n_ne*n_i)
            J = Td(e,j);
            KG(I,J) = KG(I,J) + Kel(i,j,e);
        end
    end
end