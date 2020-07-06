function [Kernel] = kernel_function(alpha, orientation, size)
    %Takes in an alpha, direction and size argument and outputs Kernel Matrix
    %   --> orientation can only be 0,90,180,360 for the moment
    %   --> alpha needs to be a positive integer and it will correspond
    %   with an angular value of arctan(1/alpha)
    
    % This is just a helpful term
    ID = size/2 +1;
    

    

%% Rest of Function
    % Zero Blocks
    A = zeros(size/2);
    B = zeros(size/2);
    C = zeros(size/2);
    D = zeros(size/2);
    
    count = 0;
    for k = size/2:-1:1
        B(k,(ID-k)+((alpha-1)*count):end) = 1;
        count = count + 1;
    end
    
    % Scales with 1/distance from center
    for i = 1:size/2
        for k = 2:size/2
            B(i,k) = (1/sqrt((0.5*size - i)^2+(k-1)^2))*B(i,k);
        end
    end
    
    % Creates the second half of vision field
    D = flip(B);
    
    %Creates the big Kernel matrix
    Kernel_var = [A B;C D];
    
    % Checks for our four orientations
    if orientation == 90
        Kernel = rot90(Kernel_var,1);
    
    elseif orientation == 180
        Kernel = rot90(Kernel_var,2);
    
    elseif orientation == 270
        Kernel = rot90(Kernel_var,3);
        
    else
        Kernel = Kernel_var;
    end
 
  I = mat2gray(Kernel);
  Kernel = sparse(Kernel)
  figure
  imshow(I)
end