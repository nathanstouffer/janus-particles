%% Runs a batch of PDE Simulations while varying alpha and perception values


n = 75; % Initial particle density
disc = 24; % Discritization

alpha = linspace(pi/disc,pi,disc);

for i = 1:disc
    
    p_c_alpha = 2*alpha(i)*n/pi/pi/64;
    
    perception = [p_c_alpha/20:p_c_alpha/20:1.2*(p_c_alpha)];

    for k = 1:disc
    
        X = PDEsimulation(alpha(i),perception(k),64,30);

        file_name = strcat('../data/phase-portrait/pde/thumbnail-roundthree/PDESim-alpha-',num2str(alpha(i)),'-percep-',num2str(perception(k)),'.mat');

        save(file_name,'X');
        
        disc*(i-1) + k
    end
end

