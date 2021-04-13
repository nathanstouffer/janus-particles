function [active_density,inactive_density] = activation_annulus(angular_data,activation_data)
%Shows the presence of active particles in the disk contrasting with
%inactive particles on the annulus
%   Takes angular_data and activation_data. The activation data should come
%   from the activation_analysis script run on the angular data in
%   question. If you don't change the file name in Image-Writing it will
%   write over the current images you have stored there

% Grabs size
[x,y,z] = size(angular_data);

% Initialize blank images
active_density = zeros(x,y);
inactive_density = zeros(x,y);

% Creates the images
for i = 1:z
    
    % For the active we pointwise mult with activation mask
    active_density = active_density + angular_data(:,:,i).*activation_data(:,:,i);
    
    % For inactive we take the negative of the activation mask then repeat
    reverse = activation_data(:,:,i) == zeros(x,y);
    inactive_density = inactive_density + angular_data(:,:,i).*reverse;
end

%Determines max value
M = max([max(max(active_density)),max(max(inactive_density))]);

% Plotting
figure;
subplot(1,2,1)
imagesc(active_density);
daspect([1,1,1]);
axis off;
set(gca, 'clim', [0,M]);
title('Active Density')
subplot(1,2,2)
imagesc(inactive_density);
daspect([1,1,1]);
axis off;
set(gca, 'clim', [0,M]);
title('Inactive Density')

% Image-Writing (best done with the negative of black and white image)
negative1 = ones(x,y) - active_density./M;
negative2 = ones(x,y) - inactive_density./M;
active_density = negative1;
inactive_density = negative2;

% imwrite(negative1,'../img/Result-Images/active_density2.png');
% imwrite(negative2,'../img/Result-Images/inactive_density2.png');
end

