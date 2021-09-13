function u = qxvec(q, v)
% Function Description:
%   Computes the "product" a 4X1 quaternion vector with a 3X1 vector
%
% INPUTS:
%   q: a 4X1 quaternion vector
%   v: a 3X1 vector (typically angular or linear velocity)
%
% OUTPUTS:
%   u:  a 3X1 vector (typically angular or linear velocity)
%     [0,u] = q [0,v] q* <- Equivalent to -> u = C v   
%
% NOTES:
%   Realize that q [0,v] q* <==> Q v
%
% REFERENCE:
%   "Quaterions and Rotation Sequences"
%   by Jack B. Kuipers
%   Section 5.14 Page 126 eqn 5.11

if isrow(v)
    error('v must be a 3x1 col vector!!');
end

q0 = q(1); q1 = q(2); q2 = q(3); q3 = q(4); 

Q = [(2*(q0^2+q1^2)-1), 2*(q1*q2-q0*q3)  , 2*(q1*q3+q0*q2)
      2*(q1*q2+q0*q3) , (2*(q0^2+q2^2)-1), 2*(q2*q3-q0*q1)
      2*(q1*q3-q0*q2) , 2*(q2*q3+q0*q1)  , (2*(q0^2+q3^2)-1)];

u = Q * v;
end % Close function