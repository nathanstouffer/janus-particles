function dy = janus(y,t)
    %Model for Janus Particles
    %   
    
    % Some parameters we can vary
    sigma = 4; % Activation Threshold
    N = 32; % Resolution
    phi = 100; % Number of Angles
    
    % Some information about angle species
    step = 2*pi/phi;
    theta = 0:step:2*pi-step; % This vector has the angle amount for each species
    
    % Setting up L and div matrices
    Df = spdiags( repmat( [-1 1], N,1 ), [0 1], N, N ); % This is a sparse, NxN matrix where  +/- ones(N,1) are placed on the 0th and 1st diagonal
    Df(end,:) = 0;
    Db = -rot90(Df,2);
    div = -Df'; % Sets up divergence matrix for advection term
    L = (-Df'*Df-Db'*Db)/2; % Laplacian is average of fwd/bwd grad-divergence composition
    
    % Shaping things and setting up arrays
    rho_stack = reshape(y,N,N,phi);
    rho = squeeze(num2cell(rho_stack,[1 2]));
    K = Klibfunc(pi/4,phi,N);
    rho_int = sum(cat(3,rho{:}),3);
    
    dy = cell(1,phi);
    for i = 1:phi 
        rho_xx = L*rho{i} + rho{i}*L; % The Laplacian Term
        rho_thetatheta = rho{mod(i-2,phi)+1} - 2*rho{i} + rho{mod(i,phi)+1}; % The Angular Diffusion term
        
        %Advection Term
        V = conv2(rho_int,full(K{i}),'same'); % Convolution
        f = (V >= sigma); % Activation
        A = div*f*rho{i}*cos(theta(i)) + div*f*rho{i}*sin(theta(i)); 
        dy{i} = rho_xx - A + rho_thetatheta;
    end
    
    dy_stack = cat(3,dy{:});
    dy = dy_stack(:);
end