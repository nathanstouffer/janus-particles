clear all
close all
%% Convolution Tests
phi = 10; % The number of species we want to test;
N = 256;% Size we want. Can be altered.  /!\ SIZE is a built-in function, avoid overwriting it as a variable

rho = cell(phi,1); % Sets up empty cell arrays for density of species phi
rho_int = zeros(N); % Sets up the integral (zeros right now) over all the species densities

for i = 1:phi % For each species phi
    rho{i} = rand(N,N); % We generate a random density for that species and put it in a cell array
    rho_int = rho_int + rho{i}; % We add it to the integral over all species 
end
% the for loop works, you could also consider this "trick": rho_int = sum( cat(3,rho{:}), 3 );



K = Klibfunc(pi/4,phi,N); % Calls the kernel function with desired alpha and size and creates kernels for each species phi

V = cell(phi,1); % Empty cell array for advection term(s)

for i = 1:phi % For each species (or direction we can look) taking the convolution 
    V{i} = conv2(rho_int,K{i},'same');  %  /!\ would want to keep the same size as rho_int (kernel could be smaller), thus reorder. Sparse, if possible? conv2, not convn, after all
    % Below just helps withsome visualization
    I = mat2gray(V{i});
    figure;
    imshow(I)
end


