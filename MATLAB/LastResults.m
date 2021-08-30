%% Quick run simulations and then save them

rho_0 = load('./cohesion_start_64_data.mat');
rho_0 = cell2mat(struct2cell(rho_0));

alpha = linspace(pi/24,pi,24);

%% Simulation 1
p_c_alpha = 2*alpha(end)*75/pi/pi/64;
perception = [p_c_alpha/20:p_c_alpha/20:1.2*p_c_alpha];
percep = perception(end);
X = PDEsimulation_hotstart(alpha(end),percep,64,30,rho_0);

save('./corner_data.mat','X');

%% Simulation 2
p_c_alpha = 2*alpha(end-1)*75/pi/pi/64;
perception = [p_c_alpha/20:p_c_alpha/20:1.2*p_c_alpha];
percep = perception(end-1);
X = PDEsimulation_hotstart(alpha(end-1),percep,64,30,rho_0);

save('./newF_data.mat','X');

%% Simulation 3
p_c_alpha = 2*alpha(end-2)*75/pi/pi/64;
perception = [p_c_alpha/20:p_c_alpha/20:1.2*p_c_alpha];
percep = perception(end-1);
X = PDEsimulation_hotstart(alpha(end-2),percep,64,30,rho_0);

save('./newG_data.mat','X');

