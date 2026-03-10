%% ME 4031W Lab 2 - Thermocouple CSV Plotter (MATLAB)
% Loads a LabVIEW-exported .csv file and generates publication-ready plots.
% Expected columns: Time, Voltage, Temperature (order can vary).
%
% Notes:
% - Voltage may be either thermocouple EMF (V) OR the amplified DAQ voltage (V_DAQ).
%   If your file contains amplified voltage, set GAIN = 100 and the script will compute EMF.
% - Time is plotted as elapsed time starting at t = 0 s.

clear; clc; close all;

%% User settings
GAIN = 1;          % Set to 100 if 'Voltage' column is DAQ voltage after amplifier.
MAKE_VOLTAGE_PLOT = true;

%% Select file
[fileName, filePath] = uigetfile({'*.csv','CSV files (*.csv)'}, 'Select thermocouple .csv data');
if isequal(fileName,0)
    error('No file selected.');
end
file = fullfile(filePath, fileName);

%% Read table
T = readtable(file, 'VariableNamingRule','preserve');

% Find columns by name (case-insensitive)
vars = lower(string(T.Properties.VariableNames));
iTime = find(contains(vars,"time"), 1);
iVolt = find(contains(vars,"volt"), 1);
iTemp = find(contains(vars,"temp"), 1);

if isempty(iTime) || isempty(iVolt) || isempty(iTemp)
    error("Expected columns containing 'Time', 'Voltage', and 'Temperature'. Found: %s", ...
          strjoin(T.Properties.VariableNames, ', '));
end

t = double(T{:,iTime});
v_raw = double(T{:,iVolt});
temp = double(T{:,iTemp});

% Clean + sort
mask = ~(isnan(t) | isnan(v_raw) | isnan(temp));
t = t(mask); v_raw = v_raw(mask); temp = temp(mask);

[t, idx] = sort(t);
v_raw = v_raw(idx);
temp = temp(idx);

% Zero time
t = t - t(1);

% Convert voltage (if needed)
v_tc = v_raw / GAIN;      % thermocouple EMF in volts
v_tc_mV = v_tc * 1000;    % in mV

%% Helper: save figure robustly across MATLAB versions
saveFig = @(fig, outPng) local_save_figure(fig, outPng);

%% Plot: Temperature vs time
fig1 = figure;
plot(t, temp, '-');
grid on; box on;
xlabel('Time (s)');
ylabel('Temperature (^{\\circ}C)');
title('Thermocouple Response (Temperature vs Time)');
set(gca,'TickDir','in','FontSize',12,'LineWidth',1);
set(fig1,'Color','w');

[~, base, ~] = fileparts(file);
out1 = fullfile(filePath, [base '_Temperature.png']);
saveFig(fig1, out1);

%% Plot: EMF vs time (optional)
if MAKE_VOLTAGE_PLOT
    fig2 = figure;
    plot(t, v_tc_mV, '-');
    grid on; box on;
    xlabel('Time (s)');
    ylabel('Thermocouple EMF (mV)');
    title('Thermocouple Response (EMF vs Time)');
    set(gca,'TickDir','in','FontSize',12,'LineWidth',1);
    set(fig2,'Color','w');

    out2 = fullfile(filePath, [base '_Voltage.png']);
    saveFig(fig2, out2);
end

%% Quick check output
fprintf('Loaded: %s\\n', file);
fprintf('Rows: %d\\n', numel(t));
fprintf('Temperature range: %.2f to %.2f °C\\n', min(temp), max(temp));
fprintf('Thermocouple EMF range: %.3f to %.3f mV\\n', min(v_tc_mV), max(v_tc_mV));
fprintf('Saved figure(s) to:\\n  %s\\n', out1);
if MAKE_VOLTAGE_PLOT
    fprintf('  %s\\n', out2);
end

%% Local function (must be at end of script for older MATLAB)
function local_save_figure(fig, outPng)
    % Try exportgraphics (newer), fallback to print (older)
    try
        exportgraphics(fig, outPng, 'Resolution', 300);
    catch
        print(fig, outPng, '-dpng', '-r300');
    end
end
