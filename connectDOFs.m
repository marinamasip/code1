function Td = connectDOFs(n_el,n_nod)

Td = size(n_el,n_nod);
    Td(1,1) = 1;
    Td(1,2) = 2;
    Td(1,3) = 3;
    Td(1,4) = 4;


    
for i = 2 : n_el
    Td(i,1) = Td(i-1,3);
    Td(i,2) = Td(i-1,3)+1;
    Td(i,3) = Td(i,2) + 1;
    Td(i,4) = Td(i,3) + 1;

end
    
    