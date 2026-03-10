%% HW3 – Problem 2c: Modified Mohr failure envelope + load point (MATLAB)
%  Plots the brittle "Modified Mohr" envelope in the (sigma1, sigma3) plane
%  (sigma1 = max principal, sigma3 = min principal), INCLUDING safety factor n,
%  and plots the load point from the given stress state in Problem 2.
%
%  Given stress state (from HW3 #2):
%     sigma_x = 900e3 / t   (Pa)   ,  sigma_y = 0
%     tau_xy  = 300e3 / t   (Pa)
%
%  Material (Problem 2c):
%     Sut = 250 MPa, Suc = 600 MPa, n = 2.5

clear; clc; close all;

%% -------------------- Inputs --------------------
Sut = 250;     % MPa (ultimate tensile strength)
Suc = 600;     % MPa (ultimate compressive strength magnitude)
n   = 2.5;     % safety factor

% Stress expressions: sigma_x = coeff/t, tau_xy = coeff/t  (Pa, with t in meters)
sigma_x_coeff = 900e3;   % Pa*m
tau_coeff     = 300e3;   % Pa*m

%% -------------------- Allowables (with n) --------------------
Sut_allow = Sut / n;     % MPa
Suc_allow = Suc / n;     % MPa  (still positive magnitude; use -Suc_allow on plot)

%% -------------------- Pick thickness t --------------------
% Option A: set t manually (meters)
% t = 10e-3;

% Option B (recommended for 2c): choose t that just meets Region-A limit: sigma1 = Sut_allow
% sigma1(t) = 0.5*sigma_x + sqrt((0.5*sigma_x)^2 + tau^2) = (sigma1_coeff)/t
sigma1_coeff_Pa_m = 0.5*sigma_x_coeff + sqrt((0.5*sigma_x_coeff)^2 + (tau_coeff)^2);
t = sigma1_coeff_Pa_m / (Sut_allow * 1e6);   % meters

%% -------------------- Compute stress state at this t --------------------
sigma_x = (sigma_x_coeff / t) / 1e6;   % MPa
sigma_y = 0;                           % MPa
tau_xy  = (tau_coeff     / t) / 1e6;   % MPa

% Principal stresses (plane stress)
avg = 0.5*(sigma_x + sigma_y);
R   = sqrt( (0.5*(sigma_x - sigma_y))^2 + tau_xy^2 );
s1  = avg + R;
s2  = avg - R;
s3  = 0;

% Order so sigma1 >= sigma2 >= sigma3
s = sort([s1 s2 s3],'descend');
sigma1 = s(1); sigma2 = s(2); sigma3 = s(3);

%% -------------------- Modified Mohr Envelope (with safety factor included) --------------------
% In the (sigma1, sigma3) plane, the common "modified Mohr" envelope sketch is a
% polygon with corners at:
%   (0, +Sut_allow), (+Sut_allow, +Sut_allow), (+Sut_allow, 0),
%   (0, -Suc_allow), (-Suc_allow, -Suc_allow), (-Suc_allow, 0), back to start.

env_x = [ 0,  Sut_allow,  Sut_allow, 0, -Suc_allow, -Suc_allow, 0 ];
env_y = [ Sut_allow, Sut_allow, 0, -Suc_allow, -Suc_allow, 0, Sut_allow ];

%% -------------------- Plot --------------------
figure('Color','w'); hold on; grid on; box on;

plot(env_x, env_y, 'LineWidth', 2);                          % envelope
plot(sigma1, sigma3, 'ko', 'MarkerFaceColor','k', ...
     'MarkerSize', 7);                                      % load point

% Divider line often used in class sketches: sigma3/sigma1 = -1
xx = linspace(0, Sut_allow*1.15, 200);
plot(xx, -xx, '--', 'LineWidth', 1.2);

xlabel('\sigma_1 (MPa)  [max principal]');
ylabel('\sigma_3 (MPa)  [min principal]');
title('Modified Mohr Failure Envelope (Brittle) – with Safety Factor Included');

% Annotate key strengths
text(Sut_allow, -0.05*Suc_allow, 'S_{ut}/n', 'HorizontalAlignment','center', 'FontSize',11);
text(-Suc_allow, -0.05*Suc_allow, '-S_{uc}/n', 'HorizontalAlignment','center', 'FontSize',11);
text(0.02*Sut_allow, Sut_allow, 'S_{ut}/n', 'VerticalAlignment','middle', 'FontSize',11);
text(0.02*Sut_allow, -Suc_allow, '-S_{uc}/n', 'VerticalAlignment','middle', 'FontSize',11);
text(Sut_allow*0.55, -Sut_allow*0.55, '\sigma_3/\sigma_1 = -1', ...
     'Rotation', -45, 'FontSize', 11);

% Label load point
txt = sprintf('Load point (%.1f, %.1f) MPa', sigma1, sigma3);
text(sigma1*0.60, -Suc_allow*0.35, txt, 'FontSize', 11);
plot([sigma1, sigma1*0.62], [sigma3, -Suc_allow*0.33], 'LineWidth', 1.2);

% Nice limits
pad = 0.15;
xlim([-Suc_allow*(1+pad), Sut_allow*(1+pad)]);
ylim([-Suc_allow*(1+pad), Sut_allow*(1+pad)]);
axis equal;

%% -------------------- Print key results --------------------
fprintf('--- Problem 2c results (with safety factor n=%.2f) ---\n', n);
fprintf('Designed thickness t = %.4f mm\n', t*1e3);
fprintf('sigma_x = %.2f MPa, tau_xy = %.2f MPa\n', sigma_x, tau_xy);
fprintf('Principal stresses: sigma1=%.2f MPa, sigma2=%.2f MPa, sigma3=%.2f MPa\n', ...
        sigma1, sigma2, sigma3);
