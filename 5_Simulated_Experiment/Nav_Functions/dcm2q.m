function q = dcm2q(C)
% Function Description:
%   Converts a 3X3 Direction cosine matrix C to 4X1 quaternion vector q
%
% INPUTS:
%   C = 3x3 direction cosine matrix
%
% OUTPUTS:
%   q = 4X1 quaternion vector equivalent of the DCM
%     = [q0 q1 q2 q3] Transpose
%   where:  q0 = cos(theta/2) and
%           [q1, q2, q3] = e_vector * sin(theta/2)
%           The e_vector is the 3X1 unit axis of rotation and 
%           Theta is the angle of rotation about e_vector
%
% NOTES:
%   The algorithm uses the largest element of q to compute the others
%
% REFERENCE:
%   "Quaterions and Rotation Sequences"
%   by Jack B. Kuipers
%   Section 7.9 Pages 168-9

Tr0 =  C(1,1) + C(2,2) + C(3,3);    % = 4 qo^2 - 1
Tr1 =  C(1,1) - C(2,2) - C(3,3);    % = 4 q1^2 - 1
Tr2 = -C(1,1) + C(2,2) - C(3,3);    % = 4 q2^2 - 1
Tr3 = -C(1,1) - C(2,2) + C(3,3);    % = 4 q3^2 - 1

[Trn,i] = max([Tr0, Tr1, Tr2, Tr3]);
qn      = sqrt(Trn+1)/2;

switch i
 case 1  % Qn = q0
  q = [qn; (C(3,2)-C(2,3))/(4*qn); (C(1,3)-C(3,1))/(4*qn); (C(2,1)-C(1,2))/(4*qn)];
 case 2  % Qn = q1
  q = [(C(3,2)-C(2,3))/(4*qn); qn; (C(2,1)+C(1,2))/(4*qn); (C(1,3)+C(3,1))/(4*qn)];
 case 3  % Qn = q2
  q = [(C(1,3)-C(3,1))/(4*qn); (C(2,1)+C(1,2))/(4*qn); qn; (C(3,2)+C(2,3))/(4*qn)];
 case 4  % Qn = q3
  q = [(C(2,1)-C(1,2))/(4*qn); (C(1,3)+C(3,1))/(4*qn); (C(3,2)+C(2,3))/(4*qn); qn];
end       
end % Close function