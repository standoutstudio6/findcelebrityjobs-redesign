% ME3281 HW04 Problem 6 - LSIM simulation
clear; clc; close all

% Given constants
B1 = 10;
K1 = 2;

% Time vector and input (step of magnitude 1)
t = 0:0.01:20;
u = ones(size(t));   % tau_a(t) = 1 step

% Gear ratios to test
N_list = 0.5:0.5:4;

figure(1);
hold on

legend_entries = strings(size(N_list));

for i = 1:length(N_list)
    N = N_list(i);

    % State-space for: B1*theta2_dot + K1*theta2 = N*tau_a
    % theta2_dot = -(K1/B1)*theta2 + (N/B1)*tau_a
    A = -(K1/B1);
    B =  (N/B1);
    C = 1;
    D = 0;

    sys = ss(A,B,C,D);

    y = lsim(sys,u,t);   % y = theta2(t)

    plot(t,y);
    legend_entries(i) = "N = " + N;
end

hold off
xlabel('Time (s)')
ylabel('\theta_2 (rad)')
legend(legend_entries, 'Location', 'best')
grid on
