function [S] = thumbnailstuff(directory_name)
%Draws a phase portrait from the .mat files in the desired directory
%   Input a directory name with only .mat files in it

X = dir(directory_name);
n = numel(X);

S = zeros(4,n-2); % Empty entropy vector

A = zeros(1,n-2);
P = zeros(1,n-2);

square = sqrt(n-2);


sample = load(strcat(directory_name,"/",X(3).name));
sample = cell2mat(struct2cell(sample));
[l,w,t] = size(sample);

thumbnail = zeros(w,w*(n-2));

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
    
    S(1,k-2) = entropy(strcat(directory_name,"/",X(k).name));
    
    
    temp = load(strcat(directory_name,"/",X(k).name));
    temp = cell2mat(struct2cell(temp));
    temp = temp(:,:,:,end);
    temp = sum(temp,3);
    m = Moments(temp(:,:,end));
    
    S(2:4,k-2) = m';
    thumbnail(:,1+(w*(k-3)):w*(k-2)) = temp(:,:,end);

end

%figure;
%plot3(A,P,S,'x');

% image = zeros(square,square,3);
% image_neg = zeros(square,square,3);
% for i = 1:3
% im = reshape(S(i,:),square,square);
% im = im ./ max(max(im));
% image(:,:,i) = im;
% im = ones(square,square) - im;
% image_neg(:,:,i) = im;
% 
% figure;
% imshow(im)
% end
% figure;
% imshow(image)
% figure;
% imshow(image_neg)

final = zeros(w*square,w*square);


for i = 1:square
    for j = 1:square
        
        
        %final(1:32, 1+32*(j-1): 32*j) = thumbnail(:, (j-1)*square*32 + 1: (j-1)*square*32 + 32);
        
        final(1+w*(square-i):w*(square+1-i), 1+w*(j-1): w*j) = thumbnail(:, (j-1)*square*w + w*(i-1) + 1: (j-1)*square*w + w*(i-1) + w);
        
        %final(1+32*(i-1):32*i,1:32*square) = thumbnail(:,1+(32*square*(i-1)):32*square*i);
        
    end
end


final(final>0.3) = 0.3;
final = final./0.3;

figure;
imagesc(final)

negative = ones(w*square,w*square) - final;
figure;
imshow(negative);
xlabel('Alpha');
ylabel('P*/P_{\alpha}^c')

S = negative;





% res = 32;
% disc_perc = linspace(1.2/res,1.2,32);
% disc_alph = linspace(pi/res,pi,32);
% 
% figure;
% heatmap = zeros(sqrt(n-2),sqrt(n-2));
% for k=1:length(A)
%     i = index_of(P(k), S(k));
%     j = index_of(A(k), S(k));
%     heatmap(i,j) = S(k);
% end
% imagesc(heatmap);
% 
% title('Entropy')
% xlabel('Alpha')
% ylabel('Perception Threshold')
% zlabel('Entropy')
% 
% end
% 
% function i = index_of(vec, val)
%     for i=1:length(vec)
% 	if val < vec(i)
%             break;
% 	end
%     end
% end
