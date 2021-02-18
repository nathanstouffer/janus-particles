function [M2, M3] = Moments(rho)
%Finds moments of the density image rho
    % rho should be square
    
% Grab size
[n,m] = size(rho);

% Find pixel values for center of mass
x = COMcross(rho);
y = COMcross(rho');

% Mesh grid
X = meshgrid(1:n);

% Find distances from COM
I_x = X-x*ones(n,n);
I_y = X'-y*ones(n,n);

% Normally we would take the square-root but second moment asks for |r|^2
I2 = (I_x.^2 + I_y.^2);
I2 = I2./ max(max(I2));



% For the third-moment we will take square-root then cube
I3 = (I_x.^2+I_y.^2).^(1.5);
I3 = I3./ max(max(I3));

% Pointwise multiply with rho and sum
M2 = sum(I2.*rho,'all');
M3 = sum(I3.*rho,'all');

end

