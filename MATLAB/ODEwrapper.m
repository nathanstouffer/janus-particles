clear all;
close all;
clc;


N = 32; % spatial resolution
phi = 36; % angular resolution
T = 1;  % simulation duration

sigma = 4; % activation threshold
v = 1; % activation drift
D_phi = 1; % angular diffusion coefficient
D_xy = 1; % spatial diffusion coefficient



rhostack = rand(N,N,phi);

% Setting up L and div matrices
Df = spdiags( repmat( [-1 1], N,1 ), [0 1], N, N ); % This is a sparse, NxN matrix where  +/- ones(N,1) are placed on the 0th and 1st diagonal
Df(end,:) = 0;
Db = -rot90(Df,2);
D = (Df + Db)/2; % centered differences 

L = (-Df'*Df-Db'*Db)/2; % Laplacian is average of fwd/bwd grad-divergence composition
  

% setting up kernel libraries
K = Klibfunc(pi/4,phi,N);

[t,y] = ode113(@(t,y) janus(y,N,phi,sigma,v,D_phi,D_xy,K,D,L), (0:0.1:1)*T, rhostack(:));