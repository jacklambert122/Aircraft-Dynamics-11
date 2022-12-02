function [A_aug,B_aug] = Lateral()
% Nondimensional Lateral Derivatives
% Table 6.6 -
Cy = [-.8771, 0, 0];
Cl = [-.2797, -.3295, .304];
Cn = [.1946, -.04073, -.2737];

% Table E.1 B747 Case 2
Alt = 20000*(0.3048); % Altitude [ft] -> [m]
[~, ~, ~, rho] = atmosisa(Alt); % Standard Atmosphere Properties at Alt.
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

%% Control Derivatives
Cy = [0,0.1146];
Cl = [-1.368e-2,6.976e-3];
Cn = [-1.973e-4,-.1257];

% Dimensional Control Derivatives
YC = [1/2*rho*u0^2*S*Cy(1), 1/2*rho*u0^2*S*Cy(2)];
LC = [1/2*rho*u0^2*S*b*Cl(1), 1/2*rho*u0^2*S*b*Cl(2)];
NC = [1/2*rho*u0^2*S*b*Cn(1), 1/2*rho*u0^2*S*b*Cn(2)];

%% Lateral Dynamics A matrix

row1 = [Y(1)/m, Y(2)/m, (Y(3)/m-u0), g*cosd(theta0)];
row2 = [(L(1)/Ix_lat+Izx_lat*N(1)), (L(2)/Ix_lat+Izx_lat*N(2)),(L(3)/Ix_lat+Izx_lat*N(3)),0];
row3 = [(Izx_lat*L(1)+ N(1)/Iz_lat), (Izx_lat*L(2)+ N(2)/Iz_lat), (Izx_lat*L(3)+ N(3)/Iz_lat), 0];
row4 = [0, 1, tand(theta0),0];

%% Lateral Dynamics B Matrix

Br1 = [YC(1)/m, YC(2)/m];
Br2 = [LC(1)/Ix_lat+Izx_lat*NC(1), LC(2)/Ix_lat+Izx_lat*NC(2)];
Br3 = [Izx_lat*LC(1)+NC(1)/Iz_lat, Izx_lat*LC(2)+NC(2)/Iz_lat];
Br4 = [0, 0];

B = [Br1; Br2; Br3; Br4];
TB = table(B)

%% Augmented Matrices

% Augmented A Matrix
A_aug = [row1, 0, 0;
        row2, 0, 0;
        row3, 0, 0;
        row4, 0, 0;
        0, 0, secd(theta0), 0, 0, 0;
        1, 0, 0, 0, u0*cosd(theta0), 0]


% Augmented B Matrix
B_aug = [Br1; Br2; Br3; Br4; 0, 0; 0, 0]

    
end