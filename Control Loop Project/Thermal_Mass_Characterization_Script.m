%% Motor and Motor Controller (MC) Thermal Mass Characterization Script
% FE11 Blue Max Endurance Data 
% Cooling Loop Configuration:   
% Raditor -> Temp Sensor -> Motor -> MC -> Temp Sensor -> Radiator

clc; close all
% clear all
motor_efficiency = 0.94;

mc_temps = readmatrix("MC_Temps.csv"); % [°C]
mc_times = mc_temps(:,1);
motor_temps = readmatrix("Motor_Temps.csv"); % [°C]
water_air_temps = readmatrix("Water_Air_Temps.csv"); % [°C]
data = readmatrix("FE11 Endurance Full Data V2.xlsx");

voltage = data(:,2); % [V]
current = data(:,3); % [A]
power = voltage.*current; % [W]
times = (0:data(end,1)/(length(data(:,1))-1):data(end,1))'; % [s]

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
q_gen_mc = mc_heat(voltage,abs(current)); % taking absolute value of current since direction does not matter for heat generation
q_gen_motor = power.*(1-motor_efficiency);
q_gen_motor_abs = abs(power).*(1-motor_efficiency);

avg_motor_q_gen = mean(q_gen_motor);
avg_mc_q_gen = mean(q_gen_mc);

%% Cooldown Scenario
cooldown_start_time = 1365; % [s] gotten from manually looking at cooldown start time
cooldown_end_time = 1500; % [s] gotten from manually looking at cooldown end time
cooldown_start_time_index = find_index_from_time(cooldown_start_time,times); 
cooldown_end_time_index = find_index_from_time(cooldown_end_time,times);
cooldown_times = times(cooldown_start_time_index:cooldown_end_time_index);

final_cooldown_start_time = 2300; % [s] gotten from manually looking at cooldown start time
final_cooldown_start_time_index = find_index_from_time(final_cooldown_start_time,times); 
final_cooldown_times = times(final_cooldown_start_time_index:end);

[~, unique_mc_row_index, ~] = unique(mc_times);
unique_mc_times = mc_times(unique_mc_row_index);
unique_mc_temps = mc_temps(unique_mc_row_index,:);
unique_motor_temps = motor_temps(unique_mc_row_index,:);

[~, unique_water_row_index, ~] = unique(water_air_temps(:,1));
unique_water_times = water_air_temps(unique_water_row_index,1);
unique_water_in_temps = water_air_temps(unique_water_row_index,2);
unique_water_out_temps = water_air_temps(unique_water_row_index,3);

new_mc_temps = interp1(unique_mc_times,filloutliers(unique_mc_temps(:,4),"previous","movmedian",5),times,"linear");
new_motor_temps = interp1(unique_mc_times,filloutliers(unique_motor_temps(:,2),"previous","movmedian",5),times,"linear");
new_water_in_temps = interp1(unique_water_times,filloutliers(unique_water_in_temps,"previous","movmedian",5),times,"linear");
new_water_out_temps = interp1(unique_water_times,filloutliers(unique_water_out_temps,"previous","movmedian",5),times,"linear");

y1_cooldown_mc_temps = new_mc_temps(cooldown_start_time_index:cooldown_end_time_index);
y2_cooldown_mc_temps = new_mc_temps(cooldown_start_time_index+1:cooldown_end_time_index+1);
y1_cooldown_motor_temps = new_motor_temps(cooldown_start_time_index:cooldown_end_time_index);
y2_cooldown_motor_temps = new_motor_temps(cooldown_start_time_index+1:cooldown_end_time_index+1);
x1_cooldown_times = times(cooldown_start_time_index:cooldown_end_time_index);
x2_cooldown_times = times(cooldown_start_time_index+1:cooldown_end_time_index+1);

d_mc_temp_dt = backwards_euler(y1_cooldown_mc_temps,y2_cooldown_mc_temps,x1_cooldown_times,x2_cooldown_times);
d_motor_temp_dt = backwards_euler(y1_cooldown_motor_temps,y2_cooldown_motor_temps,x1_cooldown_times,x2_cooldown_times);

cooldown_water_in_temps = new_water_in_temps(cooldown_start_time_index:cooldown_end_time_index);
cooldown_water_out_temps = new_water_out_temps(cooldown_start_time_index:cooldown_end_time_index);

delta_water_temps = cooldown_water_out_temps - cooldown_water_in_temps;

figure % this figure shows the voltage and current side-by-side
subplot(1,2,1)
plot(times,voltage)
title("Voltage")
subplot(1,2,2)
plot(times,current)
title("current")

