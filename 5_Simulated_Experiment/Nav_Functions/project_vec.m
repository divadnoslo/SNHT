function [hp] = project_vec(vec, colour, transp)

% Description:
%   Function that plots a 3D projection of a vector onto the 3-axes
%
% Inputs:
%   vec:    A 3-vector in the x, y, and z directions
%   colour: A choice of color for the projections (defaults to rgb)
%   transp: The transparency of the plot: A scalar from 0 to 1
%
% Outputs:
%   hg:     Handle to the cuboid graphic object
%
% Example: 
%   project_vec([1,2,3], 'r', 0.5);
% 
% Reference:
%   www.mathworks.com/help/matlab/visualize/multifaceted-patches.html

% Define the eight vertices
vert = [0 1 1 0 1     % X-coords
        0 0 1 1 1     % Y-coords
        0 0 0 0 1];   % Z-coords

% Scale the lengths and translate the origin
vert = [vert(1,:)*vec(1)
        vert(2,:)*vec(2)
        vert(3,:)*vec(3)]';
    
% Define the six faces    
fac = [1 2 3 4      % Face #1
       1 3 5 1];    % Face #2

% Create a handle to the patch   
hp = patch('Vertices', vert, 'Faces', fac, 'FaceColor', colour, 'FaceAlpha', transp, ...
    'EdgeColor', [0.1, 0.1, 0.1], 'EdgeAlpha', 0.5, 'LineStyle', '--');
  
end