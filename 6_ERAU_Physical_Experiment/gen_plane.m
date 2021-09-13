function [des_plane] = gen_plane(C, org, dim, n, sigmas)
%PLOT_PLANE plots a plane according to the inputs above
% Inputs
% C - DCM describing the roll pitch and yaw of the desired plane
% dim - a 2 x 2 matrix, [x_min m_max; y_min y_max]
% dx - step size in the x direction
% dy - step size in the y direction
% sigmas - 3 x 1 vector with sigma for white noise added to each point
% color - color of the points to be plotted

%% Build the xy-plane______________________________________________________
x_vec = linspace(dim(1,1), dim(1,2), n);
y_vec = linspace(dim(2,1), dim(2,2), n);

xy_plane = zeros(3, length(x_vec) * length(y_vec));

k = 1;
for ii = 1 : length(x_vec)
    for jj = 1 : length(y_vec)
        xy_plane(1,k) = x_vec(ii);
        xy_plane(2,k) = y_vec(jj);
        k = k + 1;
    end
end

%% Determine the expected rho from the generated plane

des_plane = zeros(3, length(xy_plane));
for k = 1 : length(xy_plane)
    des_plane(:,k) = C * xy_plane(:,k);
end

[yaw, pitch, roll] = dcm2ypr(C);
n = [cos(roll)*sin(pitch); ...
     -sin(roll); ...
     cos(roll)*cos(pitch)];


%% Rotate the xy-plane and add noise_______________________________________

% Add noise to every point, and rotate
des_plane = zeros(3, length(xy_plane));
for k = 1 : length(xy_plane)
    des_plane(:,k) = C * (xy_plane(:,k) + (sigmas .* randn(3,1)));
    des_plane(:,k) = des_plane(:,k) + org';
end

end