figure % this figure shows that the motor generates more heat than the motor controller
hold on
plot(times,q_gen_mc,'DisplayName','MC')
plot(times,q_gen_motor_abs,'DisplayName','Motor')
hold off
legend('Location','best')
title("Heat Generation in MC and Motor")
ylabel("Q_gen [W]")
xlabel("Time [s]")

figure % this figure compares the reinterpolated motor and mc temps to the old motor and mc temps
hold on
plot(mc_times,mc_temps(:,4),'DisplayName','Old MC Temps')
plot(motor_temps(:,1),motor_temps(:,2),'DisplayName','Old Motor Temps')
plot(times,new_mc_temps,'DisplayName','New MC Temps')
plot(times,new_motor_temps,'DisplayName','New Motor Temps')
hold off
xlabel('Time [s]')
ylabel('Temperature [°C]')
grid on
legend

figure % this figure compares the reinterpolated water temps to the old water temps
hold on
plot(water_air_temps(:,1),water_air_temps(:,2),'DisplayName','Old Inlet Temps')
plot(water_air_temps(:,1),water_air_temps(:,3),'DisplayName','Old Outlet Temps')
plot(times,new_water_in_temps,'DisplayName','New Inlet Temps')
plot(times,new_water_out_temps,'DisplayName','New Outlet Temps')
hold off
xlabel('Time [s]')
ylabel('Temperature [°C]')
grid on
legend

figure % this figure shows motor, mc and water temps
figure % this figure compares the reinterpolated water temps to the old water temps
hold on
plot(times,new_water_in_temps,'DisplayName','New Inlet Temps')
plot(times,new_water_out_temps,'DisplayName','New Outlet Temps')
plot(times,new_mc_temps,'DisplayName','New MC Temps')
plot(times,new_motor_temps,'DisplayName','New Motor Temps')
hold off
xlabel('Time [s]')
ylabel('Temperature [°C]')
grid on
legend

figure % this figure shows motor, mc and water temps for the cooldown period
hold on
plot(cooldown_times,y1_cooldown_mc_temps,'DisplayName','MC Temps')
plot(cooldown_times,y1_cooldown_motor_temps,'DisplayName','Motor Temps')
plot(cooldown_times,cooldown_water_in_temps,'DisplayName','Water In Temps')
plot(cooldown_times,cooldown_water_out_temps,'DisplayName','Water Out Temps')
hold off
xlabel('Time [s]')
ylabel('Temperature [°C]')
grid on
legend

figure % this figure shows dT/dt during cooldown for the motor and mc
subplot(2,1,1)
plot(cooldown_times,d_mc_temp_dt,'b')
xlabel('Time [s]')
xlim([cooldown_start_time,cooldown_end_time])
ylabel('Temperature Change [°C/s]')
title('MC Temp During Cooldown')
subplot(2,1,2)
plot(cooldown_times,d_motor_temp_dt,'b')
xlabel('Time [s]')
xlim([cooldown_start_time,cooldown_end_time])
ylabel('Temperature Change [°C/s]')
title('Motor Temp During Cooldown')

figure % this figure shows motor, mc and water temps for the final cooldown period
hold on
plot(final_cooldown_times,new_mc_temps(final_cooldown_start_time_index:end),'DisplayName','MC Temps')
plot(final_cooldown_times,new_motor_temps(final_cooldown_start_time_index:end),'DisplayName','Motor Temps')
plot(final_cooldown_times,new_water_in_temps(final_cooldown_start_time_index:end),'DisplayName','Water In Temps')
plot(final_cooldown_times,new_water_out_temps(final_cooldown_start_time_index:end),'DisplayName','Water Out Temps')
hold off
xlabel('Time [s]')
ylabel('Temperature [°C]')
grid on
legend

% From the plots of the MC, motor and water temps during the cooldown
% period, it seems that the thermal mass of the MC is negligible given the
% MC temperature sensor chosen. Upon further inspection, it seems like the
% same can be said regardless of the MC temperature sensor chosen. This
% could simplify our calculation of C_p for the motor, however, we would
% still need a C_p for our motor controller to predict its temperature.

% Where does the power loss equation come from for the MC because I still
% do not trust the offset. I guess when we simulate it it will become
% obvious if something it is wrong.

%% Supporting Functions
function q_gen_mc = mc_heat(V,I)
    a = 0.000244;
    b = 1.073;
    c = 1.744;
    offset = 268; % this offset may be invalid for zero power consumption: something to look into
    q_gen_mc = a.*V.^b .* I.^c + offset;
end

function dydx = backwards_euler(y_1,y_2,x_1,x_2)
    dydx = (y_2-y_1)./(x_2-x_1);
end

function times_index = find_index_from_time(time,times)
    difference = times - time;
    [~,times_index] = min(abs(difference));
end