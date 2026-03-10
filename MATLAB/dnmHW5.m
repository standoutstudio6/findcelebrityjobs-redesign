%% HW5 Fatigue - All Required Plots
% Generates plots for Problems 1, 4, and 5 (and supporting S-N plots).
% NOTE: Adjust C_S values if your instructor expects different readings from the chart.

clear; clc; close all;

ksi2MPa = 6.895;

%% =========================
%  Problem 1: Al 7075-T6
%  Modified Goodman + constant-life lines (1e6 and 5e8) + yield line
% =========================
Su_al = 593;     % MPa
Sy_al = 538;     % MPa

% --- Marin factors (from handout) ---
CL = 1.0;        % bending
CG = 0.9;        % 10<d<50 mm, use 25 mm
CR = 0.897;      % 90% reliability
CT = 1.0;        % temperature (not applied here)
CS_al = 0.774;   % fine ground at Su=593 MPa (~86 ksi), from chart

K_al = CL*CG*CS_al*CR*CT;

% --- Baseline (unmodified) fatigue strengths for Aluminum ---
S1000p = 0.9*Su_al;                             % MPa, at N=1e3
S5e8p  = min(0.4*Su_al, 19*ksi2MPa);             % MPa, at N=5e8 (cap)

% Interpolate baseline to N=1e6 on log-log
S1e6p  = loglog_interp(1e3, S1000p, 5e8, S5e8p, 1e6);

% Apply Marin modification
S5e8   = K_al*S5e8p;     % MPa
S1e6   = K_al*S1e6p;     % MPa

% Display key values (should match your solved values if using same C_S etc.)
fprintf('--- Problem 1 (Al 7075-T6) ---\n');
fprintf('S''(1e3)=%.3f MPa\n', S1000p);
fprintf('S''(5e8)=%.3f MPa\n', S5e8p);
fprintf('S''(1e6)=%.3f MPa (log-log interp)\n', S1e6p);
fprintf('K=%.5f\n', K_al);
fprintf('S(5e8)=%.3f MPa (modified)\n', S5e8);
fprintf('S(1e6)=%.3f MPa (modified)\n\n', S1e6);

% ---- Plot: Modified Goodman with constant-life lines + yield line + load point ----
sm = linspace(0, Su_al, 500);              % mean stress axis (MPa)
sa_5e8 = S5e8*(1 - sm/Su_al);              % Goodman line for 5e8
sa_1e6 = S1e6*(1 - sm/Su_al);              % Goodman line for 1e6

figure('Name','P1: Modified Goodman (Al 7075-T6)');
hold on; grid on; box on;
plot(sm, sa_5e8, 'LineWidth', 2, 'DisplayName','Constant life: 5\times10^8');
plot(sm, sa_1e6, 'LineWidth', 2, 'DisplayName','Constant life: 10^6');

% Yield line: sigma_a + sigma_m = Sy  (only meaningful for 0<=sm<=Sy)
smy = linspace(0, Sy_al, 300);
plot(smy, Sy_al - smy, 'LineWidth', 2, 'DisplayName','Yield line: \sigma_{ea}+\sigma_{em}=S_y');

% Load point from Problem 2b
plot(20, 6, 'o', 'MarkerSize', 8, 'LineWidth', 2, 'DisplayName','Load point (20,6) MPa');

xlabel('\sigma_{em} (MPa)','Interpreter','tex');
ylabel('\sigma_{ea} (MPa)','Interpreter','tex');
title('Modified Goodman Diagram (Al 7075-T6, bending, d=25 mm, fine-ground, 90% reliability)');
legend('Location','northeast');

% Optional: set limits nicely
xlim([0 Su_al]);
ylim([0 max([Sy_al, S1e6])*1.05]);

%% ---- Supporting Plot: S-N points used (baseline & modified) ----
figure('Name','P1 Support: S-N Points (Al 7075-T6)');
hold on; grid on; box on;

% Baseline points
loglog([1e3 1e6 5e8], [S1000p S1e6p S5e8p], 'o-', 'LineWidth', 2, ...
    'DisplayName','Baseline S''(N)');

% Modified points
loglog([1e3 1e6 5e8], K_al*[S1000p S1e6p S5e8p], 's-', 'LineWidth', 2, ...
    'DisplayName','Modified S(N)');

xlabel('Cycles, N');
ylabel('Stress amplitude (MPa)');
title('Al 7075-T6 S-N Points (Baseline vs Modified)');
legend('Location','southwest');

%% =========================
%  Problem 4: Composite S-N interpolation plot + sigma_max point
% =========================
Su_c = 100;  % MPa
S_1e3 = 90;  N_1e3 = 1e3;
S_1e8 = 40;  N_1e8 = 1e8;

Nq = 1e5;
S_1e5 = loglog_interp(N_1e3, S_1e3, N_1e8, S_1e8, Nq);   % MPa

n_req = 3;
% With sigma_min = 0 => sigma_m = sigma_a = sigma_max/2
% Modified Goodman: 1/n = (sigma_a/Sf) + (sigma_m/Su)
% => 1/n = (sigma_max/2)*(1/Sf + 1/Su) => sigma_max = (2/n)/(1/Sf + 1/Su)
sigma_max = (2/n_req) / ( (1/S_1e5) + (1/Su_c) );

