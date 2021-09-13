function C = rotate_x(theta)
% FUNCTION DESCRIPTION:
%   Realize a rotation about the x-axis by an angle of theta
%
% INPUTS:
%   theta = rotation angle (rad)
%
% OUTPUTS:
%   C   = 3X3 Rotation matrix (dimless)
%
% Example:  C = rotate_x(30 * pi/180) - Rotate by 30° about the x-axis
%
C  = [ 1         ,  0         , 0           
       0         ,  cos(theta), -sin(theta) 
       0         ,  sin(theta),  cos(theta)];
end