function [super] = phase_slice(angle,perception,directory_name)
%phase_slice: Takes a slice from phase-diagram (thumbnail data) and
%processes some of the data.
%   Input one of the two values as 'all'. Eg: phase_slice(angle,'all',directory_name) will
%   take all the perception data corresponding to the alpha input. Best to
%   look up the precise alpha/percep value in the directory (see directory 
%   name). directory_name tells us where to look for the data. For
%   perception right now just input the 24-(row you would like to slice
%   through). Ex: if you wanted to slice through p*/pcalpha = 1 then input
%   20.


% First let's load the directory:
X = dir(directory_name);
n = numel(X);
w = sqrt(n-2); % abuse the fact that our parameter discretization was square.

% Load an example to get some size information
eg = load(strcat(directory_name,'/',X(3).name));
eg = cell2mat(struct2cell(eg));

sz = size(eg);

% Then let's set up a large matrix to store all the data
super = zeros(sz(1),sz(2),sz(3),w);

% Now let's get to work
if perception == 'all'
    
    % Throws an error if both are all
    if angle == 'all'
        str = 'Error: pick an alpha or percep value to slice through'
    end
    
    
    figure;
    count = 0;
    % Loops through the directory (first two elements are . and .. so we exclude them)
    for i = 3:n
        fin = X(i).name;
        fin = split(fin, '-');
    
        alpha = fin(3);
        alpha = cell2mat(alpha);
        alpha = str2num(alpha);
        alpha = alpha(1);
        
        if angle == alpha
            
            count = count + 1; % Update the number of files loaded
            
            temp = load(strcat(directory_name,"/",X(i).name)); % Loads the mat file
            temp = cell2mat(struct2cell(temp));
            
            super(:,:,:,count) = temp; % Stores the data
            
            % Plotting and Visualization
            avg = angavg(temp(:,:,end));
            avg = avg*10; % Density is arbitrary units might as well give us nice numbers
            v = 1:sz(1);
            COM = round(sum(avg.*v)./sum(avg)); % Calculates the center of mass
            plot(v-COM,avg,'Color',[0,0,0]+(1-count/24)) % Shifts COM to zero and plots
            hold on;
            
            xlabel('Micrometers');
            ylabel('Density (a.u.)');

            % Micrometer stuff
            s = 250/sz(1); % Gives us micrometers per pixel

            ticks = [-125/s,-50/s,-25/s,0,25/s,50/s,125/s];

            xticks(ticks);

            xticklabels({'-125','-50','-25','0','25','50','125'});
            
        end
       
        % Breaks the for loop when we reach our last value
        if count == w
            title(strcat('Slice through \alpha = ', num2str(angle)))
            break
        end
            
        
    end
    
elseif angle == 'all'
    
    % Throws an error if both are all
    if perception == 'all'
        str = 'Error: pick an alpha or percep value to slice through'
    end
    
    
     
    
    
    % Sets up a figure to plot in
    figure;
    count = 0;
    % Loops through the directory (first two elements are . and .. so we exclude them)
    for i = 3:n
        fin = X(i).name;
        fin = split(fin, '-');
    
        alpha = fin(3);
        alpha = cell2mat(alpha);
        alpha = str2num(alpha);
        alpha = alpha(1);
        
        % We need to know P_c_alpha so that we can get the right ratio
        p_c_alpha = 2*alpha*75/pi/pi/sz(1); % This 75 needs to concur with sum of the initial density we ran the simulations. Right now hard-coded: could be replaced
        % p_c_alpha = 2*alpha*sum(eg(:,:,end),'all')/pi/pi/sz(1)
        
        % We need to find the p-star that corresponds to the ratio we want
        ratio = perception /20;
        pstar = ratio * p_c_alpha;
        
    
        percep = fin(5);
        percep = split(percep{1},'.mat');
        percep = percep(1);
        percep = str2num(percep{1});
        
        
        if round(percep,4) == round(pstar,4)
            
            count = count + 1; % Updates the count of files loaded
            
            temp = load(strcat(directory_name,"/",X(i).name));
            temp = cell2mat(struct2cell(temp));
            
            super(:,:,:,count) = temp; % Stores the data
            
            % Plotting and Visualization
            avg = angavg(temp(:,:,end));
            avg = avg*10; % Density is arbitrary units might as well give us nice numbers
            v = 1:sz(1);
            COM = round(sum(avg.*v)./sum(avg)); % Calculates the center of mass
            plot(v-COM,avg,'Color',[0,0,0]+(1-count/24)) % Shifts COM to zero and plots
            hold on;
            
            xlabel('Micrometers');
            ylabel('Density (a.u.)');

            % Micrometer stuff
            s = 250/sz(1); % Gives us micrometers per pixel

            ticks = [-125/s,-50/s,-25/s,0,25/s,50/s,125/s];

            xticks(ticks);

            xticklabels({'-125','-50','-25','0','25','50','125'});
        end
        
            
        if count == w % breaks once we hit 20 files loaded.
            title(strcat('Slice through row: ',num2str(24-perception)))
            break
        end
        
    end
    
    
end


end

