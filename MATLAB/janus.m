function dy = janus(y, N, phi, sigma, v, D_phi, D_xy, K, D, L)
    %Model for Janus Particles
    %   
    
    % Some information about angle species
    theta = linspace(0,2*pi, phi+1);
    

    % Shaping things and setting up arrays
    rho_stack = reshape(y,[N,N,phi]);
    rho = squeeze(num2cell(rho_stack,[1 2]));
    rho_int = sum(cat(3,rho{:}),3);
    
    dy = cell(phi,1);
    for i = 1:phi 
        % The Laplacian Term in space
        rho_xx = L*rho{i} + rho{i}*L; 
        
        % The Angular Diffusion term
        rho_thetatheta = rho{mod(i-2,phi)+1} - 2*rho{i} + rho{mod(i,phi)+1}; 
        
        %Advection Term
        V = conv2(rho_int,K{i},'same'); % Convolution
        f = (V >= sigma); % Activation
        
        A = D*(f.*rho{i})*cos(theta(i)) + (f.*rho{i})*D*sin(theta(i)); 
        
        
        % putting it all together
        dy{i} = rho_xx*D_xy - A*v + rho_thetatheta*D_phi;
    end
    
    dy_stack = cat(3,dy{:});
    dy = dy_stack(:);
end