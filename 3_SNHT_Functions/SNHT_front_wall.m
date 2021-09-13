function [psi_ML, psi_var] = SNHT_wall_2stage_search(xyz, plot_flag)
% 
% SNHT_wall runs the Surface Normal Hough Transform (SNHT) algorithm on a
% given <x,y,z> point cloud for a provided search space.  
%
% THIS IS A VECTORIZED VERSION OF THE CODE!!!
%
% Inputs:
% xyz - an unorganized list of <x,y,z> points; size(3, <num_points>)
% psi_params - [psi_l, d_psi, psi_ub], defines the lower bound, step size,
% and upper bound of the search space for psi.  Input as radians!
% plot_flag - true/false for plots of the joint probabilities and pmf's
% 
% Outputs:
% psi_ML - the most likely value of phi, radians
% psi_var - the variance of phi, in radians
%
%__________________________________________________________________________
%% Complete a Coarse Search

% XYZ Points
K = length(xyz);

% psi bins
psi = (-135 : 1 : 135) * pi/180;
M = length(psi); 

%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Tranform Each XYZ Point to the Hough Space
% Each Matrix is sized M x K

% Build X  & Y Matrix
X = repmat(xyz(1,:), M, 1);
Y = repmat(xyz(2,:), M, 1);

% Build cos(psi) & sin(psi) vector
cPsi = repmat(cos(psi)', 1, K);
sPsi = repmat(sin(psi)', 1, K);

% Transform each XYZ point to the Hough Space
Rho = (cPsi .* X) + (sPsi .* Y);
Rho = round(Rho, 1);

%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% Build the Joint PDF of Psi and Rho

% Find the Min/Max of Rho, then build the rho vector
min_rho = min(min(Rho));
max_rho = max(max(Rho));
d_rho = 0.1; % fixed-value
rho = min_rho : d_rho : max_rho;
N = length(rho);

% Build the Joint PDF Row by Row
psi_hist = zeros(M, N);
n = 1 : length(rho);

for ii = 1 : M % each search angle psi
    for jj = 1 : K % each xyz point
        
        % Index in the "rho" vector
        rho_mask = rho == Rho(ii,jj);
        rho_ind = n(rho_mask);
        
        % Update the accumulators
        psi_hist(ii, rho_ind) = psi_hist(ii, rho_ind) + 1;
        
    end
end

%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% Determine the where the fine search should occur
% This current method will only find one peak
[~, rho_ind_c] = max(max(psi_hist));
rho_c = rho(rho_ind_c);
[~, psi_ind_c] = max(psi_hist(:,rho_ind_c));
psi_c = psi(psi_ind_c);

% If Plotting is Desired
if (plot_flag == true)
    
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    % Plot the Resulting Joint Probability for Psi and Rho
    figure
    [X1, Y1] = meshgrid(psi * 180/pi, rho);
    surf(X1', Y1', psi_hist);
    tit_str = ['\psi = ', num2str(psi_c * 180/pi), '\circ   \rho = ', num2str(rho_c)];
    title(['Coarse Search: ', tit_str])
    xlabel('\psi (\circ)')
    ylabel('\rho')
    
end

%__________________________________________________________________________
%% Complete a Fine Search

% XYZ Points
K = length(xyz);

% psi bins
psi_fine_search = 15 * pi/180;
d_psi = 0.025 * pi/180;
rho_fine_search = 0.2;
psi = ((psi_c - psi_fine_search) : d_psi : (psi_c + psi_fine_search));
M = length(psi); 

%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Tranform Each XYZ Point to the Hough Space
% Each Matrix is sized M x K

% Build X  & Y Matrix
X = repmat(xyz(1,:), M, 1);
Y = repmat(xyz(2,:), M, 1);

% Build cos(psi) & sin(psi) vector
cPsi = repmat(cos(psi)', 1, K);
sPsi = repmat(sin(psi)', 1, K);

% Transform each XYZ point to the Hough Space
Rho = (cPsi .* X) + (sPsi .* Y);
Rho = round(Rho, 2);

%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% Build the Joint PDF of Psi and Rho

% Find the Min/Max of Rho, then build the rho vector
d_rho = 0.01; % fixed-value
rho = ((rho_c - rho_fine_search) : d_rho : (rho_c + rho_fine_search));
N = length(rho);

% Build the Joint PDF Row by Row
psi_hist = zeros(M, N);
n = 1 : length(rho);

for ii = 1 : M % each search angle psi
    for jj = 1 : K % each xyz point
        
        % Index in the "rho" vector
        rho_mask = rho == Rho(ii,jj);
        rho_ind = n(rho_mask);
        
        % Update the accumulators
        psi_hist(ii, rho_ind) = psi_hist(ii, rho_ind) + 1;
        
    end
end

% Normalize the Accumulator
phi_hist_sum = sum(sum(psi_hist));
psi_hist = psi_hist ./ (d_psi * d_rho * phi_hist_sum);

%__________________________________________________________________________
%% Calculate the PMF's of rho

% Marginal PMF for rho 
pmf_rho = sum(psi_hist) ./ (d_rho * phi_hist_sum);

% Find the mode of pmf_rho
[~, rho_ind] = max(pmf_rho);
rho_ML = rho(rho_ind);

%% Extract and Normalize the Conditional Slice of Psi

% Extract and Normalize the Conditional Slice of Psi at the Most Probable
% Value of Rho
psi_cond_slice = psi_hist(:, rho_ind)';
psi_cond_slice = psi_cond_slice ./ (d_psi * sum(psi_cond_slice));

%% Extract the Mean and Variance from the PMF's of Psi

% Extract Mode
[~, psi_ind] = max(psi_cond_slice);
psi_ML = psi(psi_ind);

% Extract the Mean
psi_mean = (psi * psi_cond_slice') * d_psi;

% Extract the Variance
psi_var = (((psi - psi_mean).^2) * psi_cond_slice') * d_psi;


%% Plotting Results if Desired

if (plot_flag == true)
    
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    % Plot the Resulting Joint Probability for Psi and Rho
    figure
    [X1, Y1] = meshgrid(psi * 180/pi, rho);
    surf(X1', Y1', psi_hist);
    title('Fine Search: Joint Probability p_\psi_\rho(\psi,\rho)')
    xlabel('\psi (\circ)')
    ylabel('\rho')
    
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    % Plot PMF of Phi
    figure
    plot(psi * 180/pi, psi_cond_slice, 'b')
    line([psi_ML psi_ML] * 180/pi, [0 max(psi_cond_slice)], 'Color', 'k')
    mode_str = ['\psi_M_L = ', num2str(round(psi_ML * 180/pi, 3)), '\circ  '];
    std_dev_str = ['\sigma_\psi = ', num2str(sqrt(psi_var) * 180/pi), '\circ'];
    title(['p_\psi_|_\rho(\psi|\rho = ', num2str(rho_ML), ')   ', mode_str, std_dev_str])    
    xlabel('\psi (\circ)')
    xlim([psi_c - psi_fine_search, psi_c + psi_fine_search] * 180/pi)
    ylabel(['p_\psi_|_\rho(\psi|\rho = ', num2str(rho_ML), ')'])
    grid on
    
    
end
