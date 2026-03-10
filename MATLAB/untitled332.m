%% HW6_Fatigue_Plots.m
% ME 3221 / HW 6
% Plots for Problems 3, 4, and 5
% Units are kept consistent within each problem.
% P3, P5 in MPa; P4 in ksi.

clear; clc; close all;

%% =========================================================
%  PROBLEM 3
%  Bicycle spoke: plot stress state and material limits
% ==========================================================
% Given:
d3_mm       = 1.83;      % mm
F_mean3_N   = 225;       % N
sigma_m3    = 85.5;      % MPa (actual axial mean stress)
Su3         = 455;       % MPa
Sy3         = 290;       % MPa (not needed for this fatigue plot)
Cs3         = 0.9;       % ground finish
n3          = 2;         % desired safety factor
KA_axial    = 1.4;       % equivalent stress conversion factor for axial

% Endurance limit
Se_prime3   = 0.5 * Su3;         % MPa
Se3         = Cs3 * Se_prime3;   % MPa

% Equivalent mean stress
sigma_em3   = KA_axial * sigma_m3;   % MPa

% Solve Goodman for equivalent alternating stress at n = 2:
% 1/n = sigma_ea/Se + sigma_em/Su
sigma_ea3   = Se3 * (1/n3 - sigma_em3/Su3);  % MPa

% Convert back to actual axial alternating stress and force amplitude
sigma_a3    = sigma_ea3 / KA_axial;          % MPa
A3_mm2      = pi * d3_mm^2 / 4;              % mm^2
F_alt3_N    = sigma_a3 * A3_mm2;             % N since MPa = N/mm^2

% Goodman lines
sigm3 = linspace(0, Su3, 500);
siga3_goodman = Se3 * (1 - sigm3/Su3);               % n = 1 material limit
siga3_n2 = Se3 * (1/n3 - sigm3/Su3);                 % design line for n = 2
siga3_n2(siga3_n2 < 0) = NaN;

% Figure
figure('Name','Problem 3 - Goodman Diagram','Color','w');
plot(sigm3, siga3_goodman, 'LineWidth', 2); hold on;
plot(sigm3, siga3_n2, '--', 'LineWidth', 2);
plot(sigma_em3, sigma_ea3, 'o', 'MarkerSize', 8, 'LineWidth', 2);

xline(sigma_em3, ':', 'LineWidth', 1.2);
yline(sigma_ea3, ':', 'LineWidth', 1.2);
xline(Su3, '--', 'LineWidth', 1.2);
yline(Se3, '--', 'LineWidth', 1.2);

grid on;
xlabel('\sigma_{em}  (MPa)');
ylabel('\sigma_{ea}  (MPa)');
title('Problem 3: Modified Goodman Diagram for Bicycle Spoke');
legend('Material limit (n = 1)', 'Design line (n = 2)', ...
       'Operating point', 'Location', 'northeast');

text(sigma_em3 + 5, sigma_ea3 + 5, ...
    sprintf('(\\sigma_{em}, \\sigma_{ea}) = (%.2f, %.2f) MPa', sigma_em3, sigma_ea3));
text(10, Se3 + 5, sprintf('S_e = %.2f MPa', Se3));
text(Su3 - 70, 15, sprintf('S_u = %.0f MPa', Su3));

axis([0, Su3*1.05, 0, max(Se3, sigma_ea3)*1.35]);

fprintf('\n================ PROBLEM 3 ================\n');
fprintf('Equivalent mean stress, sigma_em  = %.3f MPa\n', sigma_em3);
fprintf('Equivalent alternating stress, sigma_ea = %.3f MPa\n', sigma_ea3);
fprintf('Actual axial alternating stress, sigma_a = %.3f MPa\n', sigma_a3);
fprintf('Alternating force amplitude, F_alt = %.3f N\n', F_alt3_N);

%% =========================================================
%  PROBLEM 4
%  Cantilever beam: infinite-life fatigue diagram
% ==========================================================
% Given:
delta1      = 0.075;     % in
delta2      = 0.225;     % in
F1          = 8.65;      % lbf causing delta1
L4          = 4.0;       % in
b4          = 0.75;      % in
h4          = 0.1094;    % in
Kt4         = 1.7;       % static stress concentration factor
q4          = 0.96;      % approximate chart reading for 490 BHN, r = 1/8 in
BHN4        = 490;       % Brinell hardness
Su4         = 0.5 * BHN4; % ksi, common estimate for steels
Se4         = 53;        % ksi, from chart-based approximation used in solution

% Force scaling with deflection
F2          = F1 * (delta2/delta1);      % lbf

% Mean and alternating forces
F_mean4     = (F1 + F2)/2;               % lbf
F_alt4      = (F2 - F1)/2;               % lbf

