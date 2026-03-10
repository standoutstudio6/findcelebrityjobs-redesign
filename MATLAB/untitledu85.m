% HW4 Problem 3 - Infinite Fin Temperature Distributions

clear; clc;

% Given
D = 0.005;          % m
L = 0.15;           % m
h = 100;            % W/m^2-K
Tb = 100;           % degC
Tinf = 25;          % degC

% Materials (k in W/m-K)
k_Cu  = 398;
k_Al  = 180;
k_SS  = 14;

k_list = [k_Cu, k_Al, k_SS];
names  = {'Copper','Aluminum Alloy','AISI 316 SS'};

% Geometry
P  = pi*D;
Ac = pi*D^2/4;

% x-grid
x = linspace(0, L, 400);

figure; hold on; grid on;
xlabel('x (m)'); ylabel('Temperature T(x) (^{\circ}C)');
title('Infinite Fin Temperature Distributions');

for i = 1:length(k_list)
    k = k_list(i);

    m = sqrt(h*P/(k*Ac));                 % 1/m
    T = Tinf + (Tb - Tinf)*exp(-m*x);     % degC

    % Infinite-fin heat rate
    qfin = sqrt(h*P*k*Ac)*(Tb - Tinf);    % W

    % Tip temperature
    Ttip = Tinf + (Tb - Tinf)*exp(-m*L);

    plot(x, T, 'LineWidth', 2, 'DisplayName', names{i});

    fprintf('%s:\n', names{i});
    fprintf('  m = %.4f 1/m\n', m);
    fprintf('  q_fin = %.4f W\n', qfin);
    fprintf('  T_tip = %.4f degC\n\n', Ttip);
end

legend('Location','best');
