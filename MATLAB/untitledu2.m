%% HW3 - Problem 4(b): Plot R_ins, R_conv, and R_tot vs outer radius r_o
% Assumes a long cylinder (pipe) with negligible wall thickness.
% Resistances are per LENGTH L (here L=1 m), units: K/W.

clear; clc; close all;

%% -------------------- GIVEN --------------------
Ti   = 80;        % inner insulation surface temperature (°C)
Tinf = 20;        % ambient air temperature (°C)
ri   = 0.03;      % inner radius (m) = 3 cm
h    = 5;         % convection coefficient (W/m^2-K)
kins = 0.19;      % insulation thermal conductivity (W/m-K)
L    = 1.0;       % length (m) (use 1 m to get K/W per meter)

%% -------------------- SET RANGE FOR r_o --------------------
% Choose a range that includes the critical radius r_cr = kins/h
rcr = kins / h;                 % critical radius for cylinder (m)

ro_min = ri;
ro_max = 0.15;                  % 15 cm outer radius (adjust as desired)
N      = 400;                   % number of points in plot
ro     = linspace(ro_min, ro_max, N);   % outer radius vector (m)

%% -------------------- THERMAL RESISTANCES --------------------
% Conduction through insulation (cylinder):
%   R_ins = ln(ro/ri) / (2*pi*kins*L)
R_ins  = log(ro./ri) ./ (2*pi*kins*L);

% Convection at outer surface:
%   R_conv = 1 / (h*2*pi*ro*L)
R_conv = 1 ./ (h*2*pi*ro*L);

% Total series resistance:
R_tot  = R_ins + R_conv;

%% -------------------- PLOT RESISTANCES --------------------
figure;
plot(ro*100, R_ins,  'LineWidth', 1.8); hold on;  % ro*100 => cm on x-axis
plot(ro*100, R_conv, 'LineWidth', 1.8);
plot(ro*100, R_tot,  'LineWidth', 2.2);

% Mark critical radius
if rcr >= ro_min && rcr <= ro_max
    xline(rcr*100, '--', sprintf('r_{cr}=%.1f cm', rcr*100), 'LineWidth', 1.5);
else
    % If your ro range doesn't include rcr, warn in command window
    warning('Critical radius rcr=%.4f m not inside plot range.', rcr);
end

grid on;
xlabel('Outer radius r_o (cm)');
ylabel('Thermal resistance per meter (K/W)');
title('Problem 4(b): R_{ins}, R_{conv}, and R_{tot} vs outer radius r_o');
legend('R_{ins} (conduction)', 'R_{conv} (convection)', 'R_{tot} = R_{ins}+R_{conv}', 'Location', 'best');

%% -------------------- OPTIONAL: QUICK NUMERIC VERIFICATION --------------------
% Heat loss per meter (W/m): q = (Ti - Tinf)/R_tot
DeltaT = Ti - Tinf;
q_per_m = DeltaT ./ R_tot;

% Display a few key values in the command window:
% - Bare pipe (no insulation): ro=ri => R_ins=0, R_tot=R_conv(ri)
R_bare = 1 / (h*2*pi*ri*L);
q_bare = DeltaT / R_bare;

% - At critical radius (if within range)
q_at_rcr = NaN;
if rcr >= ro_min && rcr <= ro_max
    R_at_rcr = log(rcr/ri)/(2*pi*kins*L) + 1/(h*2*pi*rcr*L);
    q_at_rcr = DeltaT / R_at_rcr;
end

fprintf('--- Verification ---\n');
fprintf('r_cr = %.4f m = %.2f cm\n', rcr, rcr*100);
fprintf('Bare (ro=ri=%.2f cm): R_tot=%.4f K/W, q=%.2f W/m\n', ri*100, R_bare, q_bare);
if ~isnan(q_at_rcr)
    fprintf('At r_cr (%.2f cm): q=%.2f W/m (should be near maximum)\n', rcr*100, q_at_rcr);
end