% Moments at the notch
M_mean4     = F_mean4 * L4;              % lbf-in
M_alt4      = F_alt4 * L4;               % lbf-in

% Nominal bending stress for rectangle: sigma = 6M/(b h^2)
sigma_m_nom4 = 6*M_mean4/(b4*h4^2)/1000; % ksi
sigma_a_nom4 = 6*M_alt4/(b4*h4^2)/1000;  % ksi

% Fatigue stress concentration
Kf4         = 1 + q4*(Kt4 - 1);

% Local/equivalent stresses
% Instructor clarified bottom surface in notch; actual mean is compressive there.
% Equivalent mean stress is taken as positive magnitude.
sigma_em4   = abs(Kf4 * sigma_m_nom4);   % ksi
sigma_ea4   = Kf4 * sigma_a_nom4;        % ksi

% Safety factor using modified Goodman
n4 = 1 / (sigma_ea4/Se4 + sigma_em4/Su4);

% Goodman line
sigm4 = linspace(0, Su4, 500);
siga4 = Se4 * (1 - sigm4/Su4);

% Operating ray (constant ratio sigma_a / sigma_m)
ratio4 = sigma_ea4 / sigma_em4;
sigm4_ray = linspace(0, sigma_em4*1.25, 100);
siga4_ray = ratio4 * sigm4_ray;

figure('Name','Problem 4 - Infinite Life Diagram','Color','w');
plot(sigm4, siga4, 'LineWidth', 2); hold on;
plot(sigm4_ray, siga4_ray, '--', 'LineWidth', 1.8);
plot(sigma_em4, sigma_ea4, 'o', 'MarkerSize', 8, 'LineWidth', 2);

xline(sigma_em4, ':', 'LineWidth', 1.2);
yline(sigma_ea4, ':', 'LineWidth', 1.2);
xline(Su4, '--', 'LineWidth', 1.2);
yline(Se4, '--', 'LineWidth', 1.2);

grid on;
xlabel('\sigma_{em}  (ksi)');
ylabel('\sigma_{ea}  (ksi)');
title('Problem 4: Infinite-Life Modified Goodman Diagram');
legend('Infinite-life Goodman line', 'Operating line (\sigma_a/\sigma_m constant)', ...
       'Operating point', 'Location', 'northeast');

text(sigma_em4 + 3, sigma_ea4 + 2, ...
    sprintf('(\\sigma_{em}, \\sigma_{ea}) = (%.2f, %.2f) ksi', sigma_em4, sigma_ea4));
text(5, Se4 + 2, sprintf('S_e \\approx %.1f ksi', Se4));
text(Su4 - 45, 5, sprintf('S_u \\approx %.1f ksi', Su4));
text(10, 10, sprintf('n = %.3f', n4), 'FontWeight', 'bold');

axis([0, Su4*1.05, 0, Se4*1.25]);

fprintf('\n================ PROBLEM 4 ================\n');
fprintf('Force for 0.225 in deflection, F2 = %.3f lbf\n', F2);
fprintf('Kf = %.4f\n', Kf4);
fprintf('Equivalent mean stress, sigma_em = %.3f ksi\n', sigma_em4);
fprintf('Equivalent alternating stress, sigma_ea = %.3f ksi\n', sigma_ea4);
fprintf('Safety factor, n = %.4f\n', n4);

%% =========================================================
%  PROBLEM 5(a)
%  Modified Goodman plot with constant-life lines
% ==========================================================
% Given:
Su5         = 480;     % MPa
Sy5         = 410;     % MPa (not used in Goodman here)
S_5e8       = 120;     % MPa, all factors included

% Load points: [sigma_em, sigma_ea]
pts5 = [ 75   135;
         50   110;
        150   200 ];

sigma_em5 = pts5(:,1);
sigma_ea5 = pts5(:,2);

% Constant-life line intercepts on sigma_ea axis (sigma_em = 0)
% sigma_ea = Sf * (1 - sigma_em/Su)
% => Sf = sigma_ea / (1 - sigma_em/Su)
Sf5 = sigma_ea5 ./ (1 - sigma_em5/Su5);

sigm5 = linspace(0, Su5, 600);

% Material line corresponding to 5e8 cycles
siga5_material = S_5e8 * (1 - sigm5/Su5);

figure('Name','Problem 5a - Modified Goodman + Constant-Life Lines','Color','w');
plot(sigm5, siga5_material, 'LineWidth', 2); hold on;

for i = 1:length(Sf5)
    siga_i = Sf5(i) * (1 - sigm5/Su5);
    siga_i(siga_i < 0) = NaN;
    plot(sigm5, siga_i, '--', 'LineWidth', 1.8);
    plot(sigma_em5(i), sigma_ea5(i), 'o', 'MarkerSize', 8, 'LineWidth', 2);
    plot(0, Sf5(i), 's', 'MarkerSize', 7, 'LineWidth', 1.5);
    text(5, Sf5(i)+4, sprintf('S_{f,%d} = %.2f MPa', i, Sf5(i)));
