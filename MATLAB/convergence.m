function [Cross] = convergence(PDEdata,hist_resolution,integration_time)
%Plots convergence of agent-based model to the PDE
%   PDEdata should be the file name of the .mat file containing the data
%   hist_resolution should be 32,64,128,256 (possible resolutions for histogram(s))
%   integration-time should be 10000 or 15000
%   Note: for ease of use make sure PDEdata is same size as the histogram

% Initalize stack for data (5 deep: 1 for PDE 4 for agent-based)
stack = zeros(hist_resolution,hist_resolution,5);

%% Load PDE data (we only want the end state)
P = load(PDEdata);
P = cell2mat(struct2cell(P));
stack(:,:,1) = P(:,:,end);

M = max(max(stack(:,:,1)));

%% Load agent-based data
agents = [500,1000,2000,5000];

for i = 1:4
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

%% Plotting Cross-Sections
figure;

cross_sections = zeros(4,hist_resolution);

for i = 1:5
    x = angavg(stack(:,:,i));
    cross_sections(i,:) = x;
end

plot(cross_sections(1,:),'k','Linewidth',2.5);
hold on;

for i = 1:4
    plot(cross_sections(i+1,:),'Color',[0,0,0]+ (0.5-0.1*i),'Linewidth',1);
end

title('Cross-Section Convergence');

Cross = cross_sections;
end

