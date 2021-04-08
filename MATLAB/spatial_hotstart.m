function [c] = spatial_hotstart(pdedata)
%Spatial convergence script hotstarted with sampled annular data
%   Input the pde data from some high resolution run 2^n. Currently will
%   sample the 2^n image and return 2^(n-1),2^(n-2), ... 2^(n-5) sampled
%   images. It rescales them to 

c = sampling(pdedata);

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
    [Y] = PDEsimulation_hotstart(pi/2,pi*75/pi/pi/sz(1),sz(1),60,c{i+1});
    fname = strcat('hotstart2_data_',num2str(sz(1)),'.mat');
    save(fname,'Y');
end
    


end

