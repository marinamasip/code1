function [pu,pt,Fy,Mz] = computeIntDis(n_el,u,Td,x,Tn,Kel,n_ne,n_i)

for e = 1 : n_el
    x1 = x(Tn(e,1),1);
    x2 = x(Tn(e,2),1);
    l = abs(x2-x1);

    for i = 1 : (n_ne*n_i)
        I = Td(e,i);
        u_e(i,1) = u(I);
    end

   Fint = Kel(:,:,e) * u_e;

   Fy(e,1) = -Fint(1); %Shear Force

   Fy(e,2) = Fint(3); %Shear Force

   Mz(e,1) = -Fint(2); %Bending moment

   Mz(e,2) = Fint(4); %Bending moment

   a = (1 / l^3) * [2 l -2 l] * u_e;
   b = (1 / l^3) * [-3*l -2*l^2 3*l -(l)^2] * u_e;
   c = (1 / l^3) * [0 l^3 0 0] * u_e;
   d = (1 / l^3) * [l^3 0 0 0] * u_e;
  
    pu(e, [1,2,3,4]) = [a, b, c, d];
    pt(e, [1,2,3]) = [3*a, 2*b, c ];

    if e==n_el
         uy=a*l^3+b*l^2+c*l+d;
    end

end
