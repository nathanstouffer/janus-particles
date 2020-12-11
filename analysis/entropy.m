function [S] = entropy(file_name)
%Calculate the entropy of the density map A
%   Takes a file name which holds a density map and calculates
%   the entropy. The eps argument to avoid log(0)

% Load file
A = cell2mat(struct2cell(load(file_name)));

% Grabs size and normalizes
n = max(size(A)); 
total = sum(A,'all');
A = 1/total * A;

% Reshape the matrix
A = reshape(A,1,n^2);

% Remove zeros from the matrix
A = A(A~=0);

% Start entropy at zero
S = 0;

% Calculate entropy
for i = 1:length(A)
    S = S + A(i)*log(A(i));
end

S = -S;
            
end

