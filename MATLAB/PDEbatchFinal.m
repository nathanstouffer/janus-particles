%% Runs a batch of PDE Simulations while varying alpha and perception values


n = 75; % Initial particle density
disc = 32; % Discritization

alpha = linspace(pi/disc,pi,disc);

for i = disc:-1:1
    
    p_c_alpha = 2*alpha(i)*n/pi/pi/32;
    
    perception = linspace(p_c_alpha/disc,(1.2)*p_c_alpha,disc);

    for k = 1:disc
    
        X = PDEsimulation(alpha(i),perception(k),32,60);

        file_name = strcat('../data/phase-portrait/pde/thumbnail-lowerres/PDESim-alpha-',num2str(alpha(i)),'-percep-',num2str(perception(k)),'.mat');

        save(file_name,'X');
    end
end

