%% Angular Convergence Data Generation

angles = [4,8,15,30,60,120];
for i = 1:6
    [A,X] = PDEsimulation_angle(pi/2,2*(pi/2)*75/pi/pi/64,128,angles(i));
    filename = strcat('angular_convergence',num2str(angles(i)),'.mat');
    save(filename,'X')
    filename = strcat('angles_',filename);
    save(filename,'A')
end