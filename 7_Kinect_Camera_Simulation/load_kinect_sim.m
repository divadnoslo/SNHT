%% Load Kinect Sim
% David Olson, 05 Aug 2021

close all
clear all
clc

% Load Proper Folders
addpath('Nav_Functions')

% Initialize Parameters
disp('Initializing Parameters...   ')
kinect_init_params;

% Load Motion Plan
disp('Initializing Wall Attitudes and Locations...   ')
kinect_motion_plan;

% Build Point Clouds
disp('Building Point Clouds...   ')
build_point_clouds;

% Open Simulation
disp('Opening Simulation...   ')
open('kinect_sim')

% % Environment Simulation
% environment_animation;