fprintf('--- Problem 4 (Composite) ---\n');
fprintf('S(1e5)=%.3f MPa\n', S_1e5);
fprintf('sigma_max=%.3f MPa (sigma_min=0, n=3)\n\n', sigma_max);

% Plot composite S-N interpolation line and the queried point
figure('Name','P4: Composite S-N (with interpolation)');
hold on; grid on; box on;
loglog([N_1e3 N_1e8], [S_1e3 S_1e8], 'o-', 'LineWidth', 2, 'DisplayName','Given endpoints');
loglog(Nq, S_1e5, 's', 'MarkerSize', 9, 'LineWidth', 2, 'DisplayName','Interpolated S(10^5)');
xlabel('Cycles, N');
ylabel('Fatigue strength, S(N) (MPa)');
title('Composite S-N (log-log interpolation)');
legend('Location','southwest');

%% =========================
%  Problem 5: Titanium bicycle part Goodman plot
% =========================
Su_ti = 226;  % MPa
Sy_ti = 202;  % MPa

d = 0.025;    % m
M = 50;       % N*m (bending moment, constant)
F = 75;       % N (axial force, constant)
T = 80;       % N*m (torque, constant)

KA = 1.4;     % axial factor from equation sheet
Kf = 1.0;     % assume no notch data given

% Section properties stresses:
% Rotating bending: fully reversed -> alternating only
sigma_bend_a = Kf*(32*M/(pi*d^3))/1e6;      % MPa
sigma_bend_m = 0;

% Axial: constant -> mean only (with KA)
sigma_ax_m   = KA*(4*F/(pi*d^2))/1e6;       % MPa
sigma_ax_a   = 0;

% Torsion: constant -> mean shear only
tau_m = (16*T/(pi*d^3))/1e6;                % MPa
tau_a = 0;

% Equivalent von Mises mean/alt (sigma_y=0)
sigma_em = sqrt( (sigma_ax_m + sigma_bend_m)^2 + 3*(tau_m)^2 );
sigma_ea = abs( sigma_bend_a );             % since shear alternating is zero

fprintf('--- Problem 5 (Titanium) ---\n');
fprintf('sigma_ea=%.3f MPa\n', sigma_ea);
fprintf('sigma_em=%.3f MPa\n\n', sigma_em);

% Fatigue strength assumption: S''n = 0.65 Su at 1e6 cycles (given in HW)
Snprime_ti = 0.65*Su_ti;     % MPa baseline knee

% Marin factors for Ti (bending, d=25mm)
CL = 1.0;
CG = 0.9;
CR = 1.0;       % not specified in problem -> leave as 1 unless told otherwise
CT = 1.0;

% IMPORTANT: Chart starts ~60 ksi; Su_ti is ~33 ksi -> set CS_ti explicitly
CS_ti = 0.798;  % conservative: use fine-ground at 60 ksi as approximation
K_ti = CL*CG*CS_ti*CR*CT;

Sn_ti = K_ti*Snprime_ti;     % MPa (treated as flat beyond 1e6 here)

% Safety factor for 1e8 cycles using modified Goodman:
n5 = 1 / ( sigma_ea/Sn_ti + sigma_em/Su_ti );

fprintf('Assumed CS_ti=%.3f -> Sn_ti=%.3f MPa\n', CS_ti, Sn_ti);
fprintf('Safety factor at 1e8 cycles (Goodman) n=%.3f\n\n', n5);

% ---- Plot: Ti modified Goodman with endurance line, yield line, load line, operating point ----
sm = linspace(0, Su_ti, 400);
sa_end = Sn_ti*(1 - sm/Su_ti);               % Goodman endurance boundary (at/after knee)

% Yield line (sa + sm = Sy)
smy = linspace(0, Sy_ti, 300);
sa_y = Sy_ti - smy;

% Load line through origin with slope = sigma_ea/sigma_em
k = sigma_ea/sigma_em;
sa_load = k*sm;

figure('Name','P5: Modified Goodman (Titanium)');
hold on; grid on; box on;
plot(sm, sa_end, 'LineWidth', 2, 'DisplayName','Endurance boundary (assumed)');
plot(smy, sa_y, 'LineWidth', 2, 'DisplayName','Yield line: \sigma_{ea}+\sigma_{em}=S_y');
plot(sm, sa_load, 'LineWidth', 2, 'DisplayName','Load line: \sigma_{ea}/\sigma_{em} const');
plot(sigma_em, sigma_ea, 'o', 'MarkerSize', 8, 'LineWidth', 2, 'DisplayName','Operating point');

xlabel('\sigma_{em} (MPa)','Interpreter','tex');
ylabel('\sigma_{ea} (MPa)','Interpreter','tex');
title('Modified Goodman Diagram (Titanium, d=25 mm, fine-ground)');
legend('Location','northeast');
xlim([0 Su_ti]);
ylim([0 max([Sy_ti, Sn_ti])*1.10]);

%% =========================
% Local function: log-log interpolation
% =========================
function Sq = loglog_interp(N1, S1, N2, S2, Nq)
%LOGLOG_INTERP Interpolate S(N) on a log-log line between two points.
%   Given (N1,S1) and (N2,S2), returns Sq at Nq assuming log10(S) vs log10(N) linear.

    x1 = log10(N1); y1 = log10(S1);
    x2 = log10(N2); y2 = log10(S2);
    xq = log10(Nq);

    m = (y2 - y1) / (x2 - x1);
    yq = y1 + m*(xq - x1);

    Sq = 10^(yq);
end