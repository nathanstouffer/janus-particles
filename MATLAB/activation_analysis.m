function [Activation] = activation_analysis(angular_data, alpha)
%Does some activation analysis of angular data
%   Input angular data (should be n by n by angular resolution) and alpha
%   value we ran the simulation at (this is almost always pi/2). Outputs an
%   array same dimensions as angular data only it will be a binary image.
%   imshow() works well to show it.

% Grabs the size of the array (should be n by n by angle res)
[n,m,z] = size(angular_data);

% Need to know alpha and the spatial and angular resolution for Kernels
K = Klibfunc(alpha,z,m);

% Let's hard-code the threshold (Usually using P_c^alpha with 75 particles)
Pstar = 2*alpha*75/pi/pi/m;

% Grabs the rho_int
rho_int = sum(angular_data,3);

% pad rho_int to reach 4*N side length, fft2
rho_int_hat = fft2(padarray(rho_int, [3*m 3*m], 0, 'post'));

% Initialize array to store the activation values
Activation = zeros(n,n,z);
for i = 1:z
    
 % filter and ifft
    P = ifft2( rho_int_hat .* K{i} );
    P = P(1:m, 1:m); % extract the relevant portion
    f = (P >= Pstar); % Activation
    Activation(:,:,i) = f;
    
end

com = [COMcross(rho_int) COMcross(rho_int')];
com = com./n - 0.5;
com = [com(1) -com(2)];
com = com + 0.5;

% compute the activation border and write to file
for i = 1:16
    % compute the center of mass of the matrix
    com_ang = [COMcross(angular_data(:,:,i)), COMcross(angular_data(:,:,i)')];
    % scale and shift
    com_ang = com_ang./n - 0.5;
    % flip axis and shift back
    com_ang = [com_ang(1) -com_ang(2)];
    com_ang = com_ang + 0.5;
    % initialize the info matrix
    info = [com(1) com(2); com_ang(1) com_ang(2); (i-1)*2*pi/z alpha];
    % get the index of one of the points on the boundary
    perim = bwperim(Activation(:,:,i));
    [j k] = find(perim, 1, 'first');
    % get the path as a list of pairs
    % this is indexed as (row, col) from top left
    mtx_path = bwtraceboundary(Activation(:,:,i), [j k], 'W');
    % normalize the pixel values
    mtx_path = (mtx_path./n)-0.5;
    % switch to regular (x, y) indexing
    path = [mtx_path(:,2) -mtx_path(:,1)];
    path = path+0.5;
    info = [info(:,1) info(:,2); path(:,1) path(:,2)];
    f_name = strcat('../latex-scripts/activation-border/input/angle', num2str(i), 'polygon.txt');
    writematrix(info, f_name);
end

end

