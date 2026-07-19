clear; clc; close all;

%% PLOT XLSX

%% Load Excel file
fileName = "FE13CAN_20260601_160911_Chris_reduced.xlsx";   % change this to "filename.xlsx" 
sheetName = "Sheet1";                 % change this if needed

data = readtable(fileName, "Sheet", sheetName);

%% Select columns by number
timeCol = 1;        % time column
mcTempCol = 9;      % motor controller temp column
motorTempCol = 11;   % motor temp column

%% Extract columns
time = data{:, timeCol};
mcTemp = data{:, mcTempCol};
motorTemp = data{:, motorTempCol};

%% Keep only rows where each temperature actually exists
validMC = ~isnan(time) & ~isnan(mcTemp);
validMotor = ~isnan(time) & ~isnan(motorTemp);

timeMC = time(validMC);
mcTemp = mcTemp(validMC);

timeMotor = time(validMotor);
motorTemp = motorTemp(validMotor);

%% Plot
figure;

plot(timeMC, mcTemp, 'LineWidth', 1.0);
hold on;
plot(timeMotor, motorTemp, 'LineWidth', 1.0);
hold off;

%% Formatting
title('Motor and MC Temps');
xlabel('Time [s]');
ylabel('Temperature [C]');

legend('MC Temps', 'Motor Temps', 'Location', 'southeast');

grid on;
box on;

xlim([min(time), max(time)]);
ylim([20, 70]);   % adjust if needed

set(gca, 'FontSize', 10);
set(gcf, 'Color', 'w');

%% PLOT CSV


