M1 = 1600;   B1 = 780;
M2 = 2400;   B2 = 3500;
k  = 15000;

A = [ 0 1 0 0;
     -k/M1  -B1/M1   k/M1   0;
      0 0 0 1;
      k/M2   0     -k/M2  -B2/M2];

B = [0;0;0;1/M2];

C = [-k 0 k 0];   % spring force k(x2-x1)
D = 0;

sys = ss(A,B,C,D);

% Input signal
t = 0:.1:10;                  % simulate for 10 seconds
u = 750*ones(1,length(t));     % constant after ramp
u(1:floor(length(t)*.5)) = linspace(0,750,floor(length(t)*.5)); % ramp 0->750 over ~5s

Fs = lsim(sys,u,t);            % spring force over time

figure; plot(t,Fs); grid on
xlabel('Time (s)'); ylabel('Tow strap force (N)');
title('Tow strap tension vs time');

maxF = max(Fs)
