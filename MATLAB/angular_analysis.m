function [M] = angular_analysis(A)
%Tool used for analysis of angular data
%   Takes angular data file: Should be nxnxz where z is the number of
%   angles in our discretization (often this is 60). Returns a matrix which
%   contains the *difference* between the angular states center of mass and
%   the summed state center of mass.

% Grabs sizes
[m,n,z] = size(A);

% Initializes two empty matrices. One will be filled with the centers the
% other will be our matrix of differences from the rho_int COM
centers = zeros(2,z);
M = zeros(2,z);

% Calculate rho_int by summing along third dimension and find COM
rho_int = sum(A,3);
COM = [COMcross(rho_int);COMcross(rho_int')];


% Loop through all the angles
for i = 1:z
    
    % Find the COM
    centers(1,i) = COMcross(A(:,:,i));
    centers(2,i) = COMcross(A(:,:,i)');
    
    % Find the difference with rho_int COM
    M(:,i) = centers(:,i) - COM;
end

% Basic plotting
figure;
scatter(M(1,:),M(2,:));

end

