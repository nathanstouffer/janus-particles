function [Activation] = activation_analysis(angular_data, alpha)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Grabs the size of the array (should be n by n by angle res)
[n,m,z] = size(angular_data);

% Need to know alpha and the spatial and angular resolution for Kernels
K = Klibfunc(alpha,m,z);

% Let's hard-code the threshold (Usually using P_c^alpha with 75 particles)
P = 2*alpha*75/pi/pi/m;

% Grabs the rho_int
rho_int = sum(angular_data,3);

% pad rho_int to reach 4*N side length, fft2
rho_int_hat = fft2(padarray(rho_int, [3*m 3*m], 0, 'post'));

% Initialize array to store the activation values
Activation = zeros(n,n,z);
for i = 1:z
    
 % filter and ifft
    P = ifft2( rho_int_hat .* K{i} );
    P = P(1:N, 1:N); % extract the relevant portion
    f = (P >= Pstar); % Activation
    Activation(:,:,i) = f;
    
end


end

