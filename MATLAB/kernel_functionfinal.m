function [Kernel] = kernel_functionfinal(alpha,orientation,size)
    %Takes an alpha, orientation, and size arguments: Outputs a square kernel
    %matrix of size+1
    % I'm assuming that the size will be even (64,128,256 etc.)
    
    %Just a helpful term that gives us the center
    middle = size/2 + 1;
    
    %Initializes an empty kernel matrix size+1 x size+1 (Now we have an absolute center)
    Kernel = zeros(size+1);
    
    % Initializes a unit vector in the orientation direction
    u_theta = [cos(orientation+pi/2),sin(orientation+pi/2)];
    
    % This loop takes every possible point/pixel and checks to see if it is
    % in the angle alpha away from the u_theta vector
    for i = 1:size+1
        for k = 1:size+1
            x = [i-middle;k-middle];
            x_norm = x/norm(x);
            if acos(dot(u_theta,x_norm)) <= alpha
                Kernel(i,k) = 1;
            end
        end
    end
    
    
    % This loop just scales the whole matrix with the 1/distance from
    % center
    for i = 1:size+1
        for k = 1:size + 1
            if (i == middle) && (k == middle) % That way we don't divide by zero when we check Kernel(middle,middle)
                Kernel(i,k) = 0;
            else
            Kernel(i,k) = (1/sqrt((middle-i)^2+(middle-k)^2))*Kernel(i,k);
            end
        end
    end
    

    
    % Finally we make the kernel sparse to help with space/time etc.
    Kernel = sparse(Kernel);

end