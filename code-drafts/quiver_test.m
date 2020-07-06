% little test program for particle simulator
NUMPARTICLES = 1000;

% init particles
[x,y,theta] = init_particles(NUMPARTICLES);

% render points
u = cos(theta);
v = sin(theta);
scale = 0.25;
figure
q = quiver(x,y,u,v,scale);
drawnow

% loop on random movements forever
for i = 1:250
    % compute movement updates
    [x,y,theta] = rand_move(x,y,theta);    % random
    %[x,y,theta] = cluster_move(x,y,theta); % cluster
    set_data(q,x,y,theta);
    drawnow    
end

function [x,y,theta] = init_particles(num)
    x = rand(num, 1);
    y = rand(num, 1);
    theta = 2*pi*rand(num, 1);
end

function set_data(q,x,y,theta)
    u = cos(theta);
    v = sin(theta);
    set(q, 'Xdata', x, 'Ydata', y);
    set(q, 'Udata', u, 'Vdata', v);
end

function [x,y,theta] = cluster_move(px,py,ptheta)
    % place current state for now
    x = px;  y = py;  theta = ptheta;
    % fill in constants
    r = 0.1;       % radius of sight
    phi = pi/3;    % field of vision
    thresh = 100;   % threshold number of points seen required to move
    speed = 0.0000005; % velocity magnitude
    % iterate over each particle
    for p = 1:size(px)
        % assign current particle
        cur = [ px(p); py(p) ];
        count = 0; % number of visible particles
        for o = 1:size(px)
            % don't compute for current particle
            if (p ~= o)
                query = [ px(o); py(o) ];
                vis = visible(cur, query, r, px(p), phi);
                if vis
                    count = count + 1;
                end
            end
        end
        if count > thresh
            x(p) = x(p) + speed*cos(theta(p));
            y(p) = y(p) + speed*sin(theta(p));
        end
    end
end

function vis = visible(cur, query, r, theta, phi)
    x_diff = query(1) - cur(1);
    y_diff = query(2) - cur(2);
    d_sqrd = x_diff^2 + y_diff^2;
    if d_sqrd > r^2
        vis = false;
    else
        max = cos(phi);                    % max angle for fov
        dir = [ cos(theta) sin(theta) ];   % direction of particle motion
        gaze = [ x_diff y_diff ];          % direction to query particle
        gaze = gaze / norm(gaze);          % normalize
        if dot(dir, gaze) >= max
            vis = false;
        else
            vis = true;
        end
    end
end

function [x,y,theta] = rand_move(px,py,ptheta)
    % random update
    x = px + normrnd(0,0.0025,size(px));
    y = py + normrnd(0,0.0025,size(py));
    % clamp between 0 and 1
    x = min(1, max(0, x));
    y = min(1, max(0, y));
    theta = ptheta + normrnd(0,0.0001,size(ptheta));
end