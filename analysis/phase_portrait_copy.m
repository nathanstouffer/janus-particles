function [S] = phase_portrait(directory_name)
%Draws a phase portrait from the .mat files in the desired directory
%   Input a directory name with only .mat files in it

X = dir(directory_name);
n = numel(X);

S = zeros(1,n-2); % Empty entropy vector

A = zeros(1,n-2);
P = zeros(1,n-2);

for k = 3:n
    fin = X(k).name;
    fin = split(fin, '-');
    
    alpha = fin(3);
    alpha = cell2mat(alpha);
    alpha = str2num(alpha);
    alpha = alpha(1);
    
    percep = fin(5);
    percep = split(percep{1},'.mat');
    percep = percep(1);
    percep = str2num(percep{1});
    
    p_scale = (2*alpha*75/(pi*pi));
    
    A(k-2) = alpha;
    P(k-2) = percep/p_scale;
    
    S(k-2) = entropy(strcat(directory_name,"/",X(k).name));
    
    
end

figure;
plot3(A,P,S,'x');

A = unique(A);
P = unique(P);

res = 32;
test = linspace(1.2/res,1.2,32);

figure;
heatmap = reshape(S,sqrt(n-2),sqrt(n-2));
surf(A,test,heatmap);

title('Entropy')
xlabel('Alpha')
ylabel('Perception Threshold')
zlabel('Entropy')

end

