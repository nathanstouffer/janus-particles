%% Runs a batch of PDE Simulations while varying alpha and perception values


n = 75; % Initial particle density
disc = 20; % Discritization

alpha = linspace(0,pi,disc);
perception = linspace(0,n/16/pi,disc);


for i = 1:disc
    for k = 1:disc
    
        X = PDEsimulation(alpha(i),perception(k));

        file_name = strcat('../janus-particles/data/phase-portrait/pde/PDESim-alpha-',num2str(alpha(i)),'-percep-',num2str(perception(k)),'.mat');

        save(file_name,'X');
    end
end

