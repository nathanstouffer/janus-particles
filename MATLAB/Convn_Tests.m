clear all;
close all;

%% Convolution Tests
phi = 36; % The number of species we want to test;
N = 250;% Size we want. Can be altered.  

rho = cell(phi,1); % Sets up empty cell arrays for density of species phi

for i = 1:phi % For each species phi
    rho{i} = rand(N,N); % We generate a random density for that species and put it in a cell array
end


theta = linspace(0,2*pi,phi+1);

rho_int = sum( cat(3,rho{:}), 3 ); % Takes all the rho matrices (rho{:}) stacks them as pages (3) then adds all the pages together (3

K = Klibfunc(pi/4,phi,N); % Calls the kernel function with desired alpha and size and creates kernels for each species phi

V = cell(phi,1); % Empty cell array for advection term(s)

for i = 1:phi % For each species (or direction we can look) taking the convolution 
    V{i} = conv2(rho_int,K{i},'same');  %  /!\ would want to keep the same size as rho_int (kernel could be smaller), thus reorder.
end

jj = 1;
for i = [1 10 19 28]
    subplot(2,4,jj); jj = jj+1;
    imagesc(K{i});
    subplot(2,4,jj); jj = jj+1;
    imagesc(V{i});
end