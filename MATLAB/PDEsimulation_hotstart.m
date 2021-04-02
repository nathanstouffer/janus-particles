function [rho_final] = PDEsimulation_hotstart(alpha,percep,spatialRes,angleRes,initial)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


reltol = 0.001; % default: 1e-3;
abstol = 0.0001; % default: 1e-6;

R = 250;  % 250 um side length of the 0-1-square
N = spatialRes; % spatial resolution
h_x = R/N; % spatial step in um

phi = angleRes; % angular resolution

T = 7500;  % simulation duration

n = 75; % "number" of particles --- total initial density

%p_c_alpha = alpha*n/pi/pi/N; % Calculates p_c_alpha

Pstar = percep; % activation threshold

v = 0.2; % activation drift (um/s)
D_xy = 0.02; % spatial diffusion coefficient (um^2/s)
D_phi = 1/110; % angular diffusion coefficient (1/s)


rhostack = initial;



% Setting up L and div matrices
% forward differences
Df = spdiags( repmat( [-1 1], N,1 ), [0 1], N, N )/h_x; % This is a sparse,
% NxN matrix where  +/- ones(N,1) are placed on the 0th and 1st diagonal
Df(end,:) = 0; % Neumann b.c.
Db = -rot90(Df,2); % backward differences

% note: div = - grad'; therefore, for advection term, we will need -Db'
% and -Df' instead of Df and Db

% also note: y-direction: D * [ ... ], x-direction: [ ... ] * D'

L = (-Df'*Df-Db'*Db)/2; % Laplacian is average of fwd/bwd grad-divergence composition


% setting up kernel libraries
K = Klibfunc(alpha,phi,N);

tspan = (0:0.01:1)*T;

options = odeset('RelTol',reltol,'AbsTol',abstol, 'Stats', 'on', 'OutputFcn',@(t,y,flag) MyOutputFcn(t,y,flag,tspan(end)));

tic;
[t,y] = ode45(@(t,y) janus(y,N,phi,Pstar,v,D_phi,D_xy,K,-Db',-Df',L), tspan, rhostack(:), options);
toc

superstack = zeros(N,N,phi,19);

% Saves the initial condition
superstack(:,:,:,1) = reshape(y(1,:),[N,N,phi]);

% Densely Sampled in the beginning
for i = 1:10
    stack = reshape(y(2*i+1,:),[N,N,phi]);
    %stack = sum(stack,3);
    superstack(:,:,:,i+1) = stack;
end

% Spreads out sampling for the rest
for i = 3:10
    stack = reshape(y((i*10 + 1),:),[N,N,phi]);
    %stack = sum(stack,3);
    superstack(:,:,:,i+9) = stack;
end

rho_final = superstack;

%% helper function for progress report

function status = MyOutputFcn(t,y,flag,endt)
switch flag
    case ''
        disp(t + " / " + endt + "   ---- int rho = " + sum(y(:)));
    case 'init'
        disp("ODE solver started");
    case 'done'
        disp("ODE solver done");
end
status = 0;
end

end

