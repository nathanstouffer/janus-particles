function [c] = spatial_hotstart(pdedata)
%Spatial convergence script hotstarted with sampled annular data
%   Input the pde data from some high resolution run 2^n. Currently will
%   sample the 2^n image and return 2^(n-1),2^(n-2), ... 2^(n-5) sampled
%   images. It rescales them to 

% Creates a cell array to store our data
c = cell(1,6);
c{1} = pdedata;


% Sets pde data as the old data and calculates sum for rescaling
old = pdedata;
S = sum(old,'all');

% Samples until 2^(n-5)
for n = 1:5
    
    % Grab the old array size and initializes new array with 1/2 the size
    sz = size(old);
    new = zeros(sz(1)/2,sz(1)/2);
    temp = zeros(sz(1)/2,sz(2)/2,60);
    
    % Goes through the old array skipping everyother pixel and places them
    % in new array
    for i = 1:sz(1)/2
        for k = 1:sz(2)/2
            new(i,k) = old(2*i,2*k);
        end
    end
    
    % We have to rescale new array to make sure it has a density of 75
    new = new .* (S/sum(new,'all'));
    temp(:,:,1) = new;
    new = temp;
    
    % Stores the sampled array and makes it the old array
    
    c{n+1} = new;
    old = new;
end

% % For display purposes unessecary in final cut. 
% figure;
% for i = 1:6
%     subplot(2,3,i)
%     imagesc(c{i})
%     daspect([1,1,1])
%     xlabel(num2str(sum(c{i},'all')))
% end

for i = 1:5
    sz = size(c{i+1});
    [A,Y] = PDEsimulation_hotstart(pi/2,1,sz(1),60,c{i+1});
    fname = strcat('hotstart_data_',num2str(sz(1)),'.mat');
    save(fname,'Y');
    fname = strcat('angular_',fname);
    save(fname,'A')
end
    


end

