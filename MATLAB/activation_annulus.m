function [active_density,inactive_density] = activation_annulus(angular_data,activation_data)
%Shows the presence of active particles in the disk contrasting with
%inactive particles on the annulus
%   Takes angular_data and activation_data. The activation data should come
%   from the activation_analysis script run on the angular data in
%   question.

% Grabs size
[x,y,z] = size(angular_data);

% Initialize blank images
active_density = zeros(x,y);
inactive_density = zeros(x,y);

% Active Image
for i = 1:z
    active_density = active_density + angular_data(:,:,i).*activation_data(:,:,i);
    
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

% Image-Writing
negative1 = ones(x,y) - active_density./M;
negative2 = ones(x,y) - inactive_density./M;

imwrite(negative1,'../img/Result-Images/active_density.png');
imwrite(negative2,'../img/Result-Images/inactive_density.png');
end

