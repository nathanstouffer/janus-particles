function [S] = entropy(file_name,eps)
%Calculate the entropy of the density map A
%   Takes a file name which holds a density map and calculates
%   the entropy. The eps argument to avoid log(0)

% Load file
A = cell2mat(struct2cell(load(file_name)));

% Grabs size and normalizes
n = size(A); 
total = sum(A,'all');
A = 1/total * A;

% Start entropy at zero
S = 0;

% Calculate entropy
for i = 1:n
    for k = 1:n
        if A(i,k) > eps % If value is big enough we calculate otherwise skip
            S = S + A(i,k)*log(A(i,k));
        end
    end
end

S = -S;
            
end

