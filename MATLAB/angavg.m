function Avg = angavg(rho)
%Function to angularly average the annular cross-sections
%   Uses COMcross and imrotate function. Returns averaged data across 180
%   degrees

% Grab the size of the image
[x,y] = size(rho);

% Find the x,y (pixel) pair that is center of mass
xcom = COMcross(rho);
ycom = COMcross(rho');

% Initalize blank 10xy matrix
X = zeros(10,y);

% Fill the first row with the original crossection
X(1,:) = rho(xcom,:);

% Rotates image, finds new center of mass, takes cross-section for X-matrix
for i = 1:9
    rhobar = rotate_image(rho,xcom,ycom,pi/10*i,'spline');
    xcom = COMcross(rhobar);
    ycom = COMcross(rhobar');
    X(i+1,:) = rhobar(xcom,:);
end

Avg = sum(X) ./ 10;

% Uncomment below for debugging purposes
% figure;
% plot(Avg);
end

