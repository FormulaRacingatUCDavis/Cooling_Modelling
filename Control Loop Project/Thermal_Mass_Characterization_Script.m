%% Motor and Motor Controller (MC) Thermal Mass Characterization Script
% Using FE11 Blue Max Endurance Data 
% Cooling Loop Configuration:   
% Raditor -> Temp Sensor -> Motor -> MC -> Temp Sensor -> Radiator
clc; close all
% clear all
motor_efficiency = 0.94;

MC_Temps = readmatrix("MC_Temps.csv"); % [°C]
MC_times = MC_Temps(:,1);
Motor_Temps = readmatrix("Motor_Temps.csv"); % [°C]
Water_Air_Temps = readmatrix("Water_Air_Temps.csv"); % [°C]
data = readmatrix("FE11 Endurance Full Data V2.xlsx");
voltage = data(:,2); % [V]
current = data(:,3); % [A]
power = voltage.*current; % [W]
times =  (0:data(end,1)/(length(data(:,1))-1):data(end,1))'; % [s]
p = 0;
counter = 0;
for i = 1:length(power)
    if power(i) > 1000
        p = p + power(i);
        counter = counter +1;
    end
end
avg_power = sum(p)/(1000*counter);

%% Heat Generation Calcs
q_gen_mc = MC_Heat(voltage,abs(current)); %taking absolute of current since direction does not matter for heat gen for us
q_gen_motor = power.*(1-motor_efficiency);

avg_motor_q_gen = mean(q_gen_motor);
avg_mc_q_gen = mean(q_gen_mc);

figure()
hold on
plot(times,q_gen_MC_abs,'DisplayName','MC')
plot(times,q_gen_motor,'DisplayName','Motor')
legend('Location','best')
title("Heat Generation in MC and Motor")
ylabel("Q_gen [W]")
xlabel("Time [s]")

% figure()
% subplot(1,2,1)
% plot(times,voltage)
% title("Voltage")
% subplot(1,2,2)
% plot(times,current)
% title("current")

%% Cooldown Scenario
cooldown_start_time_index = 4940; %gotten from manually looking at cooldown start time
cooldown_end_time_index = 5448; 

% new_MC_temp = interp1(MC_times,filloutliers(MC_Temps(:,4),"previous","movmedian",5), times, "linear")
% first input is double
[~,unique_index,~] = unique(MC_times(2:end));

new_MC_temp = interp1(MC_times(unique_index),MC_Temps(unique_index,4), times, "linear")


% dTmotor_dt = backwards_euler()

%% Supporting Functions
function q_gen_mc = MC_Heat(V,I)
    a = 0.000244;
    b = 1.073;
    c = 1.744;
    offset = 268;
    q_gen_mc = a.*V.^b .* I.^c + offset;
end

function dydx = backwards_euler(y_1,y_2,x_1,x_2)
    dydx = (y_2-y_1)/(x_2-x_1);
end