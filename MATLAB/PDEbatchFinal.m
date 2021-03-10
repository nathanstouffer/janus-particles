%% Runs a batch of PDE Simulations while varying alpha and perception values


n = 75; % Initial particle density
disc = 16; % Discritization

alpha = linspace(pi/disc,pi,disc);


for i = 1:disc
    
    p_c_alpha = 2*alpha(i)*n/pi/pi/32;
    
    perception = linspace(p_c_alpha/disc,(1.2)*p_c_alpha,disc);

    for k = 1:disc
    
        X = PDEsimulation(alpha(i),perception(k),16,6);

        file_name = strcat('../data/phase-portrait/pde/sample-run/PDESim-alpha-',num2str(alpha(i)),'-percep-',num2str(perception(k)),'.mat');

        save(file_name,'X');
    end
end