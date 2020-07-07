clear all
close all
%% Convolution Tests
phi = 10; % The number of species we want to test;
size = 256;% Size we want. Can be altered.

rho = cell(phi,1); % Sets up empty cell arrays for density of species phi
rho_int = zeros(size); % Sets up the integral (zeros right now) over all the species densities

for i = 1:phi % For each species phi
    rho{i} = rand(size,size); % We generate a random density for that species and put it in a cell array
    rho_int = rho_int + rho{i}; % We add it to the integral over all species 
end



K = Klibfunc(pi/4,phi,size); % Calls the kernel function with desired alpha and size and creates kernels for each species phi

V = cell(phi,1); % Empty cell array for advection term(s)

for i = 1:phi % For each species (or direction we can look) taking the convolution
    V{i} = convn(full(K{i}),rho_int,'same');
    % Below just helps withsome visualization
    I = mat2gray(V{i});
    figure;
    imshow(I)
end


