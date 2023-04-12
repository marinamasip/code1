%-------------------------------------------------------------------------%
% ASSIGNMENT 03 - (A)
%-------------------------------------------------------------------------%
% Date:
% Author/s: MMF 

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
type = input ('Insert a type of solver (Direct for DirectSolver, Iterative for IterativeSolver)');

% Number of elements for each part
n_el= [3,6,12,24,48,96];
Nel = 96; % Number of elements for the "exact" solution

%% SOLVER

s.problemParameters.mYoung=E;
s.problemParameters.t1=t1;
s.problemParameters.t2=t2;
s.problemParameters.h1=h1;
s.problemParameters.h2=h2;
s.problemParameters.b=b;
s.problemParameters.gravity=g;
s.problemParameters.length1=L1;
s.problemParameters.length2=L2;
s.problemParameters.totalLength=L;
s.problemParameters.elementFlex=Me;
s.problemParameters.totalFlex=M;
s.problemParameters.type=type;
s.problemParameters.nElements=n_el;
s.problemParameters.nElExactSol=Nel;

s.type=type;
a=TestComputer(s);
a.compute();



