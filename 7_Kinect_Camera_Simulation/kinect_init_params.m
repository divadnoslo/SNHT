%% Kinect Initial Parameters
% David Olson, 05 Aug 2021

%% Set Simulation Constants
P.Fs = 1;
P.dt = 1 / P.Fs;

%% Set Side Wall Plane Constants

% C = rotate_z(psi) * rotate_y(pi/2);
P.side_wall.dim = 1 * [-1 0; -0.5 0.5];
P.side_wall.dx = 0.025; 
P.side_wall.dy = 0.025;
P.side_wall.sigmas = [0.01; 0.01; 0.02];

%% Set Front Wall Plane Constants

% C = rotate_z(psi) * rotate_y(pi/2);
P.front_wall.dim = 1 * [-1 0; -1 1];
P.front_wall.dx = 0.01; 
P.front_wall.dy = 0.01;
P.front_wall.sigmas = [0.01; 0.01; 0.02];

%% Set SNHT Search Parameters

% Psi Search Parameters
P.psi_search = [-135 : 1 : 135] * pi/180;
P.psi_search_size = length(P.psi_search); 

% Rho Search Parameters
P.rho_search = [-5 : 0.01 : 5]; % DO NOT ADJUST THE 0.01 VALUE
P.rho_search_size = length(P.rho_search);

% Define Starting Histogram because Simulink sucks butt
P.psi_hist_start = zeros(P.psi_search_size, P.rho_search_size);