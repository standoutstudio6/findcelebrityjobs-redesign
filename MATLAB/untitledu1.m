%% ME3281 HW03 - Problem 2 (MATLAB lsim)
clear; clc; close all

% Parameters
M = 1;
Bv = 3;
k = 0.5;

% State vector: x = [x1; v1; x2; v2]
A = [ 0   1    0   0;
     -k/M 0   k/M  0;
      0   0    0   1;
      k/M 0  -k/M -Bv/M ];

B = [0; 0; 0; 1/M];
C = [1 0 0 0];   % output is x1
D = 0;

sys = ss(A,B,C,D);

% Time + input (unit step)
t = 0:0.01:10;
u = ones(size(t));   % step of magnitude 1

% Simulate
y = lsim(sys,u,t);

% Plot
figure;
plot(t,y,'LineWidth',1.5); grid on
xlabel('Time (s)');
ylabel('x_1 (m)');
title('Problem 2: Mass 1 position x_1(t) via lsim');

% Optional: show expected long-time slope u/B = 1/3
hold on
plot(t,(1/Bv)*t,'--','LineWidth',1.2);
legend('x_1(t) from lsim','(1/B) t  (expected long-time ramp)','Location','best');
