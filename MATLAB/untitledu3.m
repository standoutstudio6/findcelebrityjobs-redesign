%% HW3 – Problem 2(c): Brittle composite thickness using Modified Mohr
%  - Computes required wall thickness t (m) for safety factor n
%  - Sketches the Modified Mohr failure envelope (axes labeled)
%  - Plots the load point (sigma1, sigma2) at the designed thickness
%
%  Matches the class "brittle failure example" logic:
%    1) Compute principal stresses (plane stress)
%    2) Determine region using slope sigma2/sigma1 compared to -1
%    3) Region A -> sigma1 limited by Sut
%       Region B -> interaction line between (Sut,0) and (0,-Suc)

clear; clc; close all;

%% GIVEN (Problem 2)
% Stresses given in the problem are:
%   sigma_x = (900e3)/t   [Pa]
%   tau_xy  = (300e3)/t   [Pa]
%   sigma_y = 0
% where t is in meters.
sigx_coef = 900e3;   % (Pa*m) so that sigx = sigx_coef/t
sigy_coef = 0;       % (Pa*m)
tau_coef  = 300e3;   % (Pa*m)

%% Brittle composite material properties (Problem 2c)
Sut = 250e6;   % Pa (ultimate tensile strength)
Suc = 600e6;   % Pa (ultimate compressive strength)
n   = 2.5;     % safety factor

Sut_allow = Sut / n;  % Pa
Suc_allow = Suc / n;  % Pa

%% Helper: principal stresses for plane stress (sigma_z = 0)
principal2D = @(sx,sy,txy) deal( ...
    (sx+sy)/2 + sqrt(((sx-sy)/2).^2 + txy.^2), ...
    (sx+sy)/2 - sqrt(((sx-sy)/2).^2 + txy.^2) );

%% Because all stresses scale as 1/t, the principal stresses also scale as 1/t.
% Compute principal stresses at a reference thickness t_ref = 1 m
t_ref   = 1.0;                     % m
sx_ref  = sigx_coef / t_ref;       % Pa
sy_ref  = sigy_coef / t_ref;       % Pa
txy_ref = tau_coef  / t_ref;       % Pa

[sA, sB] = principal2D(sx_ref, sy_ref, txy_ref);

% Match the instructor envelope plot convention: x-axis = sigma1 (max), y-axis = sigma2 (min)
sigma1_ref = max(sA, sB);   % Pa at t_ref
sigma2_ref = min(sA, sB);   % Pa at t_ref

% "Constants" so that sigma1(t) = sigma1_const / t, sigma2(t) = sigma2_const / t
sigma1_const = sigma1_ref * t_ref;  % Pa*m
sigma2_const = sigma2_ref * t_ref;  % Pa*m

slope = sigma2_const / sigma1_const;  % independent of t

%% Determine Modified Mohr region (per class example)
% Region A if slope >= -1  (i.e., |sigma2| <= |sigma1| in mixed-sign quadrant)
if slope >= -1
    region = "A (tension-governed: sigma1 limit)";
    % Region A criterion with safety factor:
    %   sigma1 <= Sut/n  => (sigma1_const/t) <= Sut_allow  => t >= sigma1_const/Sut_allow
    t_req = sigma1_const / Sut_allow;  % m
else
    region = "B (interaction line: sigma1/Sut - sigma2/Suc = 1)";
    % Region B interaction (with allowable strengths):
    %   (sigma1/Sut_allow) - (sigma2/Suc_allow) <= 1
    % Substitute sigma1 = sigma1_const/t, sigma2 = sigma2_const/t:
    %   (1/t)[sigma1_const/Sut_allow - sigma2_const/Suc_allow] <= 1
    % => t >= sigma1_const/Sut_allow - sigma2_const/Suc_allow
    t_req = (sigma1_const/Sut_allow) - (sigma2_const/Suc_allow); % m
end

