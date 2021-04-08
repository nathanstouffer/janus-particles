function [c] = sampling(angular_data)
%UNTITLED2 Summary of this function goes here
%   Returns a cell array with down-sampled spatial data. Start with 512
%   angular data from final state.

c = cell(1,6);
c{1} = angular_data;

og = angular_data;

for w = 1:5
    [n,m,t] = size(og);

    temp = zeros(n/2,m/2,t);
    for i=1:t
    
        old = og(:,:,i);
        sz = size(old);
        S = sum(old,'all');
        new = zeros(sz(2)/2,sz(2)/2);
    
        for k = 1:sz(2)/2
            for l = 1:sz(2)/2
                new(k,l) = old(2*k,2*l);
            end
        end
    
        new = new * (S/sum(new,'all'));
        temp(:,:,i) = new;
     end
        

sum(angular_data,'all')
sum(temp,'all')

c{w+1} = temp;
og = temp;

end




end

