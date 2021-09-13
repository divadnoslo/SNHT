function C = q2dcm(q)
% Function Description:
%   Converts a 4X1 quaternion vector q to a 3X3 Direction cosine matrix C 
%
% INPUTS:
%   q = 4X1 quaternion vector equivalent of the DCM
%     = [q0 q1 q2 q3] Transpose
%   where:  q0 = cos(Theta/2) and
%           [q1, q2, q3] = e_vector * sin(Theta/2)
%           The e_vector is the 3X1 unit axis of rotation and 
%           Theta is the angle of rotation about e_vector
%   
% OUTPUTS:
%   C = 3x3 direction cosine matrix
%
% NOTES:
%   Using the anle/axis +ve rotation (transpose wrt text)
%
% REFERENCE:
%   "Quaterions and Rotation Sequences"
%   by Jack B. Kuipers
%   Section 7.7 Pages 168

q0 = q(1); q1 = q(2); q2 = q(3); q3 = q(4);

C = [ q0*q0+q1*q1-q2*q2-q3*q3   2*(q1*q2-q0*q3)         2*(q1*q3+q0*q2);
       2*(q1*q2+q0*q3)          q0*q0-q1*q1+q2*q2-q3*q3 2*(q2*q3-q0*q1);
       2*(q1*q3-q0*q2)          2*(q2*q3+q0*q1)         q0*q0-q1*q1-q2*q2+q3*q3];
end % Close function