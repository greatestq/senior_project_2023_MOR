clear all; clc;
load('Vel.mat'); %Load Velocity Data
load('X.mat'); %Load Grid Coordinates

%% Coordinates Reconstruction for Contour Plots
xCoords = X(1:2:end); %X coordinates of Grid
yCoords = X(2:2:end); %Y coordinates of Grid

%% Variables to change
timeStep = 10; %Change this to view different time steps (1 to 250)

%% Interpolation
[xq, yq] = meshgrid(linspace(min(xCoords),max(xCoords),100), linspace(min(yCoords), max(yCoords),100));
u = Vel(1:2:end, timeStep); % x direction velocity reconstructed
v = Vel(2:2:end, timeStep); % y direction velocity reconstructed
uGrid = griddata(xCoords, yCoords, u, xq, yq, 'linear'); % u interpolation 
vGrid = griddata(xCoords, yCoords, v, xq, yq, 'linear'); % v interpolation
energyGrid = 0.5 * (uGrid.^2 + vGrid.^2); % energy interpolation

[dudx, dudy] = gradient(uGrid); 
[dvdx, dvdy] = gradient(vGrid);
vorticityGrid = dvdx - dudy; %vorticity 

%% Contour Plots
figure;
subplot(1,2,1);
contourf(xq, yq, uGrid, 50);
colorbar;
title('U-Velocity Contour Plot');
xlabel('X Coordinate'); ylabel('Y Coordinate');

subplot(1,2,2);
contourf(xq,yq,vGrid,50);
colorbar;
title('V-Velocity Contour Plot');
xlabel('X Coordinate'); ylabel('Y Coordinate');

figure;
contourf(xq, yq, energyGrid, 50);
colorbar;
title('Kinetic Energy Contour Plot');
xlabel('X Coordinate'); ylabel('Y Coordinate');

figure;
contourf(xq, yq, vorticityGrid, 50);
colorbar;
title('Vorticty Contour Plot');
xlabel('X Coordinate');
ylabel('Y Coordinate');
