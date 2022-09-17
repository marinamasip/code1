function [u,R] = solveSys(vL,vR,uR,KG,Fext)

K_LL=KG(vL,vL);
K_LR=KG(vL,vR);
K_RL=KG(vR,vL);
K_RR=KG(vR,vR);
Fext_L=Fext(vL,1);
Fext_R=Fext(vR,1);

uL=inv(K_LL)*(Fext_L-K_LR*uR);

R=K_RR*uR+K_RL*uL-Fext_R;

u(vL,1)=uL;
u(vR,1)=uR;