%% ME3221 HW4 - Fatigue failure limits (S-N curves + Goodman diagram)
clear; clc; close all;

MPa_per_ksi = 6.895; % 1 ksi = 6.895 MPa

%% Reliability factors
CR_90 = 0.897;  % from Table 8.1
CR_95 = 0.868;  % standard (table doesn't list)
CR_99 = 0.814;  % standard (table doesn't list)

%% Surface factors Cs (read from provided figure)
Cs_machined_174 = 0.662;  % machined at Su=174 ksi
Cs_machined_245 = 0.545;  % machined at Su=245 ksi
Cs_machined_82  = 0.777;  % machined at Su=82 ksi
Cs_polished_65  = 0.796;  % fine-ground/commercially polished at Su=65 ksi

%% Helper functions
loglog_interp_S = @(N,N1,S1,N2,S2) 10^( log10(S1) + ...
    (log10(S2)-log10(S1))*(log10(N)-log10(N1))/(log10(N2)-log10(N1)) );

solve_for_N = @(S,N1,S1,N2,S2) 10^( log10(N1) + ...
    (log10(S)-log10(S1))*(log10(N2)-log10(N1))/(log10(S2)-log10(S1)) );

%% -------------------- Problem 1 --------------------
Su1 = 1200; % MPa
S1000_1 = 0.9*Su1;
Snprime_1 = 0.5*Su1; % MPa at 1e6

CL = 1.0; CG1 = 0.9; CT1 = 1.0;
CS1 = Cs_machined_174; CR1 = CR_90;

Sn1 = Snprime_1*CL*CG1*CS1*CR1*CT1;

fprintf('Problem 1: Sn = %.3f MPa\n', Sn1);

% life at Sa=550 MPa
Sa = 550;
Nlife1 = solve_for_N(Sa,1e3,S1000_1,1e6,Sn1);
fprintf('Problem 1b: N(550 MPa) = %.3e cycles\n', Nlife1);

% Plot S-N
N = logspace(3,7,400);
S = zeros(size(N));
for i=1:numel(N)
    if N(i) <= 1e6
        S(i) = loglog_interp_S(N(i),1e3,S1000_1,1e6,Sn1);
    else
        S(i) = Sn1;
    end
end
figure; loglog(N,S,'LineWidth',2); grid on;
xlabel('N (cycles)'); ylabel('S_a (MPa)');
title('Problem 1: Steel S-N Curve');

%% -------------------- Problem 2 --------------------
HB = 490;
Su2 = 3.45*HB;      % MPa (typical correlation)
S1000_2 = 0.9*Su2;

Snprime2 = 0.5*Su2;
Snprime2_cap = min(Snprime2, 100*MPa_per_ksi); % 100 ksi cap for steel
CG2 = 1.0; CS2 = Cs_machined_245; CR2 = CR_95; CT2 = 1.0;

Sn2 = Snprime2_cap*CL*CG2*CS2*CR2*CT2;
fprintf('Problem 2: Su = %.3f MPa, Sn = %.3f MPa\n', Su2, Sn2);

Sa_allow2 = Sn2/2;
fprintf('Problem 2b: Sa_allow (n=2) = %.3f MPa\n', Sa_allow2);

% Plot S-N
N = logspace(3,7,400);
S = zeros(size(N));
for i=1:numel(N)
    if N(i) <= 1e6
        S(i) = loglog_interp_S(N(i),1e3,S1000_2,1e6,Sn2);
    else
        S(i) = Sn2;
    end
end
figure; loglog(N,S,'LineWidth',2); grid on;
xlabel('N (cycles)'); ylabel('S_a (MPa)');
title('Problem 2: Steel Plate S-N Curve');

%% -------------------- Problem 3 --------------------
Su3 = 450; % MPa
S1000_3 = 0.9*Su3;

Snprime3 = 0.4*Su3;
Snprime3_cap = min(Snprime3, 19*MPa_per_ksi); % 19 ksi cap for aluminum at 5e8
CG3 = 0.9; CS3 = Cs_polished_65; CR3 = CR_99;

Sn3 = Snprime3_cap*CL*CG3*CS3*CR3;
fprintf('Problem 3: Sn(5e8) = %.3f MPa\n', Sn3);

Sa_allow3 = loglog_interp_S(1e6,1e3,S1000_3,5e8,Sn3);
fprintf('Problem 3b: Sa_allow at 1e6 cycles = %.3f MPa\n', Sa_allow3);

% Plot S-N (no endurance limit; show up to 5e8)
N = logspace(3,9,500);
S = zeros(size(N));
for i=1:numel(N)
    if N(i) <= 5e8
        S(i) = loglog_interp_S(N(i),1e3,S1000_3,5e8,Sn3);
    else
        % extend same slope beyond 5e8 for plotting if desired
        S(i) = loglog_interp_S(N(i),1e3,S1000_3,5e8,Sn3);
    end
end
figure; loglog(N,S,'LineWidth',2); grid on;
xlabel('N (cycles)'); ylabel('S_a (MPa)');
title('Problem 3: Aluminum S-N Curve');

%% -------------------- Problem 4 & 5 (Goodman) --------------------
Su4 = 82; % ksi
Snprime4 = min(0.4*Su4, 19); % ksi (cap)
CG4 = 0.9; CS4 = Cs_machined_82; CR4 = CR_95;

Sf = Snprime4*CL*CG4*CS4*CR4; % ksi at 5e8
fprintf('Problem 4: Sf(5e8) = %.3f ksi\n', Sf);

% Goodman line: Sa = Sf*(1 - Sm/Su)
Sm = linspace(0,Su4,200);
Sa_line = Sf*(1 - Sm/Su4);

figure; plot(Sm,Sa_line,'LineWidth',2); grid on; hold on;
xlabel('\sigma_m (ksi)'); ylabel('\sigma_a (ksi)');
title('Problem 4: Goodman diagram constant-life line (5e8 cycles)');
xlim([0 Su4]); ylim([0 max(Sa_line)*1.1]);

% Load point
sm = 20; sa = 6;
plot(sm,sa,'o','LineWidth',2);

% Safety factors
nA = 1/(sa/Sf + sm/Su4);                 % proportional
sa_allow = Sf*(1 - sm/Su4); nB = sa_allow/sa;  % mean constant
sm_allow = Su4*(1 - sa/Sf); nC = sm_allow/sm;  % alt constant

fprintf('Problem 5: n_a=%.3f, n_b=%.3f, n_c=%.3f\n', nA, nB, nC);