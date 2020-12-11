%% Runs a batch of PDE Simulations while varying alpha and perception values


n = 75; % Initial particle density
disc = 32; % Discritization

alpha = linspace(pi/disc,pi,disc);
perception = linspace(n/16/pi*(1.2)/disc,n/16/pi*(1.2),disc);


for i = 1:disc
    for k = 1:disc
    
        X = PDEsimulation(alpha(i),perception(k));

        file_name = strcat('../data/phase-portrait/pde/PDESim-alpha-',num2str(alpha(i)),'-percep-',num2str(perception(k)),'.mat');

        save(file_name,'X');
    end
end