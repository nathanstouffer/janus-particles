function [Kernel] = kernel_functionfinal(alpha,orientation,N)
    %Takes an alpha, orientation, and size arguments: Outputs a square kernel
    %matrix of size+1
    % I'm assuming that the size will be even (64,128,256 etc.)
    
    %Just a helpful term that gives us the center
    middle = N + 1;
    
    % Initializes a unit vector in the orientation direction
    u_theta = [cos(orientation),-sin(orientation)];
    
    coords = (1:2*N+1) - middle; % Creates an array [-N:N]
    
    [x,y] = meshgrid(coords); % Creaes two matrices (x and y) with coords

    R = sqrt(x.^2 + y.^2); % Calculates the distances and stores them in a msatrix
    
    %  <= -cos(alpha) for kernel reflection
    % Uses alpha to check whether pixels then scales appropriately
    Kernel = (((u_theta(1)*x + u_theta(2)*y)./R <= -cos(alpha))./R)/(2*pi); 
    
    Kernel(middle,middle) = 0; % Replaces the NaN value in the middle witha  zero  
    
end