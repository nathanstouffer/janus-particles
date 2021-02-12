function [K_lib] = Klibfunc(alpha,angle_number,N)
%Takes alpha, number of angles, and size as arguments
%  Generates a cell array filled with kernel matrices that we can pull
%  from for a convolution. Can now call the Klibfunc in the
%  convolution script.

% Sets up orientations for the right number of angles
step = 2*pi/angle_number;
theta = 0:step:2*pi-step;
L = length(theta);

%Sets up an empty cell array
K_lib = cell(1,L);

%This fills the array above using the kernel_functionfinal
for i = 1:L
    K = kernel_functionfinal(alpha,theta(i),N);
    %         K_lib{i} = K;
    % precompute fft2 of this filter for faster convolution:
    % padarray to reach 4*N size (smallest power of two to accommodate
    % result); circshift to have filter origin at (1,1)
    K_lib{i} = fft2(circshift(padarray(K, [2*N-1, 2*N-1], 0, 'post'), [-N,-N]));
    
end
end