function C = k2dcm(k)
% Function Description:
%   Converts a 3X1 angle-axis vector k to a 3X3 DCM matrix
%
% INPUTS:
%   k = 3x1 angle-axis vector
%     = theta * e_vector
%     e_vector is the unit axis of rotation and theta the angle of rotation
%   
% OUTPUTS:
%   C = 3x3 direction cosine matrix
%
% NOTES:
%   - Using MATLAB defined eps = 2.2204e-016 as ~ zero
%
% REFERENCE:
%   "Quaterions and Rotation Sequences"
%   by Jack B. Kuipers
%   Section 7.5 page 165 Eqn (7.16) 

theta = sqrt(k(1)^2+k(2)^2+k(3)^2); % Always a positive number

if (theta > eps)            % Check for non-degenerate case: Angle of rotation Non zero
    e1 = k(1)/theta;        % ex - Compute e-vector components
    e2 = k(2)/theta;        % ey
    e3 = k(3)/theta;        % ez
    Ct = cos(theta);
    St = sin(theta);
    V  = 1-Ct;
    
    C  = [  e1*e1*V + Ct,   e1*e2*V-e3*St,  e1*e3*V+e2*St;
            e1*e2*V+e3*St,  e2*e2*V + Ct,   e2*e3*V-e1*St;
            e1*e3*V-e2*St,  e2*e3*V+e1*St,  e3*e3*V + Ct    ];
else
    C = [1,0,0;            % Degenerate case => theta = 0, or 2 n Pi
         0,1,0;
         0,0,1];
end
end % Close function