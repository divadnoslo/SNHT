function hg = anim_frame_rot(C_start, C_end, org, label, color)

% Description:
%   Function that animates a starting to ending rotation matrix
%
% Inputs:
%   C_start: Starting 3X3 rotation matrix
%   C_end:   Ending 3X3 rotation matrix
%   label:  an axis label string
%   color:  a choice of color for the axes
%   org:    The location of the common origin of the coordinate frames
%
% Outputs:
%   hg:  handle to the parent object
%

labloc = 1.1;       % Scale factor to locate the axis labels

x_axis = C_start(:,1);    % Extract the x-axis from the DCM
y_axis = C_start(:,2);    % Extract the y-axis from the DCM
z_axis = C_start(:,3);    % Extract the z-axis from the DCM

%
%   Now plot and label the three axes
%
hg = hggroup;           % Create a group object and the handle to that parent

%% Plot the starting coord frame
% Plot a line for the x-axis
ha1 = quiver3(org(1),org(2),org(3),x_axis(1), x_axis(2), x_axis(3), 'Color', color,'Parent',hg);
ht1 = text(labloc*x_axis(1)+org(1), labloc*x_axis(2)+org(2), labloc*x_axis(3)+org(3), ['X_' label] , 'Color', color,'Parent',hg);

% Plot a line for the y-axis
ha2 = quiver3(org(1),org(2),org(3),y_axis(1), y_axis(2), y_axis(3), 'Color', color,'Parent',hg);
ht2 = text(labloc*y_axis(1)+org(1), labloc*y_axis(2)+org(2), labloc*y_axis(3)+org(3), ['Y_' label] , 'Color', color,'Parent',hg);

% Plot a line for the z-axis
ha3 = quiver3(org(1),org(2),org(3),z_axis(1), z_axis(2), z_axis(3), 'Color', color,'Parent',hg);
ht3 = text(labloc*z_axis(1)+org(1), labloc*z_axis(2)+org(2), labloc*z_axis(3)+org(3), ['Z_' label] , 'Color', color,'Parent',hg);

% Label the origin {?}
text(-0.2*z_axis(1)+org(1), -0.2*z_axis(2)+org(2), -0.2*z_axis(3)+org(3), ['\{', label, '\}'] , 'Color', color,'Parent',hg);

%% Now animate the frame

C = C_end * C_start';      % The delta rotation from start to end

% Convert to angle-axis
Tr  = C(1,1)+C(2,2)+C(3,3);     % Trace(C) = 1 + 2Cos(theta)
theta = acos((Tr-1)/2);
k(1)    = (C(3,2) - C(2,3)) /(2 * sin(theta));
k(2)    = (C(1,3) - C(3,1)) /(2 * sin(theta));
k(3)    = (C(2,1) - C(1,2)) /(2 * sin(theta));

for t = 0:1*pi/180:theta        % 1 deg increments
    
    Ct = cos(t);                % Incrementally rotate the frame
    St = sin(t);
    V  = 1-Ct;
    
    dC  = [ k(1)*k(1)*V + Ct,     k(1)*k(2)*V-k(3)*St,  k(1)*k(3)*V+k(2)*St;
            k(1)*k(2)*V+k(3)*St,  k(2)*k(2)*V + Ct,     k(2)*k(3)*V-k(1)*St;
            k(1)*k(3)*V-k(2)*St,  k(2)*k(3)*V+k(1)*St,  k(3)*k(3)*V + Ct    ];

    x_axis = dC * C_start(:,1);    % New x-axis
    y_axis = dC * C_start(:,2);    % New y-axis
    z_axis = dC * C_start(:,3);    % New z-axis
    
    set(ha1, 'UData', x_axis(1), 'VData', x_axis(2), 'WData', x_axis(3)); % Update the x-axis
    set(ht1, 'Position', [labloc*x_axis(1)+org(1), labloc*x_axis(2)+org(2), labloc*x_axis(3)+org(3)]);
    set(ha2, 'UData', y_axis(1), 'VData', y_axis(2), 'WData', y_axis(3)); % Update the y-axis
    set(ht2, 'Position', [labloc*y_axis(1)+org(1), labloc*y_axis(2)+org(2), labloc*y_axis(3)+org(3)]);
    set(ha3, 'UData', z_axis(1), 'VData', z_axis(2), 'WData', z_axis(3)); % Update the z-axis
    set(ht3, 'Position', [labloc*z_axis(1)+org(1), labloc*z_axis(2)+org(2), labloc*z_axis(3)+org(3)]);
    pause(0.2);         % Pause 0.2 seconds pre deg of rotation
end

end % Close the Function