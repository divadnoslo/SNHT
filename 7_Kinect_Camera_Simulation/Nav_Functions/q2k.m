function k = q2k(q)
% Function Description:
%   Converts a 4X1 quaternion vector q to a 3X1 angle-axis vector k
%
% INPUTS:
%   q = 4X1 quaternion vector equivalent of the k vector
%     = [q0 q1 q2 q3] Transpose
%   where:  q0 = cos(theta/2) and
%           [q1, q2, q3] = e_vector * sin(theta/2)
%           e_vector = the 3X1 normalized axis of rotation and 
%           Theta = the angle of rotation about e_vector
%   
% OUTPUTS:
%   k = 3x1 angle-axis vector
%     = theta * e_vector
%
% NOTES:
%    - Using MATLAB defined eps = 2.2204e-016 as ~ zero
%
% REFERENCE:
%   "Quaterions and Rotation Sequences"
%   by Jack B. Kuipers
%   Section 7.2 page 157

q0 = q(1); q1 = q(2); q2 = q(3); q3 = q(4);

sq = sqrt(q1^2+q2^2+q3^2);  % Norm of e_vector * sin(theta/2) = sin(theta/2)

if (sq > eps)               % Check for non-degenerate case: Angle of rotation Non zero
    theta = 2 * atan2(sq , q0); % Determine 4 quadrant angle
    k = theta * [ q1; q2; q3] / sin(theta/2);
else
    k = [0;0;0];            % Degenerate case => theta = 0, or 2 n Pi
end
end % Close function