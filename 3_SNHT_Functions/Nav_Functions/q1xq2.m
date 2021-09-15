function q3 = q1xq2(q1, q2)
% Function Description:
%   Computes the "product" of two 4X1 quaternion vectors: q3 = q1 * q2
%
% INPUTS:
%   q1, q2: two 4X1 quaternion vectors
%
% OUTPUTS:
%   q3: a 4X1 quaternion vector
%   q3 = q1 * q2  <- Equivalent to -> C3 = C1 C2
%
% NOTES:
%
% REFERENCE:
%   "Quaterions and Rotation Sequences"
%   by Jack B. Kuipers
%   Section 5.4 Page 109 eqn 5.3

q3 = [q1(1)*q2(1) - q1(2)*q2(2) - q1(3)*q2(3) - q1(4)*q2(4)
      q1(2)*q2(1) + q1(1)*q2(2) - q1(4)*q2(3) + q1(3)*q2(4)
      q1(3)*q2(1) + q1(4)*q2(2) + q1(1)*q2(3) - q1(2)*q2(4)
      q1(4)*q2(1) - q1(3)*q2(2) + q1(2)*q2(3) + q1(1)*q2(4)]; 

q3 = q3/norm(q3);   % Ensure that the quaternion is normalized
end % Close function