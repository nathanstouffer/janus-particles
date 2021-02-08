function [x] = COMcross(rho)
%COMcross: Takes a cross section through the center of mass
%   Takes nxn image and graphs the densities of a cross section through the
%   center of mass
n = size(rho);
n = n(1);

Total = sum(rho,'all');
X = meshgrid(1:n);

N1 = sum(X.*rho,'all');

comx = N1/Total;
x = round(comx);

end

