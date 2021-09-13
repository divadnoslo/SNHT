%% Environment Animation
% David Olson, 06 Aug 2021

% Provides an animation of the environment at each time step

%% Set Animation Paramters

figure
tiledlayout(2,2)

psi = P.psi_search;
rho = P.rho_search;

%% Run the Animation


for k = 1 : P.t_end
    
    %______________________________________________________________________
    %% XYZ Point Cloud Plotting
    
    % Plot on Correct Tile
    nexttile(1)
    
    % Pull out relevant points of the point cloud
    mask = sum(P.xyz(:,:,k)) ~= 0;
    xyz = P.xyz(:,mask,k);
    
    % Plot Environment
    plot3(xyz(1,:), xyz(2,:), xyz(3,:), 'b.')
    viscircles([0,0], 0.25, 'Color', 'k', 'LineWidth', 2.5);
    
    % Plot Useful Information
    xlabel('X (m)')
    xlim([-0.5, 3])
    ylabel('Y (m)')
    ylim([-2, 2])
    view(-90, 90)
    title_str = ['XYZ Point Cloud @ t = ', num2str(k), ...
                 's, mode = ', num2str(P.mode(k))];
    title(title_str)
    grid on
    
    %______________________________________________________________________
    %% Psi Histogram
    
    % Plot on Correct Tile
    nexttile(2)
    
    % Plot the Resulting Joint Probability for Psi and Rho
    [X1, Y1] = meshgrid(psi * 180/pi, rho);
    s = surf(X1', Y1', psi_hist(:,:,k));
    title('Joint Probability p_\psi_\rho(\psi,\rho)')
    xlabel('\psi (\circ)')
    ylabel('\rho')
    grid on
    
    %______________________________________________________________________
    %% Rho PMF
    
    % Plot on Correct Tile
    nexttile(3)
    
    plot(rho, rho_pmf(k,:), 'k')
    title(['PMF of \rho, \rho_M_L = ', num2str(rho_mode(k))])
    xlabel('\rho (meters)')
    ylabel('p(\rho)')
    grid on
    
    
    %______________________________________________________________________
    %% Psi Conditional Slice
    
    % Plot on Correct Tile
    nexttile(4)
    
    plot(psi * 180/pi, psi_cond_slice(k,:), 'b')
%     line([x(1) x(1)], [0 y(1)], 'Color', 'r')
%     line([x(2) x(2)], [0 y(2)], 'Color', 'r')
    mode_str = ['\psi_M_L = ', num2str(psi_mode(k) * 180/pi), '\circ '];
    std_dev_str = ['\sigma_\psi = ', num2str(sqrt(psi_var(k)) * 180/pi), '\circ'];
    title(['p_\psi_|_\rho(\psi|\rho = ', num2str(rho_mode(k)), ') ', mode_str, std_dev_str])    
    xlabel('\psi (\circ)')
    xlim([psi(1), psi(end)] * 180/pi)
    ylabel(['p_\psi_|_\rho(\psi|\rho = ', num2str(rho_mode(k)), ')'])
    grid on
    
    % Pause for Animation
    if (k ~= P.t_end)
        dummy = input('Hit <enter> when ready to proceed! ', 's');
    end
    
end
    
    