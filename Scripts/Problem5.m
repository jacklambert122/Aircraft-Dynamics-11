%% Author: Jack Lambert
% ASEN 3128
% Homework 11
% Purpose: To implement the findings from problem 4 to implelment two
% vectors of useful gains for both the dutch roll mode and spiral mode in
% order to meet the design requirements in question 5
% Date Modified: 4/30/18
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[A_aug,B_aug] = Lateral(); % Augmented Matrices based on plane and parameters
K_mat = zeros(2,6);

Krr = 1.5:0.1:2.5; % K_rr
K_aphi = 0; % K_aphi (Didnt need)
figure
for i = 1:length(Krr)
    K_mat(2,3) = Krr(i);
    for j = 1:length(K_aphi)
        K_mat(1,5) = K_aphi(j);
        A_BK = A_aug + B_aug*K_mat;
        Modes = eig(A_BK);
        plot(real(Modes),imag(Modes),'.B')
        hold on
    end
    
end

Krr_Best = 1.9; % Best Gain ( greatest -real )
K_mat(2,3) = Krr_Best;
A_BK = A_aug + B_aug*K_mat;
Modes = eig(A_BK);
best = plot(real(Modes),imag(Modes),'ko');
%% Defining the Target Region (Dutch Roll)
z = 0.35:.01:1;
tau = 1:0.6:40;
nDR = (-1./tau);
for i = 1:length(tau)
    for j = 1:length(z)
        wDR(i,j) = nDR(i)*(((1/z(j))^2-1))^(1/2);
    end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting the "Target Zone" of EigenValue

% Plotting only the first and last values to show region
plot([nDR(1),nDR(1)],[wDR(1,1),wDR(1,end)],'Linewidth',2)
plot([nDR(end),nDR(end)],[wDR(end,1),wDR(end,end)],'Linewidth',2)
plot(nDR(:),wDR(:,1),'Linewidth',2)
plot(nDR(:),wDR(:,end),'Linewidth',2)
text(nDR(1),wDR(1,25),'  Target Range \rightarrow','HorizontalAlignment','right')

% For negative imaginary eigen values
plot([nDR(1),nDR(1)],-[wDR(1,1),wDR(1,end)],'Linewidth',2)
plot([nDR(end),nDR(end)],-[wDR(end,1),wDR(end,end)],'Linewidth',2)
plot(nDR(:),-wDR(:,1),'Linewidth',2)
plot(nDR(:),-wDR(:,end),'Linewidth',2)
text(nDR(1),-wDR(1,25),'  Target Range \rightarrow','HorizontalAlignment','right')

%% Target Region for Spiral
plot([-1/25 -1/25],[-5 5],'-r')
text(-1/25,1.5,' \leftarrow Target Line ','HorizontalAlignment','left')
%% Plotting 
plot([0,0],[-3,3],'--k')
plot([-2,2],[0,0],'--k')
title('Eigenvalues ')
xlabel('Re(\lambda)')
ylabel('Im(\lambda)')
legend([best],{'Modes for Best Gain'})

