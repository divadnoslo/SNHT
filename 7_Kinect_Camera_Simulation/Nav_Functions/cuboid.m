function [hp] = cuboid(org, len, colour, transp)

% Description:
%   Function that plots a 3D cuboid
%
% Inputs:
%   org:    The [x,y,z] location of the origin of the coordinate frame 
%   len:    A 3-vector defining the length in the x, y, and z directions
%   colour: A choice of color for the axes (defaults to rgb)
%   transp: The transparency of the cuboid: A scalar from 0 to 1
%
% Outputs:
%   hg:     Handle to the cuboid graphic object
%
% Example: 
%   cuboid([0,0,0], [1,2,3], 'r', 0.5);
% 
% Reference:
%   www.mathworks.com/help/matlab/visualize/multifaceted-patches.html

% Define the eight vertices
vert = [0 1 1 0 0 1 1 0     % X-coords
        0 0 1 1 0 0 1 1     % Y-coords
        0 0 0 0 1 1 1 1];   % Z-coords

% Scale the lengths and translate the origin
vert = [vert(1,:)*len(1) + org(1)
        vert(2,:)*len(2) + org(2)
        vert(3,:)*len(3) + org(3)]';
    
% Define the six faces    
fac = [1 2 6 5      % Face #1
       2 3 7 6      % Face #2
       3 4 8 7
       4 1 5 8
       1 2 3 4
       5 6 7 8];    % Face #6

% Create a handle to the patch   
hp = patch('Vertices', vert, 'Faces', fac, 'FaceColor', colour, 'FaceAlpha', transp, 'EdgeColor', [0.1, 0.1, 0.1], 'EdgeAlpha', 0.5);
  
end