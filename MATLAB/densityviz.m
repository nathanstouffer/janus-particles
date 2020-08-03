close all;
clear all;
clc;

%% reading in

prefix = "../data/tmp/n-200_a-0.785_p-6.283_t-31.83098861837907_v-0.0008_d-07.31.2020_t-17.43.14/";
postfix = ".csv";

seq = 5:5:20000;  % these are the files we have
seqlen = length(seq); % how many frames?

% process all files: replace true/false by 1/0 using sed on command line
for i = 1:seqlen
    infilename = prefix + seq(i) + postfix;
    tmpfilename = prefix + "t" + seq(i) + postfix;
    system("sed 's/true/1/gI; s/false/0/gI' < " + infilename + " > " + tmpfilename);
    D{i} = csvread(tmpfilename,1,1);
    system("rm " + tmpfilename);
end

D = cat(3,D{:});


%%

x = round(31.9999*squeeze(1-D(:,2,:))+0.5);  % second MATLAB coordinate, downwards
y = round(31.9999*squeeze(D(:,1,:))+0.5); % first MATLAB coordinate
theta = round(14.99/2/pi*squeeze(D(:,3,:))+0.5);
s = squeeze(D(:,4,:));

phi = linspace(0,360,16);

figure('Name', 'Long term density overall');
rho = full(sparse(x(:),y(:), ones(length(x(:)),1), 32,32));
imagesc(rho);
axis equal;
axis off;


figure('Name', 'Long term density by orientation');
for i = 1:15 
    subplot(4,4,i);
    idx = (theta == i);
    rho = full(sparse(x(idx(:)),y(idx(:)), ones(nnz(idx),1), 32,32));
    imagesc(rho);
    axis equal;
    axis off;
    title("Orientation " + phi(i));
end

figure('Name', 'Long term density by state');
for state = 0:1
    subplot(1,2,state+1);
    idx = (s == state);
    rho = full(sparse(x(idx(:)),y(idx(:)), ones(nnz(idx),1), 32,32));
    imagesc(rho);
    axis equal;
    axis off;
    if state
        title('Active');
    else
        title('Passive');
    end
end
