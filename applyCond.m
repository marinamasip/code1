function [vL,vR,uR] = applyCond(n_i,n_dof)

fixNod = [1 1 0
    1 2 0];

vL = zeros(n_dof-size(fixNod,1), 1);
vR = zeros(size(fixNod,1),1);
uR = zeros(size(fixNod,1),1);

for i=1:size(fixNod,1)
    if fixNod(i,2)==1       
        vR(i)=fixNod(i,1)*n_i-1;
    else
        vR(i)=fixNod(i,1)*n_i;
    end
end

for i=1:size(fixNod,1)
    
    uR(i,1)=fixNod(i,3);
end

e=1:n_dof;
e(vR)=[];
vL=transpose(e);