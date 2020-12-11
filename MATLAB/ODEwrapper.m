clear all;
close all;
clc;

% profile on;

reltol = 0.1; % default: 1e-3;
abstol = 0.01; % default: 1e-6;

R = 250;  % 250 um side length of the 0-1-square
N = 32; % spatial resolution
h_x = R/N; % spatial step in um

phi = 24; % angular resolution

T = 3000;  % simulation duration

n = 200; % "number" of particles --- total initial density
alpha = pi/2;

Pstar = 2*alpha*n/pi/pi/N; % activation threshold
v = 0.2; % activation drift (um/s)
D_xy = 0.02; % spatial diffusion coefficient (um^2/s)
D_phi = 1/110; % angular diffusion coefficient (1/s)


rhostack = zeros(N,N,phi);
rhostack( randperm(N*N*phi,n) ) = 1; % place n random particles...

% if margins are needed:
%rhostack = zeros(N/2,N/2,phi);
%rhostack( randperm(N/2*N/2*phi,n) ) = 1; % place n random particles...
%rhostack = padarray(rhostack, [N/4 N/4 0], 0, 'both');

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
K = Klibfunc(alpha,phi,2*N);

tspan = (0:0.01:1)*T;

options = odeset('RelTol',reltol,'AbsTol',abstol, 'Stats', 'on', 'OutputFcn',@(t,y,flag) MyOutputFcn(t,y,flag,tspan(end)));

tic;
[t,y] = ode45(@(t,y) janus(y,N,phi,Pstar,v,D_phi,D_xy,K,-Db',-Df',L), tspan, rhostack(:), options);
toc

% profile off;
% profile viewer;

%% viz: final perception and activations
% 
% figure;
% stack = reshape(y(end,:),[N,N,phi]);
% rho_int = sum(stack,3);
% r = sqrt(phi);
% for i = 1:phi
%     P = conv2(rho_int,K{i},'same'); % Convolution
%     f = (P >= Pstar); % Activation
%     subplot(r,2*r,i);
%     imagesc(P);
%     subplot(r,2*r,phi+i);
%     imagesc(1*f);
% end

%% viz: densities over time

figure;
phistep = 3;
tstep = 10;
for tt = 1:tstep:length(t)
    stack = reshape(y(tt,:),[N,N,phi]);
    
    for p = 1:phistep:phi
        subplot(ceil(length(t)/tstep),phi/phistep+1,(1+(p-1)/phistep+floor(tt/tstep)*(phi/phistep+1)));
        imagesc(stack(:,:,p));
        title("t = " + t(tt) + "s, phi = " + p);
        axis tight;
        axis equal;
        axis off;
        box off;
    end
    subplot(ceil(length(t)/tstep),phi/phistep+1,ceil(tt/tstep)*(phi/phistep+1));
    imagesc(sum(stack,3));
    axis tight;
    axis equal;
    axis off;
    box off;
    disp("at t = " + t(tt) + "s: n = " + (sum(stack,'all')) );
end


%% movie
figure;
for tt = 1:length(t)
    imagesc(sum(reshape(y(tt,:),[N,N,phi]),3)); drawnow; pause(0.1);
end

% 
% %%
% data = squeeze(num2cell(reshape(y, [size(y,1),N,N,phi] ), [2 3]));
% for i = 1:numel(data)
%     data{i} = 100*squeeze(data{i});
% end
% DD = imtile(data', 'GridSize', size(data));
% % imshow(DD);
% imwrite(DD, "bigoutput.png");


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