%% Author: Jack Lambert
% ASEN 3128
% Homework 11
% Purpose: Find the dimensional derivatives given the none dimensional
% derivatives given from Etikin
% Date Modified: 4/15/2018
close all; clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Airplane Parameters
% Nondimensional Lateral Derivatives
% Table 6.6 -
Cy = [-.8771, 0, 0];
Cl = [-.2797, -.3295, .304];
Cn = [.1946, -.04073, -.2737];

% Table E.1 B747 Case 2
Alt = 20000*(0.3048); % Altitude [ft] -> [m]
[~, a, P, rho] = atmosisa(Alt); % Standard Atmosphere Properties at Alt.
W = 6.366*10^5*4.44822; % Weight [lb]->[N]
Ix_PA = 1.82e7*1.35581795; % Moment of Interia x-PA [slug ft^2]-> [kg m^2]
Iy_PA = 3.31e7*1.35581795; % Moment of Interia y-PA [slug ft^2]-> [kg m^2]
Iz_PA = 4.97e7*1.35581795; % Moment of Interia z-PA [slug ft^2]-> [kg m^2]
Izx_PA = 9.70e5*1.35581795; % Moment of Interia zx-PA [slug ft^2]-> [kg m^2]
CD = .040; % Coefficient of Drag
cbar = 27.31*(0.3048); % Mean Chord Length [ft]->[m]
b = 195.68*(0.3048); % Span [ft] ->[m]
S = 5500*(0.3048)^2; % Surface Area [ft^2]->[m^2]
g = 9.81; % Gravity Constant [m/s^2]
m = W/g; % Mass of Plane [kg]

% Primed Inertias
Ix_lat = (Ix_PA*Iz_PA-Izx_PA^2)/Iz_PA; % [kg m^2]
Iz_lat = (Ix_PA*Iz_PA-Izx_PA^2)/Ix_PA; % [kg m^2]
Izx_lat = Izx_PA/(Ix_PA*Iz_PA-Izx_PA^2); % [kg m^2]

%% Trim States
Vel = 518*(0.3048);% Velocity [ft/s] -> [m/s]
u0 = Vel; % Initial Velocity in x-coord - Stability Axis Frame (Trim State)
theta0 = 0; % Initial Pitch Angle [deg]

%% State Variable Derivatives
% Y (N)
Yv = (1/2)*rho*u0*S*Cy(1);
Yp = (1/4)*rho*u0*b*S*Cy(2);
Yr = (1/4)*rho*u0*b*S*Cy(3);

Y = [Yv, Yp, Yr]';

% L (N*m)
Lv = (1/2)*rho*u0*b*S*Cl(1);
Lp = (1/4)*rho*u0*b^2*S*Cl(2);
Lr = (1/4)*rho*u0*b^2*S*Cl(3);

L = [Lv, Lp, Lr]';

% N (N*m)
Nv = (1/2)*rho*u0*b*S*Cn(1);
Np = (1/4)*rho*u0*b^2*S*Cn(2);
Nr = (1/4)*rho*u0*b^2*S*Cn(3);

N = [Nv, Np, Nr]';

T = table(Y,L,N);
T.Properties.VariableNames = {'Y' 'L' 'N'}

%% Lateral Dynamics A matrix

row1 = [Y(1)/m, Y(2)/m, (Y(3)/m-u0), g*cosd(theta0)];
row2 = [(L(1)/Ix_lat+Izx_lat*N(1)), (L(2)/Ix_lat+Izx_lat*N(2)),(L(3)/Ix_lat+Izx_lat*N(3)),0];
row3 = [(Izx_lat*L(1)+ N(1)/Iz_lat), (Izx_lat*L(2)+ N(2)/Iz_lat), (Izx_lat*L(3)+ N(3)/Iz_lat), 0];
row4 = [0, 1, tand(theta0),0];

A = [row1;row2;row3;row4;];
TA = table(A);

%% Lateral Dynamics B Matrix

% Control Derivatives
Cy = [0,0.1146];
Cl = [-1.368e-2,6.976e-3];
Cn = [-1.973e-4,-.1257];