%% Compute stresses at the designed thickness
sx  = sigx_coef / t_req;   % Pa
sy  = sigy_coef / t_req;   % Pa
txy = tau_coef  / t_req;   % Pa

[s1, s2] = principal2D(sx, sy, txy);
sigma1 = max(s1, s2);   % Pa
sigma2 = min(s1, s2);   % Pa

%% Compute achieved safety factor (check)
if slope >= -1
    % Region A uses sigma1 * n <= Sut  => n = Sut/sigma1
    n_actual = Sut / sigma1;
else
    % Region B uses (sigma1/Sut) - (sigma2/Suc) <= 1/n
    n_actual = 1 / ( (sigma1/Sut) - (sigma2/Suc) );
end

%% Print results
fprintf("=== HW3 Problem 2(c) – Modified Mohr ===\n");
fprintf("Region: %s\n", region);
fprintf("Slope sigma2/sigma1 = %.4f (compare to -1)\n", slope);
fprintf("Required thickness t = %.6f m  = %.3f mm\n", t_req, 1e3*t_req);
fprintf("Load point at t_req:\n");
fprintf("  sigma1 = %.3f MPa\n", sigma1/1e6);
fprintf("  sigma2 = %.3f MPa\n", sigma2/1e6);
fprintf("Achieved safety factor n_actual = %.3f (target n = %.3f)\n\n", n_actual, n);

%% Plot Modified Mohr envelope (with allowable strengths) and load point
SutA = Sut_allow/1e6;  % MPa
SucA = Suc_allow/1e6;  % MPa

% Envelope segments in (sigma1, sigma2) plane
% (per the class sketch)
%  - Right/top tension limits: sigma1 =  SutA, sigma2 =  SutA
%  - Left/bottom compression limits: sigma1 = -SucA, sigma2 = -SucA
%  - Diagonal in QII:  line from (-SucA,0) to (0,SutA)
%  - Diagonal in QIV:  line from (0,-SucA) to (SutA,0)

figure('Color','w'); hold on; grid on;
xlabel('\sigma_1 (MPa)  [maximum principal]');
ylabel('\sigma_2 (MPa)  [minimum principal]');
title(sprintf('Modified Mohr Failure Envelope (SF = %.2f) with Load Point', n));

% Box limits
plot([ SutA  SutA], [-SucA  SutA], 'k-', 'LineWidth', 2); % sigma1 = SutA
plot([-SucA -SucA], [-SucA  SutA], 'k-', 'LineWidth', 2); % sigma1 = -SucA
plot([-SucA  SutA], [ SutA  SutA], 'k-', 'LineWidth', 2); % sigma2 = SutA
plot([-SucA  SutA], [-SucA -SucA], 'k-', 'LineWidth', 2); % sigma2 = -SucA

% Diagonal lines (interaction boundaries)
plot([-SucA 0], [0 SutA], 'k-', 'LineWidth', 2);         % QII diagonal
plot([0 SutA], [-SucA 0], 'k-', 'LineWidth', 2);         % QIV diagonal

% Region divider used in class example: sigma2/sigma1 = -1
% (draw it for reference)
m = -1;
xline = linspace(0, SutA, 200);
plot(xline, m*xline, 'k--', 'LineWidth', 1.5);

% Load point
plot(sigma1/1e6, sigma2/1e6, 'ko', 'MarkerFaceColor','k', 'MarkerSize', 7);
text(sigma1/1e6 + 3, sigma2/1e6, sprintf('Load point (%.1f, %.2f) MPa', sigma1/1e6, sigma2/1e6), ...
    'FontSize', 11, 'VerticalAlignment','bottom');

axis equal;
xlim([-1.15*SucA, 1.75*SutA]);
ylim([-1.15*SucA, 1.35*SutA]);

% Extra labels
text(SutA, -0.06*SucA, 'S_{ut}/n', 'HorizontalAlignment','center');
text(-SucA, -0.06*SucA, '-S_{uc}/n', 'HorizontalAlignment','center');

hold off;
