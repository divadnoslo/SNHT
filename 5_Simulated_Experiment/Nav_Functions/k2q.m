function q = k2q(k)
% Function Description:
%   Converts a 3X1 angle-axis vector to a 4X1 quaternion vector q
%
% INPUTS:
%   k = 3x1 angle-axis vector
%     = theta * e_vector
%   where: e_vector is the unit axis of rotation and theta the angle of rotation
%   
% OUTPUTS:
%   q = 4X1 quaternion vector equivalent of the DCM
%     = [q0 q1 q2 q3] Transpose
%   where:  q0 = cos(theta/2) and
%           [q1, q2, q3] = e_vector * sin(theta/2)
%
% NOTES:
%    - Using MATLAB defined eps = 2.2204e-016 as ~ zero
%
% REFERENCE:
%   "Quaterions and Rotation Sequences"
%   by Jack B. Kuipers
%   Section 7.2 page 157

theta = sqrt(k(1)^2+k(2)^2+k(3)^2);

if (theta > eps)     % Check for non-degenerate case: Angle of rotation Non zero
    e_vector = k / theta;
    q = [cos(theta/2); e_vector * sin(theta/2)];
else
    q = [1;0;0;0];  % Degenerate case -> Angle of rotation = 0 or 2 n Pi
end
end % Close function