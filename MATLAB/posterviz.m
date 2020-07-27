clear all;

%% reading in

prefix = "../data/tmp/n-75_a-0.785_p-6.283_t-11.93662073189215_v-0.0012_d-07.23.2020_t-16.53.43/";
postfix = ".csv";

seq = 5:15:2000;  % these are the files we have
seqlen = length(seq); % how many frames?

% process all files: replace true/false by 1/0 using sed on command line
for i = 1:seqlen
    infilename = prefix + seq(i) + postfix;
    tmpfilename = prefix + "t" + seq(i) + postfix;
    system("sed 's/true/1/gI; s/false/0/gI' < " + infilename + " > " + tmpfilename);
    D{i} = csvread(tmpfilename,1,1);
    system("rm " + tmpfilename);
end

% turn cell array into stack / tensor
D = cat(3,D{:});

%% actual visualization
close all;
figure;

myp = 37; %randi(75)  % this is the trajectory # that will be bold

% draw two circles we plot in color trajectories starting outside the
% bigger one
t = 0:0.01:(2*pi);
r1 = 0.225;
r2 = 0.45;
fill(0.5+r1*cos(t),0.5+r1*sin(t),  [.9 .9 .9]); hold on;
plot(0.5+r2*cos(t),0.5+r2*sin(t), 'Color', [.5 .5 .5]); hold on;


% the particles listed in here will be drawn in color, only
actidx = [];

for p = 1:2:75 % only consider odd particles for this
    x = squeeze(D(p,1,:));
    y = squeeze(D(p,2,:));
    if norm([x(1)-0.5,y(1)-0.5]) < r2   % must start far out
        continue;
    end
    active = squeeze(D(p,4,:));  
    if ~any(active)
        continue;
    end
    actidx(end+1) = p; % must be active at least once
end

% plot all trajectories in gray (only every 3rd location, though)
x = squeeze(D(setdiff(1:75, actidx),1,:));
y = squeeze(D(setdiff(1:75, actidx),2,:));
plot(x(:,1:3:end)', y(:,1:3:end)', 'Color', [0.75,.75,.75]);

% for all active particles, plot them in color
for p = actidx
    x = squeeze(D(p,1,:));
    y = squeeze(D(p,2,:));
    active = squeeze(D(p,4,:)); % find when active
    onoff = find(diff(active)); % find when switching
    if onoff(end) < seqlen
        onoff(end+1) = seqlen; % make sure to include the end point
    end
    state = active(1); % initial state
    cur = 1;
    for l = 1:length(onoff)  % switch between states
        if state
            s = [255 179 0]/255; % gold = active
        else
            s = [0 24 155]/255; % blue = inactive
        end
        if p == myp % if it's the chosen particle, draw segment bolder
            plot(x(cur:onoff(l)), y(cur:onoff(l)), 'Color', s, 'LineWidth', 5);
        else
            plot(x(cur:onoff(l)), y(cur:onoff(l)), 'Color', s, 'LineWidth', 1.5);
        end
        cur = onoff(l); % advance pointer within trajectory
        state = ~state; % flip flop state
    end
end

% plot start/end markers for colored particles
x = squeeze(D(actidx,1,:));
y = squeeze(D(actidx,2,:));
plot(x(:,1),y(:,1), 'o', 'Color', [.5 .5 .5], 'MarkerFaceColor', [.5 .5 .5], 'MarkerSize', 18);
plot(x(:,end),y(:,end), 'ko', 'MarkerFaceColor', [0 0 0], 'MarkerSize', 18);

% just some housekeeping
daspect([1 1 1]);
axis equal;
set(gca,'XLim',[0,1], 'YLim', [0,1]);
axis off;

%% matlab2tikz
matlab2tikz('particles.tikz', 'height', '\tikzheight', 'width', '\tikzwidth');