% Dimensional Control Derivatives
Y = [1/2*rho*u0^2*S*Cy(1), 1/2*rho*u0^2*S*Cy(2)];
L = [1/2*rho*u0^2*S*b*Cl(1), 1/2*rho*u0^2*S*b*Cl(2)];
N = [1/2*rho*u0^2*S*b*Cn(1), 1/2*rho*u0^2*S*b*Cn(2)];

% B Matirx

Br1 = [Y(1)/m, Y(2)/m];
Br2 = [L(1)/Ix_lat+Izx_lat*N(1), L(2)/Ix_lat+Izx_lat*N(2)];
Br3 = [Izx_lat*L(1)+N(1)/Iz_lat, Izx_lat*L(2)+N(2)*Iz_lat];
Br4 = [0, 0];

B = [Br1; Br2; Br3; Br4];
TB = table(B);

%% Augmented Matrices

% Augmented A Matrix
A_aug = [row1, 0, 0;
        row2, 0, 0;
        row3, 0, 0;
        row4, 0, 0;
        0, 0, secd(theta0), 0, 0, 0;
        1, 0, 0, 0, u0*cosd(theta0), 0];
TA_aug = table(A_aug); 

% Augmented B Matrix
B_aug = [Br1; Br2; Br3; Br4; 0, 0; 0, 0];
TB_aug = table(B_aug);
    

%% Computing the Eigenvalues of the A matrix
[eVA,eValA] = eig(A);

modesA = diag(eValA);

max_real = max(abs(real(modesA)));

%% Classifying Each Mode
 n = 1;
 j = 1;
 k = 1;
for i = 1:length(modesA)
    if logical(imag(modesA(i))) == 1
        DR_Mode(n) = modesA(i); % Dutch Roll Mode Eigenvalues 
        DR_vec(:,n) = eVA(:,i); % Dutch Roll Mode Eigenvector 
        n = n+1;
    elseif abs(real(modesA(i))) == max_real
        Roll_Mode(j) = modesA(i); % Roll Mode Eigenvalues
        Roll_vec(:,j) = eVA(:,i); % Roll Mode Eigenvector 
        j = j+1;
    else
        Spiral_Mode(k) = modesA(i); % Spiral Mode Eigenvalues
        Spiral_vec(k,:) = eVA(:,i); % Spiral Mode Eigenvectors
        k = k+1;
        
    end
end

%% Converting to Script Notation
yv = row1(1); yp = row1(2); yr = row1(3);
lv = row2(1); lp = row2(2); lr = row2(3);
nv = row3(1); np = row3(2); nr = row3(3);

%% Roll Mode Approximation
roll_approx = lp;

p_error_roll = abs((Roll_Mode - lp)/Roll_Mode) * 100;
%% Spiral Mode Approximation
 %  Using (lambda*d + e) of Characteristic Equation
 d = -g*( lv*cosd(theta0)+nv*sind(theta0) ) + yv*(lr*np - lp*nr) + yr*(lp*nv - lv*np);
e = g*( (lv*nr-lr*nv)*cosd(theta0) + (lp*nv - lv*np)*sind(theta0) );

spiral_approx = -e/d;
p_error_spiral = abs((Spiral_Mode - spiral_approx)/Spiral_Mode) * 100;

%% For full A Matrix
figure
% Roll
R = plot(real(Roll_Mode),imag(Roll_Mode),'o');
hold on
% Spiral 
S = plot(real(Spiral_Mode),imag(Spiral_Mode),'o');

%% For Roll Mode Approx.
RA = plot(real(roll_approx),imag(roll_approx),'o');
%% For Spiral Mode Approx.
SA = plot(real(spiral_approx),imag(spiral_approx),'o');

plot([0,0],[-1.5,1.5],'--k')
plot([-1.5,1.5],[0,0],'--k')
title('A Matrix Eigenvalues ')
xlabel('Re(\lambda)')
ylabel('Im(\lambda)')
legend([R S RA SA], {'Roll Mode','Spiral Mode','Roll Mode Approx.', 'Spiral Mode Approx.'})
hold off

