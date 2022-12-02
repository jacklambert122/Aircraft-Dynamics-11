%% Author: Jack Lambert
% ASEN 3128
% Homework 11
% Date Modified: 4/30/18
clear all; close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Varying K Matrix
k1 = 0:0.01:10;
k2 = 0:0.01:20;
k3 = 0:0.0001:0.1;
k4 = 0:0.01:2;
k5 = 0:0.01:5;

K = {k1; -k1; -k1; k2; -k3; -k4; k5; -k5; k5; -k5; k5; -k5}; % Different Gains for Scenarios
col = [4, 2, 3, 5, 1, 2, 3, 3, 4, 4, 5, 5]; % column in K matix
row = [1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2]; % row in K matrix
tit = ["\Delta\delta_a = K\Delta\phi","\Delta\delta_a = K\Deltap", ...
    "\Delta\delta_a = K\Deltar","\Delta\delta_a = K\Delta\psi",...
    "\Delta\delta_r = K\Deltav","\Delta\delta_r = K\Deltap", ...
    "\Delta\delta_r = K\Deltar (Positive Feedback)",...
    "\Delta\delta_r = K\Deltar (Negative Feedback)",...
    "\Delta\delta_r = K\Delta\phi (Positive Feedback)"...
    "\Delta\delta_r = K\Delta\phi (Negative Feedback)"...
    "\Delta\delta_r = K\Delta\psi (Positive Feedback)"...
    "\Delta\delta_r = K\Delta\psi (Negative Feedback)"];
% Calling Calculated Augmented Matrices
[A_aug,B_aug] = Lateral();

Modes = zeros(6,1);
% Running through different K matrices
for i = 1:length(K)
    K_mat = zeros(2,6); % Pre-allocates zeros
    k = K{i};
    figure(i)

    for j = 1:length(k)
        K_mat(row(i),col(i)) = k(j); % Places gain for variable of interest
        A_BK_aug = A_aug + B_aug*K_mat;
        Modes = eig(A_BK_aug);
        plot(real(Modes), imag(Modes),'.B')
        hold on
       
        if j == 1
           first =  plot(real(Modes), imag(Modes),'ro');
        elseif j == length(k)
           last = plot(real(Modes), imag(Modes),'ko');
        end
        
    end
    title( tit(i) )
    plot([0,0],[-2,2],'--k')
    plot([-2,2],[0,0],'--k')
    xlabel('Re(\lambda)')
    ylabel('Im(\lambda)')
    legend([first last], {'Open Loop Gain', 'Last Gain'})
    hold off
end

check = 1;

