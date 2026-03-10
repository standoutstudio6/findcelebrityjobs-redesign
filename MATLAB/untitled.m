% Script for ME3821 SP26 HW03 P3


% Generate the input signal:
t = 0:.1:10; % simulate for 10 seconds
x_road =  .05*sin(2*pi*t) + .02*sin(3*pi*t);

% Plot the road input:
figure()
plot(t,x_road)
xlabel('Time (s)')
ylabel('Road')
ylim([-1 1])
title('System Input')

% PUT YOUR SOLUTION HERE:
% Fill in the state matrices (note that the current system just directly
% passes the road input to the system output, not incorporating any
% dynamics)
% --- Quarter car parameters (example values) ---
ms = 500;      % sprung mass (kg) ~ 1/4 of car body mass
mu = 60;       % unsprung mass (kg) wheel/axle
ks = 15000;    % suspension stiffness (N/m)
cs = 900;      % suspension damping (Ns/m)
kt = 2000;     % tire stiffness (N/m)

A = [ 0,           1,          0,          0;
     -ks/ms,   -cs/ms,      ks/ms,     cs/ms;
      0,           0,          0,          1;
      ks/mu,    cs/mu, -(ks+kt)/mu,  -cs/mu];

B = [0;0;0; kt/mu];      % input is road displacement x_road
C = [1 0 0 0];           % output is rider/body position x_s
D = 0;

% Simulate the system:.
sys = ss(A,B,C,D);
y = lsim(sys, x_road,t);


% Plot the rider position:
figure()
hold on
plot(t,x_road)
plot(t,y)
hold off
xlabel('Time (s)')
ylabel('Position')
ylim([-.5 .5])
title('System Input')
legend('Road','Rider')




