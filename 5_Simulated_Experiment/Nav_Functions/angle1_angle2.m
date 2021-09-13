function angle_diff = angle1_angle2(angle1, angle2)
% This function computes the minimum difference between two angles using the form:
%   angle_diff = angle1 - angle2
%
% Inputs:
%   angle1: angle 1 (rad)
%   angle2: angle 2 (rad)
%
% Outputs:
%   angle_diff: angle differecnce (rad)
%
% Notes:
%   - The inputs are forced into the interval [0,2pi)
%   - The output is the angle with magnitude < pi

angle1 = mod(angle1, 2 * pi); % Start with 0 < angle < 2pi representation
angle2 = mod(angle2, 2 * pi); % Start with 0 < angle < 2pi representation

if abs(angle1 - angle2) < pi
	angle_diff = angle1 - angle2;
else
	if abs((angle1 + 2*pi) - angle2) < abs(angle1 - (angle2 + 2*pi))
		angle_diff = (angle1 + 2*pi) - angle2;
	else
		angle_diff = angle1 - (angle2 + 2*pi);
	end
end

end % end of angle1_angle2