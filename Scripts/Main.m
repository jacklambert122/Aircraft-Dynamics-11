%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Jack Lambert
% Dale Lawrence
% Aircraft Dynmaics Homework 11
% Purpose: Sets Initial Conditions for each Pertubation Case and Calls ODE45
% to plot the State Variables vs time
% Date Modefied: 4/30/18
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ODE45 Variable Allocation
%                     v_dot = z(1); % y-component of Velocity, Body Frame
%                     p_dot = z(2); % Angular Velocity about the z-axis  [rad/s]
%                     r_dot = z(3); % Angular Velocity about the z-axis [rad/s]
%                     phi_dot = z(4); % Bank Angle [rad]
%                     psi_dot = z(5); % yaw angle [rad]
%                     y_E_dot = z(6); % y-comp. of velocity, Inertial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initial Conditions
c1 = 10; % y-component of Velocity, Body Frame [m/s]
c2 = -0.14; % Angular Velocity about the z-axis  [rad/s]
c3 = 0.05; % Angular Velocity about the z-axis [rad/s]
c4 = 0; % Bank Angle [rad]
c5 = 0; % Yaw Angle [rad]
c6 = 0; % y-component of velcoity, Inertial Frame [m/s]

condition = [c1 c2 c3 c4 c5 c6]; 

%% Selected Gains
[A_aug,B_aug] = Lateral(); % Augmented Matrices based on plane and parameters
K_mat = zeros(2,6);
K_mat(2,3) = 1.9; % K_rr
K_mat(1,4) = 0; % K_aphi

A_BK = A_aug + B_aug*K_mat;
Modes = eig(A_BK);
plot(real(Modes), imag(Modes),'.B')

% Classifying Each Mode
 n = 1;
 j = 1;
 k = 1;
 
 max_real = max(abs(real(Modes)));
for i = 1:length(Modes)
    if logical(imag(Modes(i))) == 1
        DR_Mode(n) = Modes(i); % Dutch Roll Mode Eigenvalues 
        n = n+1;
    elseif abs(real(Modes(i))) == max_real
        Roll_Mode(j) = Modes(i); % Roll Mode Eigenvalues
        j = j+1;
    elseif Modes(i) == 0
        % Dont use interger modes
    else
        Spiral_Mode(k) = Modes(i); % Spiral Mode Eigenvalues
        k = k+1;
        
    end
end

% Characteristics of Dutch Roll
tau_DR = -1/real(DR_Mode(1));
zeta_DR = -real(DR_Mode(1))/(real(DR_Mode(1))^2+imag(DR_Mode(1))^2)^(1/2);

% Characteristics of Spiral
tau_S = -1/real(Spiral_Mode);

%% State Variables vs. Time
time = [0 100]; % Set the time to be integrated [s]
% Calling ODE45 
[t,z] = ode45(@(t,y) ODEcall(t,y,A_BK),time,condition);

% V_E vs time
figure
subplot(6,1,1)
plot(t ,z(:,1),'Linewidth',1)
tit = sprintf('%s %s %s','State Variables of a B747');
title(tit)
ylabel('\Deltav^E [m/s]')


% p vs time
subplot(6,1,2)
plot(t ,z(:,2)*180/pi,'Linewidth',1)
ylabel('\Deltap [deg/s]')

% r vs time
subplot(6,1,3)
plot(t ,z(:,3)*180/pi,'Linewidth',1)
ylabel('\Deltar [deg/s]')

% Phi vs time
subplot(6,1,4)
plot(t ,z(:,4)*180/pi,'Linewidth',1)
ylabel('\Delta\Phi [deg]')

% Psi vs time
subplot(6,1,5)
plot(t ,z(:,5)*180/pi,'Linewidth',1)
ylabel('\Delta\Psi [deg]')

% y_E vs time
subplot(6,1,6)
plot(t ,z(:,6),'Linewidth',1)
ylabel('\Deltay^E [m/s]')
xlabel('Time [s]')


%% Aileron and Rudder Response

figure
% Aileron Response
da = K_mat(2,3)*z(:,3)*180/pi; % [deg]
max(da)
subplot(2,1,1)
plot(t ,da,'Linewidth',1)
tit = sprintf('%s %s %s','Control Surface Responses of a B 747');
title(tit)
ylabel('\Delta\delta_a [deg]')

% Rudder Response
dr = K_mat(1,5)*z(:,5)*180/pi; % [deg]
subplot(2,1,2)
plot(t ,dr,'Linewidth',1)
ylabel('\Delta\delta_r [deg]') 
xlabel('time [s]')


