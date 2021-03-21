function [] = spatial_convergence(directory_name)
%spatial_convergence: takes pde-data from the directory and plots the
%cross-sections of the final-state.
%   Just input the directory_name where the files are stored. Returns the
%   plot of the PDE data with a legend so that no matter what order the
%   data files are read in we know what was graphed. The x-axis for each is
%   scaled and put into Micrometers so that no-matter the spatial
%   resolution of the pde data we can plot them accurately

X = dir(directory_name);
n = numel(X);

figure;
for i = 3:n
    
    % Load in the data
    temp = load(strcat(directory_name,'/',X(i).name));
    temp = cell2mat(struct2cell(temp));
    
    % Grab the size (stores str for lengend)
    sz = size(temp);
    v = 1:sz(1);
    str = num2str(sz(1));
    
    % The angular averaging of end-state plus scaling and COM
    avg = angavg(temp(:,:,end));
    avg = avg ./ max(avg);
    COM = round(sum(avg.*v)./sum(avg));
    
    % Micrometers
    scale = 250./sz(1);
    
    % Plotting (shift each by their COM in order to center at zero)
    plot((v-COM).*scale,avg,'DisplayName',str,'Linewidth',1.5);
    hold on;
end
legend
end

