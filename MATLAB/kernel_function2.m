function [Kernel] = kernel_function2(alpha, orientation, size)
    %Takes in an alpha, direction and size argument and outputs Kernel Matrix
    %   --> orientation can be anything
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
    
    % Scales with 1/distance from origin of sight
    for i = 1:size/2
        for k = 2:size/2
            B(i,k) = (1/sqrt((0.5*size - i)^2+(k-1)^2))*B(i,k);
        end
    end
    
    % Creates the second half of vision field
    D = flip(B);
    
    %Creates the big Kernel matrix
    Kern = [A B;C D];
    Kernel = sparse(Kern)
    
    %Turns the Kern into a grey-scale image
    I = mat2gray(Kern);
  
    %Rotates that image to the proper orientation
    J = imrotate(I,orientation);
  
    %These just show the images (Not actually needed just nice to
    %(see/check)
    figure
    imshow(I)
    figure
    imshow(J)

end