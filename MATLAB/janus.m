function dy = janus(y, N, phi, Pstar, v, D_phi, D_xy, K, Df, Db, L)
    %Model for Janus Particles
    %   
    
    % Some information about angle species
    theta = linspace(0,2*pi, phi+1);
    h_phi = 2*pi/phi; % angular step in radians


    % Shaping things and setting up arrays
    rho_stack = reshape(y,[N,N,phi]);
    rho = squeeze(num2cell(rho_stack,[1 2]));
    rho_int = sum(cat(3,rho{:}),3);
    
    dy = cell(phi,1);
    for i = 1:phi 
        % The Laplacian Term in space
        rho_xx = L*rho{i} + rho{i}*L; 
        
        % The Angular Diffusion term
        rho_thetatheta = (rho{mod(i-2,phi)+1} - 2*rho{i} + rho{mod(i,phi)+1})/(h_phi*h_phi); 
        
        %Advection Term
        P = conv2(rho_int,K{i},'same'); % Convolution
        f = (P >= Pstar); % Activation
        
        % D*[] is d/dy; []*D is d/dx; u_theta = [cos, -sin]
        u = [cos(theta(i)); -sin(theta(i))];
        if u(1) > 0
            Dx = Db;
        else
            Dx = Df;
        end
        if u(2) > 0
            Dy = Db;
        else
            Dy = Df;
        end
        A = (f.*rho{i})*Dx*u(1) + Dy*(f.*rho{i})*u(2); 
        
        
        % putting it all together
        dy{i} = rho_xx*D_xy - A*v + rho_thetatheta*D_phi;
    end
    
    dy_stack = cat(3,dy{:});
    dy = dy_stack(:);
end