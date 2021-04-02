%% Runs a batch of PDE Simulations while varying alpha and perception values: Hot starts for cohesion phase_portrait


n = 75; % Initial particle density
disc = 10; % Discritization


alpha = linspace(pi/disc,pi,disc); % Alpha spacing

initial = load('cohesion_start16_data.mat');
initial = cell2mat(struct2cell(initial));


for i = 1:disc
    
    p_c_alpha = 2*alpha(i)*n/pi/pi/16;
    
    perception = [p_c_alpha/20:p_c_alpha/20:1.2*(p_c_alpha)];

    for k = 1:disc
    
        [A,X] = PDEsimulation_hotstart(alpha(i),perception(k),16,30,initial);

        file_name = strcat('../data/phase-portrait/pde/cohesion_test/PDESim-alpha-',num2str(alpha(i)),'-percep-',num2str(perception(k)),'.mat');

        save(file_name,'X');
        
        disc*(i-1) + k
    end
end

