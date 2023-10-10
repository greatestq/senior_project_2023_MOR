clear all; clc;
load('Vel.mat'); %Load Velocity Data
load('X.mat'); %Load Grid Coordinates

%% SVD
[U,S,V] = svd(Vel); %SVD

%% Coordinates Reconstruction for Contour Plots
xCoords = X(1:2:end); %X coordinates of Grid
yCoords = X(2:2:end); %Y coordinates of Grid

%% Variables to change
timeStep = 10; %Change this to view different time steps (1 to 250)
r = 3; %Change this to change the number of modes you want to include

U_r = U(:, 1:r);
S_r = S(1:r, 1:r);
V_r = V(:, 1:r);
V_hat = U_r * S_r * V_r'; %This contains the reconstructed velocity data

%% Interpolation
[xq, yq] = meshgrid(linspace(min(xCoords),max(xCoords),100), linspace(min(yCoords), max(yCoords),100));
uReconstructed = V_hat(1:2:end, timeStep); % x direction velocity reconstructed
vReconstructed = V_hat(2:2:end, timeStep); % y direction velocity reconstructed
uGrid = griddata(xCoords, yCoords, uReconstructed, xq, yq, 'linear'); % u interpolation 
vGrid = griddata(xCoords, yCoords, vReconstructed, xq, yq, 'linear'); % v interpolation
energyGrid = 0.5 * (uGrid.^2 + vGrid.^2); % energy interpolation

[dudx, dudy] = gradient(uGrid); 
[dvdx, dvdy] = gradient(vGrid);
vorticityGrid = dvdx - dudy; %vorticity 

%% Contour Plots
figure;
subplot(1,2,1);
contourf(xq, yq, uGrid, 50);
colorbar;
title('Reconstructed U-Velocity Contour Plot');
xlabel('X Coordinate'); ylabel('Y Coordinate');

subplot(1,2,2);
contourf(xq,yq,vGrid,50);
colorbar;
title('Reconstructed V-Velocity Contour Plot');
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

%% Energy Plot
% Extract singular values
singularValues = diag(S);

% Calculate energy of each mode
energyModes = singularValues.^2;

% Calculate cumulative energy
cumulativeEnergy = cumsum(energyModes);

% Normalize by total energy to get a relative measure
relativeCumulativeEnergy = cumulativeEnergy / cumulativeEnergy(end);

% Plot
figure;
plot(relativeCumulativeEnergy, '-o', 'LineWidth', 2);
xlabel('Number of Modes');
ylabel('Normalized Cumulative Energy');
title('Normalized Cumulative Energy of POD Modes');
grid on;

% To highlight how many modes are needed to capture a specific amount of energy
% For example, to capture 95% of the energy:
threshold = 0.98;
nModes95 = find(relativeCumulativeEnergy >= threshold, 1);
hold on;
plot(nModes95, threshold, 'ro');
text(nModes95, threshold + 0.02, sprintf('First %d modes capture 98%% energy', nModes95));