%% Script that generates Kernel Matrices

%Enter desired number of angles
Number_of_Angles = 10;
step = 2*pi/Number_of_Angles;
theta = 0:step:2*pi-step;
L = length(theta);
%Sets up an empty array 256x256xLength
K_libr = cell(1,L);

%This fills the array above using the kernel_function
for i = 1:L
    K = kernel_functionfinal(pi/3,theta(i),256);
    K_libr{i} = K;
end

