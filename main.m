%-------------------------------------------------------------------------%
% ASSIGNMENT 03 - (A)
%-------------------------------------------------------------------------%
% Date:
% Author/s: MMF & VMG
%

clear;
close all;

%% INPUT DATA

% Material properties
E = 8.5 * 10^(10);

% Cross-section parameters
t1 = 1.5 * 10^(-3);
t2 = 4 * 10^(-3);
h1 = 500 * 10^(-3);
h2 = 250 * 10^(-3);
b = 775 * 10^(-3);


% Other data
g = 9.81;
L1 = 5;
L2 = 10;
L = L1+L2;
Me = 2550;
M = 35000;

% Number of elements for each part
n_el = [3,6,12,24,48,96];
%n_el = 96;
Nel = 96; % Number of elements for the "exact" solution

%% PRECOMPUTATIONS

% Compute section: 
% A  - Section area
A=b*((h1+h2)/2)-(b-2*t2)*((h1+h2-4*t1)/2);
% C - Section centroid
C = (( t2 * h1 * (b/2) + t2 * h2 * (-b/2)) / ( t2 * (h1+h2) + 2 * t1 * ( b / cos (atan ((h1-h2)/2*b)) ) ) );
% Iz - Section inertia
Izz1 = (1/12)*t2*h1^3 ;
Izz2 = (1/12)*t1*(b/(cos(atan((h1-h2)/2*b))))^3*(sin(atan(((h1-h2)/2)/b)))^2 + (((h1/2) - (h1-h2)/4)^2 * (t1 * (b/(cos(atan((h1-h2)/2*b))))));
Izz3 = (1/12)*t1*(b/(cos(atan((h1-h2)/2*b))))^3*(sin(atan(((h1-h2)/2)/b)))^2 + (((h1/2) - (h1-h2)/4)^2 * (t1 * (b/(cos(atan((h1-h2)/2*b))))));
Izz4 = (1/12)*t2*h2^3 ;
Iz = Izz1 + Izz2 + Izz3 + Izz4;

% Compute parameter l:
% l - Equilibrium parameter
[l] = lift(L1,L2,M,Me,g);

% Plot analytical solution
fig = plotBeamsInitialize(L1+L2);

% Loop through each of the number of elements
for k = 1:length(n_el)


    %% PREPROCESS
    
    % Nodal coordinates
    %  x(a,j) = coordinate of node a in the dimension j
    % Complete the coordinates
    separacio = L / n_el(k);
    x(1,1) = 0 ;
    for i = 2 : (n_el(k) + 1)

    x(i,1) = (i-1)*separacio;

    end

     % Dimensions
    n_d = size(x,2);           % Problem dimensions
    n_nod = size(x,1);         % Total number of nodes (joints)
    n_ne = 2;                  % Number of nodes in a beam
    n_i = 2;                   % Number of DOFs for each node
    n_dof = n_i * n_nod;       % Total numbers of degrees of freedom

    % Nodal connectivities  
    %  Tn(e,a) = global nodal number associated to node a of element e

    Tn = size(n_el(k),n_ne);
    for i = 1 : n_el(k)
        Tn(i,1) = (2*i)-i;
        Tn(i,2) = (2*i)-i+1;
    end
    
    % Material properties matrix
    %  mat(m,1) = Young modulus of material m
    %  mat(m,2) = Section area of material m
    %  mat(m,3) = Section inertia of material m
    mat = [% Young M.        Section A.    Inertia 
              E,                A,         Iz; % Beam (1)
    ];

    % Material connectivities
    %  Tmat(e) = Row in mat corresponding to the material associated to element e
    for i = 1 : n_el(k)
    Tmat(i,1) = 1;
    end
        
    %% SOLVER

    % Compute:
    % u  - Displacements and rotations vector [ndof x 1]
    % pu - Polynomial coefficients for displacements for each element [nel x 4]
    % pt - Polynomial coefficients for rotations for each element [nel x 3]
    % Fy - Internal shear force at each elements's nodes [nel x n_ne]
    % Mz - Internal bending moment at each elements's nodes [nel x nne]

    % Computation of the DOFs connectivities
    Td = connectDOFs(n_el(k),n_nod);
    
    % Computation of element stiffness matrices
    Kel = computeKelBar(n_ne,n_el(k),n_i,x,Tn,mat,Tmat);
    
    % Computation of q
    q = computeq(L1,L2,M,Tn,x,g,l,n_el(k));

    % Computation of the element force vector
    Fel = computeElForVec(q,n_ne,n_el(k),n_i,x,Tn);
    
    % Global matrix assembly
    [KG,Fext] = assemblyKG(n_ne,n_dof,n_el(k),n_i,Td,Kel,Fel,Me,g);
    
    % Apply conditions 
    [vL,vR,uR] = applyCond(n_i,n_dof);
    
    % System resolution
    [u,R] = solveSys(vL,vR,uR,KG,Fext);
    
    % Compute internal distributions
    [pu,pt,Fy,Mz] = computeIntDis(n_el(k),u,Td,x,Tn,Kel,n_ne,n_i);
    
    %% POSTPROCESS
    
    % Number of subdivisions and plots
    nsub = Nel/n_el(k);
    plotBeams1D(fig,x,Tn,nsub,pu,pt,Fy,Mz)
    drawnow;
    
 end

% Add figure legends
figure(fig)
legend(strcat('N=',cellstr(string(n_el))),'location','northeast');