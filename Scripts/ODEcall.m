%% Author: Jack Lambert
% ASEN 3128
% Purpose: Function for ODE45 to call to calculate the State variables 
% v_dot, p_dot, r_dot, phi_dot, psi_dot, and y_E_dot for the augmented 6X6
% matrix
% Last Edited: 4/30/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [dydt] = ODEcall(~,y,A_BK)

v_dot = y(1); % y-component of Velocity, Body Frame
p_dot = y(2); % roll-rate 
r_dot = y(3); % yaw rate
phi_dot = y(4); % Roll Angle 
psi_dot = y(5); % yaw angle
y_E_dot = y(6); % y-component of velcoity, Inertial Frame 

%% State Variable Matrix for Linearized Longitudinal Set
State = [v_dot, p_dot, r_dot, phi_dot, psi_dot, y_E_dot]'; % Couple State Variables in Long. Set
var = (A_BK)*State; % Couple State Variables in Long. Set
%% Solving for State Variables in the Linearized Longitudinal Set
dydt(1) = var(1); % v
dydt(2) = var(2); % p
dydt(3) = var(3); % r
dydt(4) = var(4); % phi
dydt(5) = var(5); % psi [deg]
dydt(6) = var(6); % y_E

dydt = dydt'; % Inverts for ODE45   
end