function [w_b__i_b_tilde, f_b__i_b_tilde] = IMU(w_b__i_b, f_b__i_b)
% FUNCTION DESCRIPTION:
%   Simulates an IMU
%
% INPUTS:
%   w_b__i_b        = Ideal (error-free) Gyro measurements (rad/s)
%   f_b__i_b        = Ideal (error-free) Accel measurements (m/s^2)
%
% OUTPUTS:
%   w_b__i_b_tilde  = Gyro measurements (rad/s)
%   f_b__i_b_tilde  = Accel measurements (m/s^2)
%
%  Reference:  EE 595 Lecture notes: Wed, Feb 12, Friday, Feb 14, and Mon 17 March
%

global constants;               % Global variables


%--------------------------------------------------------------------------
% Generate the IMU measurements
%--------------------------------------------------------------------------

% Gyro Model:
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% Bias terms
b_g_BS = ???;                               % Bias - Bias Stability Bias term (rad/s)
b_g_BI = ???;                               % Bias - Markov Bias Instability Bias term (rad/s)
b_g = b_g_BI + b_g_FB + b_g_BS;             % All three bias terms (rad/s)

% Noise terms
w_g = ?? * randn(3,1);        % Gyro noise (rad/sec)

w_b__i_b_tilde = ????;  % lecture Friday, Feb 14 Slide # 11

% Accelerometer Model
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% Bias terms
b_a_BS = ??;                                % Bias - Bias Stability Bias term (m/s^2)
b_a_BI = ????;                              % Bias - Markov Bias Instability Bias term (m/s^2)
b_a = b_a_BI + b_a_FB + b_a_BS;             % All three bias terms (m/s^2)

% Noise terms
w_a = ??;        % Accelerometer noise (in m/s^2)

f_b__i_b_tilde = ???;    % lecture Friday, Feb 14 Slide # 11

end