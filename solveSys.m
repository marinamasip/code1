function [u,R] = solveSys(vL,vR,uR,KG,Fext,type)

K_LL=KG(vL,vL);
K_LR=KG(vL,vR);
K_RL=KG(vR,vL);
K_RR=KG(vR,vR);
Fext_L=Fext(vL,1);
Fext_R=Fext(vR,1);
P=Fext_L-K_LR*uR;

%uL=inv(K_LL)*P;
s.LHS = K_LL;
s.RHS = P;
s.type = type;
solver = Solver.create(s);
uL=solver.solve();
    
R=K_RR*uR+K_RL*uL-Fext_R;

u(vL,1)=uL;
u(vR,1)=uR;