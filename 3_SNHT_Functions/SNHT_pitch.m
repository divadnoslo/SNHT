function [theta_ML, theta_var] = SNHT_pitch(xyz, plot_flag)
% 
% SNHT_wall runs the Surface Normal Hough Transform (SNHT) algorithm on a
% given <x,y,z> point cloud for a provided search space.  
%
% THIS IS A VECTORIZED VERSION OF THE CODE!!!
%
% Inputs:
% xyz - an unorganized list of <x,y,z> points; size(3, <num_points>)
% theta_params - [theta_l, d_theta, theta_ub], defines the lower bound, step size,
% and upper bound of the search space for theta.  Input as radians!
% plot_flag - true/false for plots of the joint probabilities and pmf's
% 
% Outputs:
% theta_ML - the most likely value of theta, radians
% theta_var - the variance of theta, in radians
%
%__________________________________________________________________________
%% Complete a Fine Search

% XYZ Points
K = length(xyz);

% theta bins
d_theta = 0.025 * pi/180;
theta = (-20 * pi/180) : d_theta : (20 * pi/180);
M = length(theta); 

%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Tranform Each XYZ Point to the Hough Space
% Each Matrix is sized M x K

% Build X  & Y Matrix
X = repmat(xyz(1,:), M, 1);
Z = repmat(xyz(3,:), M, 1);

% Build cos(theta) & sin(theta) vector
cTheta = repmat(cos(theta)', 1, K);
sTheta = repmat(sin(theta)', 1, K);

% Transform each XYZ point to the Hough Space
Rho = (sTheta .* X) + (cTheta .* Z);
Rho = round(Rho, 2);

%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% Build the Joint PDF of theta and Rho

% Find the Min/Max of Rho, then build the rho vector
d_rho = 0.01; % fixed-value
rho = -3 : d_rho : 3;
N = length(rho);

% Build the Joint PDF Row by Row
theta_hist = zeros(M, N);
n = 1 : length(rho);

for ii = 1 : M % each search angle theta
    for jj = 1 : K % each xyz point
        
        % Index in the "rho" vector
        rho_mask = rho == Rho(ii,jj);
        rho_ind = n(rho_mask);
        
        % Update the accumulators
        theta_hist(ii, rho_ind) = theta_hist(ii, rho_ind) + 1;
        
    end
end

% Normalize the Accumulator
theta_hist_sum = sum(sum(theta_hist));
theta_hist = theta_hist ./ (d_theta * d_rho * theta_hist_sum);

%__________________________________________________________________________
%% Calculate the PMF's of rho

% Marginal PMF for rho 
pmf_rho = sum(theta_hist) ./ (d_rho * theta_hist_sum);

% Find the mode of pmf_rho
[~, rho_ind] = max(pmf_rho);
rho_ML = rho(rho_ind);

%% Extract and Normalize the Conditional Slice of theta

% Extract and Normalize the Conditional Slice of theta at the Most Probable
% Value of Rho
theta_cond_slice = theta_hist(:, rho_ind)';
theta_cond_slice = theta_cond_slice ./ (d_theta * sum(theta_cond_slice));

%% Extract the Mean and Variance from the PMF's of theta

% Extract Mode
[~, theta_ind] = max(theta_cond_slice);
theta_ML = theta(theta_ind);

% Extract the Mean
theta_mean = (theta * theta_cond_slice') * d_theta;

% Extract the Variance
theta_var = (((theta - theta_mean).^2) * theta_cond_slice') * d_theta;


%% Plotting Results if Desired

if (plot_flag == true)
    
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    % Plot the Resulting Joint Probability for theta and Rho
    figure
    [X1, Y1] = meshgrid(theta * 180/pi, rho);
    surf(X1', Y1', theta_hist);
    title('Fine Search: Joint Probability p_\theta_\rho(\theta,\rho)')
    xlabel('\theta (\circ)')
    ylabel('\rho')
    
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    % Plot PMF of theta
    figure
    plot(theta * 180/pi, theta_cond_slice, 'b')
    line([theta_ML theta_ML] * 180/pi, [0 max(theta_cond_slice)], 'Color', 'k')
    mode_str = ['\theta_M_L = ', num2str(round(theta_ML * 180/pi, 3)), '\circ  '];
    std_dev_str = ['\sigma_\theta = ', num2str(sqrt(theta_var) * 180/pi), '\circ'];
    title(['p_\theta_|_\rho(\theta|\rho = ', num2str(rho_ML), ')   ', mode_str, std_dev_str])    
    xlabel('\theta (\circ)')
    xlim([theta(1), theta(end)] * 180/pi)
    ylabel(['p_\theta_|_\rho(\theta|\rho = ', num2str(rho_ML), ')'])
    grid on
    
    
end