end

xline(Su5, '--', 'LineWidth', 1.2);

grid on;
xlabel('\sigma_{em}  (MPa)');
ylabel('\sigma_{ea}  (MPa)');
title('Problem 5(a): Modified Goodman Plot with Constant-Life Lines');
legend('5\times10^8-cycle line', ...
       'Constant-life line 1', 'Load point 1', 'Intercept 1', ...
       'Constant-life line 2', 'Load point 2', 'Intercept 2', ...
       'Constant-life line 3', 'Load point 3', 'Intercept 3', ...
       'Location', 'northeastoutside');

axis([0, Su5*1.05, 0, max(Sf5)*1.20]);

fprintf('\n================ PROBLEM 5(a) ================\n');
for i = 1:length(Sf5)
    fprintf('Load point %d: sigma_em = %.1f MPa, sigma_ea = %.1f MPa, intercept Sf = %.4f MPa\n', ...
        i, sigma_em5(i), sigma_ea5(i), Sf5(i));
end

%% =========================================================
%  PROBLEM 5(b,c)
%  log S - log N plot and cycles to failure
% ==========================================================
% Aluminum S-N curve assumed between:
% (N1, S1) = (1e3, 0.9*Su)
% (N2, S2) = (5e8, S_5e8)

N1 = 1e3;
S1 = 0.9 * Su5;
N2 = 5e8;
S2 = S_5e8;

% Fit S = a*N^b
bSN = (log10(S2) - log10(S1)) / (log10(N2) - log10(N1));
aSN = S1 / (N1^bSN);

% Cycles to failure for each intercept stress level
Nf5 = (Sf5 / aSN).^(1/bSN);

% Lifetime from Miner's rule over one 15-second block
n_cycles_block = [4; 5; 6];
D_block = sum(n_cycles_block ./ Nf5);
blocks_to_failure = 1 / D_block;
life_seconds = blocks_to_failure * 15;
life_hours = life_seconds / 3600;

% S-N curve
Ncurve = logspace(3, log10(5e8), 600);
Scurve = aSN * Ncurve.^bSN;

figure('Name','Problem 5b - log S-log N Plot','Color','w');
loglog(Ncurve, Scurve, 'LineWidth', 2); hold on;

for i = 1:length(Sf5)
    loglog(Nf5(i), Sf5(i), 'o', 'MarkerSize', 8, 'LineWidth', 2);
    loglog([N1, Nf5(i)], [Sf5(i), Sf5(i)], '--', 'LineWidth', 1.2);
    loglog([Nf5(i), Nf5(i)], [S2, Sf5(i)], ':', 'LineWidth', 1.2);
    text(Nf5(i)*1.05, Sf5(i)*1.02, ...
        sprintf('(%0.3g cycles, %.2f MPa)', Nf5(i), Sf5(i)));
end

grid on;
xlabel('Cycles to failure, N');
ylabel('Fully reversed equivalent stress level, S_f  (MPa)');
title('Problem 5(b): log S - log N Plot');
legend('Aluminum S-N curve', 'Point 1', '', '', 'Point 2', '', '', 'Point 3', '', '', ...
       'Location', 'southwest');

fprintf('\n================ PROBLEM 5(b,c) ================\n');
fprintf('S-N fit: S = a*N^b\n');
fprintf('a = %.6f\n', aSN);
fprintf('b = %.9f\n', bSN);

for i = 1:length(Sf5)
    fprintf('Point %d: Sf = %.4f MPa --> Nf = %.6e cycles\n', i, Sf5(i), Nf5(i));
end

fprintf('Damage per 15-second block = %.8e\n', D_block);
fprintf('Blocks to failure = %.6f\n', blocks_to_failure);
fprintf('Estimated life = %.6f hours\n', life_hours);

%% =========================================================
%  Optional summary table in Command Window
% ==========================================================
fprintf('\n================ SUMMARY ================\n');
fprintf('P3: sigma_em = %.2f MPa, sigma_ea = %.2f MPa, F_alt = %.2f N\n', ...
    sigma_em3, sigma_ea3, F_alt3_N);
fprintf('P4: sigma_em = %.2f ksi, sigma_ea = %.2f ksi, n = %.3f\n', ...
    sigma_em4, sigma_ea4, n4);
fprintf('P5: Intercepts Sf = [%.2f, %.2f, %.2f] MPa\n', Sf5(1), Sf5(2), Sf5(3));
fprintf('P5: Nf = [%.3e, %.3e, %.3e] cycles\n', Nf5(1), Nf5(2), Nf5(3));
fprintf('P5: Life = %.2f hours\n', life_hours);