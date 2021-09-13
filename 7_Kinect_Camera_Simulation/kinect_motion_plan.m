%% Kinect Motion Plan
% David Olson, 05 Aug 2021

% 3 Modes of Transportation
% Mode 1 - Stationary (num = # of seconds to pause)
% Mode 2 - Rotate in Place (num = (+/-)# of seconds to turn) (All turns are 90
% deg, (negative is left, positive is right)
% Mode 3 - Straight-Forward Motion (num = # of seconds to drive forward)

% IMPORTANT NOTE:  The first two steps of the motion plan must be:
% P.qbot2_motion_plan = {"Mode 1", 10; ...
%                        "Mode 3", #};
% This is to stay consistent with all hardware testing!

%% Set Kinect Motion Plan

% Set Plan For Qbot 2 Motion

% P.qbot2_motion_plan = {"Mode 1", 3};

P.qbot2_motion_plan = {"Mode 1",  1; ...
                       "Mode 3",  4; ...
                       "Mode 2",  5; ...
                       "Mode 3",  5}; %...
%                        "Mode 2",  10; ...
%                        "Mode 3",  10; ...
%                        "Mode 2",  10; ...
%                        "Mode 3",  10; ...
%                        "Mode 2",  10; ...
%                        "Mode 1",  10};

%% Set Wall Appearance Motion Plan

% Determine Number of Steps
[num_steps, ~] = size(P.qbot2_motion_plan); 

% Set Initial Conditions
wall_psi_k_1 = [999; 999];
org_k_1 = zeros(6,1);
P.wall_psi = [];
P.org = [];
P.mode = [];

for k = 1 : num_steps
    
    % Mode 1 - Stationary Motion
    if (P.qbot2_motion_plan{k,1} == "Mode 1")
        [mode_k, wall_psi_k, org_k] = mode_1(k, ...
                                             wall_psi_k_1, ...
                                             org_k_1, ...
                                             P);
    
     % Mode 2 - Rotate in Place   
    elseif (P.qbot2_motion_plan{k,1} == "Mode 2")
        [mode_k, wall_psi_k, org_k] = mode_2(k, ...
                                             wall_psi_k_1, ...
                                             org_k_1, ...
                                             P);
    
    % Mode 3 - Stationary Motion    
    elseif (P.qbot2_motion_plan{k,1} == "Mode 3")
        [mode_k, wall_psi_k, org_k] = mode_3(k, ...
                                             wall_psi_k_1, ...
                                             org_k_1, ...
                                             P);
    
    % Error Catch    
    else
        error('Motion Plan does not exist, check your spelling')
    end
    
    % Concatinate Results Together
    P.wall_psi = [P.wall_psi, wall_psi_k];
    P.org = [P.org, org_k];
    P.mode = [P.mode, mode_k];
    
    % Step Current Step to Previous Step
    wall_psi_k_1 = wall_psi_k;
    org_k_1 = org_k;
    
end

% Set Simulation Run Time
[~, P.t_end] = size(P.wall_psi);

%% Clear Unneeded Variables
clear num_steps wall_psi_k wall_psi_k_1 org_k org_k_1 mode_k k

P = rmfield(P, 'qbot2_motion_plan');

 %% Mode 1 - Stationary Motion
 
 function [mode_k, wall_psi_k, org_k] = mode_1(k, wall_psi_k_1, org_k_1, P)
 
 % Determine number of steps
 n = P.qbot2_motion_plan{k,2};
 
 % If First Time Step
 if (k == 1)
     wall_psi_k = [999 * ones(1,n); ...
                   zeros(1,n)];          
     org_k = [repmat([0; 0; 0], 1, n); ...
              repmat([1; 1; 0], 1, n)];
 
 % All Other Time Steps            
 else
     wall_psi_k = repmat(wall_psi_k_1(:,end), 1, n);
     org_k = repmat(org_k_1(:,end), 1, n);
 end
 
 mode_k = ones(1,n);
 
 end
 
 %% Mode 2 - Rotate In Place
 
 function [mode_k, wall_psi_k, org_k] = mode_2(k, wall_psi_k_1, org_k_1, P)
 
 % Determine number of steps
 n = P.qbot2_motion_plan{k,2};
 
  % Determine Rotation Direction
 dir = sign(n);
 
 % Set Abs(n)
 n = abs(n);
 
 % Set the Mode
 mode_k = 2 * ones(1,n);

 % Create Heading Vector
 psi = linspace(0, dir * pi/2, n);
 
 % Pre-allocate
 wall_psi_k = zeros(2,n);
 
 % Build the Front Wall Rotation
 wall_psi_k(1,:) = psi;
 
 % Build the Side Wall Rotation
 wall_psi_k(2,:) = psi;
 n_stop = floor(1/2 * n);
 wall_psi_k(2,n_stop+1:end) = 999;
 
 % Set the Origins
 for k = 1 : length(psi)
     org_k(1:3,k) = rotate_z(psi(k)) * org_k_1(1:3,end);
     org_k(4:6,k) = rotate_z(psi(k)) * org_k_1(4:6,end);
 end
 
 end
 
%% Mode 3 - Straight-Forward Motion

function [mode_k, wall_psi_k, org_k] = mode_3(k, wall_psi_k_1, org_k_1, P)

 % Determine number of steps
 n = P.qbot2_motion_plan{k,2};
 
 % Set Mode
 mode_k = 3 * ones(1,n);
 
 % Pre-Allocate
 wall_psi_k = 999 * ones(2,n);
 org_k = zeros(6,n);
 
 % Build Side Wall Rotation
 wall_psi_k(2,:) = 0;
 
 % Handle Front Wall
 n_start = ceil(n/2);
 n_front = length(wall_psi_k(1, n_start:end));
 wall_psi_k(1,n_start:end) = 0;
 
 org_k = [repmat([0; 0; 0], 1, n); ...
              repmat([1; 1; 0], 1, n)];
 org_k(1,n_start:end) = linspace(2.5, 1.5, n_front);      

 
end