function [Kernel] = kernel_functionfinal(alpha,orientation,N)
    %Takes an alpha, orientation, and size arguments: Outputs a square kernel
    %matrix of size+1
    % I'm assuming that the size will be even (64,128,256 etc.)
    
    %Just a helpful term that gives us the center
    middle = N/2 + 1;
    
    % Initializes a unit vector in the orientation direction
    u_theta = [cos(orientation),sin(orientation)];
    
    coords = (1:N+1) - middle; % Creates an array [-N/2:N/2]
    
    [x,y] = meshgrid(coords); % Creaes two matrices (x and y) with coords

    R = sqrt(x.^2 + y.^2); % Calculates the distances and stores them in a msatrix
    
    Kernel = ((u_theta(1)*x + u_theta(2)*y)./R >= cos(alpha))./R; % Uses alpha to check whether pixels then scales appropriately
    
    
    Kernel(middle,middle) = 0; % Replaces the NaN value in the middle witha  zero

    
    % Finally we make the kernel sparse to help with space/time etc.
    Kernel = sparse(Kernel);

end