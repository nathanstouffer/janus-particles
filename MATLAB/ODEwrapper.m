clear all;
close all;
clc;

R = 250;  % 250 um side length of the 0-1-square
N = 32; % spatial resolution
h_x = R/N; % spatial step in um

phi = 36; % angular resolution

T = 10000;  % simulation duration

n = 75; % "number" of particles --- total initial density
alpha = pi/4;

Pstar = 2*alpha*n/pi/pi/N; % activation threshold
v = 0.2; % activation drift (um/s)
D_xy = 0.02; % spatial diffusion coefficient (um^2/s)
D_phi = 1/110; % angular diffusion coefficient (1/s)




rhostack = zeros(N,N,phi);
rhostack( randperm(N*N*phi,n) ) = 1; % place n random particles...

% Setting up L and div matrices
% forward differences
Df = spdiags( repmat( [-1 1], N,1 ), [0 1], N, N )/h_x; % This is a sparse,
% NxN matrix where  +/- ones(N,1) are placed on the 0th and 1st diagonal
Df(end,:) = 0; % Neumann b.c.

Db = -rot90(Df,2); % backward differences
D = (Df + Db)/2; % centered differences

L = (-Df'*Df-Db'*Db)/2; % Laplacian is average of fwd/bwd grad-divergence composition


% setting up kernel libraries
K = Klibfunc(alpha,phi,N);

[t,y] = ode113(@(t,y) janus(y,N,phi,Pstar,v,D_phi,D_xy,K,D,L), (0:0.2:1)*T, rhostack(:));


%% viz: final perception and activations

figure;
stack = reshape(y(end,:),[N,N,phi]);
rho_int = sum(stack,3);
for i = 1:phi
    P = conv2(rho_int,K{i},'same'); % Convolution
    f = (P >= Pstar); % Activation
    subplot(6,12,i);
    imagesc(P);
    subplot(6,12,36+i);
    imagesc(1*f);
end
 
%% viz: densities over time

figure;
for tt = 1:length(t)
    stack = reshape(y(tt,:),[N,N,phi]);
    phistep = 3;
    for p = 1:phistep:phi
        subplot(length(t),phi/phistep,(1+(p-1)/phistep+(tt-1)*phi/phistep));
        imagesc(stack(:,:,p));
        title("t = " + t(tt) + "s, phi = " + p);
        axis tight;
        axis equal;
        axis off;
        box off;
    end
end