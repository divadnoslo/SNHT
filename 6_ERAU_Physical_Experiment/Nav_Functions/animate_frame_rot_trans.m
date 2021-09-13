function hg = animate_frame_rot_trans(C_start, C_end, org, label, colour, trans, frame_delay, scale, rot_trans, chdir)

% Description:
%   Function that animates a starting to ending rotation matrix.  This
%   function always rotates about [0,0,0], hence, the origin will also
%   translate if org not eq to [0,0,0]
%
% Inputs:
%   C_start:    Starting 3X3 rotation matrix
%   C_end:      Ending 3X3 rotation matrix
%   label:      an axis label string
%   color:      Choice of color for the axes
%   org:        The location of the common origin of the coordinate frames
%   trans:      Transparency of the swept plane (same color as axes)
%   delta_t:    Time delay between 1° delta-rotations (sec)
%   scale:      Scale the size of the x/y/z axes (defauly is 1)
%   rot_trans:  If 0 rotate then translate else translate then rotate
%   chdir:      Change the direction of rotation if chdir = 1;
%
% Outputs:
%   hg:  handle to the final frame

% If no colour provided use the default: x -> red, y -> green, & z -> blue
if isempty(colour)
    color(1) = 'r'; color(2) = 'g'; color(3) = 'b';
    color(4) = 'k';     % Axis label color
else
    color(1) = colour; color(2) = colour; color(3) = colour;
    color(4) = colour;  % Axis label color
end

% If no label is provided set to a blank char
if isempty(label)
    label = ' ';
end

% If no scale provided set lengths of x/y/z axes to 1
if isempty(scale)
   scale = 1; 
end

% If no scale provided set lengths of x/y/z axes to 1
if isempty(chdir)
   chdir = 0; 
end

labloc = 1.1;       % Scale factor to locate the axis labels

x_axis = scale*C_start(:,1);    % Extract the x-axis from the DCM
y_axis = scale*C_start(:,2);    % Extract the y-axis from the DCM
z_axis = scale*C_start(:,3);    % Extract the z-axis from the DCM

%   Now plot and label the three axes
hg = hggroup;           % Create a group object and a handle to that parent

% Plot a line and label for the x-axis
ha1 = quiver3(org(1),org(2),org(3),x_axis(1), x_axis(2), x_axis(3), 'Color', color(1), 'autoscale', 'off', 'LineWidth', 2, 'AlignVertexCenters', 'on', 'Parent', hg);
ht1 = text(labloc*x_axis(1)+org(1), labloc*x_axis(2)+org(2), labloc*x_axis(3)+org(3), ['$\vec {x}_{', label, '}$'], ...
      'Color', color(1), 'Interpreter', 'latex', 'HorizontalAlignment', 'center', 'FontSize', 14, 'Parent',hg);

% Plot a line and label for the y-axis
ha2 = quiver3(org(1),org(2),org(3),y_axis(1), y_axis(2), y_axis(3), 'Color', color(2), 'autoscale', 'off', 'LineWidth', 2, 'AlignVertexCenters', 'on', 'Parent', hg);
ht2 = text(labloc*y_axis(1)+org(1), labloc*y_axis(2)+org(2), labloc*y_axis(3)+org(3), ['$\vec {y}_{', label, '}$'], ...
     'Color', color(2), 'Interpreter', 'latex', 'HorizontalAlignment', 'center', 'FontSize', 14, 'Parent',hg);

% Plot a line and label for the z-axis
ha3 = quiver3(org(1),org(2),org(3),z_axis(1), z_axis(2), z_axis(3), 'Color', color(3), 'autoscale', 'off', 'LineWidth', 2, 'AlignVertexCenters', 'on', 'Parent', hg);
ht3 = text(labloc*z_axis(1)+org(1), labloc*z_axis(2)+org(2), labloc*z_axis(3)+org(3), ['$\vec {z}_{', label, '}$'] , ...
    'Color', color(3), 'Interpreter', 'latex',  'HorizontalAlignment', 'center', 'FontSize', 14, 'Parent',hg);

%% Now animate the frame
C = C_end * C_start';               % The delta rotation from start to end
[k, theta] = dcm2k_theta(C);        % Convert delta-rotation to angle-axis

if chdir
    k = -k;
    theta = 2*pi - theta;
end
xdata = org'; ydata = org'; zdata = org'; % For the swept surfaces
hp1 = patch([xdata(1)], [xdata(2)], [xdata(3)], color(4), 'FaceAlpha', trans, 'EdgeColor', 'none', 'Parent', hg);
hp2 = patch([ydata(1)], [xdata(2)], [ydata(3)], color(4), 'FaceAlpha', trans, 'EdgeColor', 'none', 'Parent', hg);
hp3 = patch([zdata(1)], [zdata(2)], [zdata(3)], color(4), 'FaceAlpha', trans, 'EdgeColor', 'none', 'Parent', hg);

for t = 0:1*pi/180:theta            % 1 deg increments
    dC  = k2dcm(k*t);               % Incrementally rotate the frame

    x_axis = scale * dC * C_start(:,1);     % New x-axis
    y_axis = scale * dC * C_start(:,2);     % New y-axis
    z_axis = scale * dC * C_start(:,3);     % New z-axis
    
    set(ha1, 'UData', x_axis(1), 'VData', x_axis(2), 'WData', x_axis(3)); % Update the x-axis
    set(ha2, 'UData', y_axis(1), 'VData', y_axis(2), 'WData', y_axis(3)); % Update the y-axis
    set(ha3, 'UData', z_axis(1), 'VData', z_axis(2), 'WData', z_axis(3)); % Update the z-axis
    
    if rot_trans
        new_org = dC * org;   % Now translate the origin
        set(ha1, 'XData', new_org(1), 'YData', new_org(2), 'ZData', new_org(3)); % Update the x-axis origin
        set(ha2, 'XData', new_org(1), 'YData', new_org(2), 'ZData', new_org(3)); % Update the y-axis origin
        set(ha3, 'XData', new_org(1), 'YData', new_org(2), 'ZData', new_org(3)); % Update the z-axis origin
    else
        new_org = org;
    end
    
    set(ht1, 'Position', [labloc*x_axis(1)+new_org(1), labloc*x_axis(2)+new_org(2), labloc*x_axis(3)+new_org(3)]);
    set(ht2, 'Position', [labloc*y_axis(1)+new_org(1), labloc*y_axis(2)+new_org(2), labloc*y_axis(3)+new_org(3)]);
    set(ht3, 'Position', [labloc*z_axis(1)+new_org(1), labloc*z_axis(2)+new_org(2), labloc*z_axis(3)+new_org(3)]);

    hp1.XData = [hp1.XData; x_axis(1)+org(1)]; hp1.YData = [hp1.YData; x_axis(2)+org(2)];  hp1.ZData = [hp1.ZData; x_axis(3)+org(3)];
    hp2.XData = [hp2.XData; y_axis(1)+org(1)]; hp2.YData = [hp2.YData; y_axis(2)+org(2)];  hp2.ZData = [hp2.ZData; y_axis(3)+org(3)];
    hp3.XData = [hp3.XData; z_axis(1)+org(1)]; hp3.YData = [hp3.YData; z_axis(2)+org(2)];  hp3.ZData = [hp3.ZData; z_axis(3)+org(3)];
        
    pause(frame_delay);             % Pause 0.2 seconds pre deg of rotation
end

end % Close the Function