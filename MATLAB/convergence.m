function [] = convergence(PDEdata,hist_resolution,integration_time)
%Plots convergence of agent-based model to the PDE
%   PDEdata should be the file name of the .mat file containing the data
%   hist_resolution should be 32,64,128,256 (possible resolutions for histogram(s))
%   integration-time should be 10000 or 15000
%   Note: for ease of use make sure PDEdata is same size as the histogram

% Initalize stack for data (9 deep: 1 for PDE 8 for agent-based)
stack = zeros(hist_resolution,hist_resolution,9);

% Load PDE data (we only want the end state)
P = load(PDEdata);
P = cell2mat(struct2cell(P));
stack(:,:,1) = P(:,:,end);

M = max(max(stack(:,:,1)));

% Load agent-based data
agents = [50,75,100,200,500,1000,2000,5000];

for i = 1:8
    file_name = strcat('../data/convergence_d-03.01.2021_t-15.20.03/hists/n',num2str(agents(i)),'_t',num2str(integration_time),'_res',num2str(hist_resolution),'.mat');
    A = load(file_name);
    A = cell2mat(struct2cell(A));
    
    % Rescale into 0-1
    s = sum(A,'all');
  
    scaling_factor = s/75;
    
    A = A./scaling_factor;
    
    % Put them in the stack
    stack(:,:,i+1) = A;
end

% Plotting Cross-Sections
figure;

x = COMcross(stack(:,:,1));
plot(stack(x,:,1),'k', 'Linewidth',2);
hold on;

for i = 1:8
    x = COMcross(stack(:,:,i+1));
    plot(stack(x,:,i+1),'Color',[0,0,0]+ 0.5,'Linewidth',1);
end

title('Cross-Section Convergence');


end

