function [xyz] = depth2xyz_lowRes(depthData, frame)

% Capture the specific frame of interest
depthData = double(depthData);
depthData = depthData(frame, 1:307200);


%% This Section was written by Dr. Gentillini in 2017(?)
%DEPTH2XYZ Converts data from the IR camera of the Qbot2 into XYZ
%coordinates, needs a 480x640x42 array as input.  
%   Detailed explanation goes here later

% Scale Down and Re-size 3-dim array into 2 dimensions
map = reshape(depthData, [480, 640]);
map(map>3000) = 0;
map(map<500) = 0;

% Calculate Angles
thetas = -((1:640) - 320) * 57/640 * pi/180;
gammas = -((1:480) - 240) * 43/480 * pi/180;

% Convert data plot the xyz coordinates per elevation scan
for ii = 1 : 480
    
    Dxs = map(ii,:);
    rho = Dxs./cos(thetas);
    
    % Convert Segment of Data
    x = rho.*cos(thetas);
    y = rho.*sin(thetas);
    z = Dxs*tan(gammas(ii));
    
    % Concatinate Data into one Matrix
    if (ii == 1)
        x_all = x;
        y_all = y;
        z_all = z;
    else
        x_all = [x_all, x];
        y_all = [y_all, y];
        z_all = [z_all, z];
    end
    
end

%% Additional Data Conditioning

% Concatinate and Convert from millimeters to meters
xyz_long = [(x_all ./ 1000); (y_all ./ 1000); (z_all ./ 1000)];
xyz = zeros(3, 3072);

% % Down-Sample to every 100th point
% mask = logical([1, zeros(1,99)]);
% mask = repmat(mask, 3, 3072);
% xyz = xyz(mask);
% xyz = reshape(xyz, [3, 3072]);

% Rotate the Points to align with the Cartesian Frame
% Also, shift up the xyz points so the floor is at z = 0
% Note:  Qbot 2 User Manual states the Kinect Sensor is down by 21.5 deg
ii = 1;
for k = 1 : 100 : length(xyz_long)+1
    
    % For Last Sample
    if (k == length(xyz_long)+1)
        k = 307200;
        if (norm(xyz_long(:,k)) < 0.05)
            for jj = 1 : 99
                if (norm(xyz_long(:,k-jj)) > 0.05)
                    xyz(:,ii) = rotate_y(21.5 * pi/180)*xyz_long(:,k-jj) + [0; 0; 0.2];
                    break
                end
            end
        else
            xyz(:,ii) = rotate_y(21.5 * pi/180)*xyz_long(:,307200) + [0; 0; 0.2];
        end
        
    % Any Selected Sample with a Norm of 0    
    elseif (norm(xyz_long(:,k)) < 0.05)
        for jj = 1 : 99
            if (norm(xyz_long(:,k+jj)) > 0.05)
                xyz(:,ii) = rotate_y(21.5 * pi/180)*xyz_long(:,k+jj) + [0; 0; 0.2];
                break
            end
        end
        
    % Any Sample with a Norm greater than 0.05;    
    else
        xyz(:,ii) = rotate_y(21.5 * pi/180)*xyz_long(:,k) + [0; 0; 0.2];
    end
    
    ii = ii + 1;
    
end





end

