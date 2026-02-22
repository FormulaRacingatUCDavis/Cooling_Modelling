%% Motor and Motor Controller (MC) Thermal Mass Characterization Script
% FE11 Blue Max Endurance Data 
% Cooling Loop Configuration:   
% Raditor -> Temp Sensor -> Motor -> MC -> Temp Sensor -> Radiator

%% Workspace
clc; close all
% clear all

%% Data
orig_data = readmatrix("FE11 Endurance Full Data V2.xlsx");
data_zeros = nnz(orig_data(:,1) == 0);
data_front_cut = orig_data(((data_zeros-1):end),:);
data = average_duplicates(data_front_cut);
times = data(:,1); % [s]
% times = (0:data(end,1)/(length(data(:,1))-1):data(end,1))'; % [s]
voltage = data(:,2); % [V]
current = data(:,3); % [A]

mc_temps = readmatrix("MC_Temps.csv"); % [°C]
mc_times = mc_temps(:,1);
mc_temp = mc_temps(:,4);
new_mc_temps = reinterpolate(mc_times,mc_temp,times);

motor_temps = readmatrix("Motor_Temps.csv"); % [°C]
motor_times = motor_temps(:,1);
motor_temp = motor_temps(:,2);
new_motor_temps = reinterpolate(motor_times,motor_temp,times);

water_air_temps = readmatrix("Water_Air_Temps.csv"); % [°C]
water_motor_inlet = water_air_temps(:,2);
water_mc_outlet = water_air_temps(:,3);
water_times = water_air_temps(:,1);
new_water_in_temps = reinterpolate(water_times,water_motor_inlet,times);
new_water_out_temps = reinterpolate(water_times,water_mc_outlet,times);

all_data = [times,new_mc_temps,new_motor_temps,new_water_in_temps,new_water_out_temps];

% old reinterpolation code
% [~, unique_mc_row_index, ~] = unique(mc_times);
% unique_mc_times = mc_times(unique_mc_row_index);
% unique_mc_temps = mc_temps(unique_mc_row_index,:);
% unique_motor_temps = motor_temps(unique_mc_row_index,:);
% 
% [~, unique_water_row_index, ~] = unique(water_air_temps(:,1));
% unique_water_times = water_air_temps(unique_water_row_index,1);
% unique_water_in_temps = water_air_temps(unique_water_row_index,2);
% unique_water_out_temps = water_air_temps(unique_water_row_index,3);
% 
% new_mc_temps = interp1(unique_mc_times,filloutliers(unique_mc_temps(:,4),"nearest","movmedian",5),times,"linear");
% new_motor_temps = interp1(unique_mc_times,filloutliers(unique_motor_temps(:,2),"nearest","movmedian",5),times,"linear");
% new_water_in_temps = interp1(unique_water_times,filloutliers(unique_water_in_temps,"nearest","movmedian",5),times,"linear");
% new_water_out_temps = interp1(unique_water_times,filloutliers(unique_water_out_temps,"nearest","movmedian",5),times,"linear");

%% Power
power = voltage.*current; % [W]

p = 0;
counter = 0;
for i = 1:length(power)
    if power(i) > 1000
        p = p + power(i);
        counter = counter +1;
    end
end
avg_power = sum(p)/(1000*counter); % [W]

%% Heat Generation
motor_efficiency = 0.94;

q_gen_mc = mc_heat(voltage,abs(current)); % [W] taking absolute value of current since direction does not matter for heat generation
q_gen_motor = power.*(1-motor_efficiency); % [W]
q_gen_motor_abs = abs(power).*(1-motor_efficiency);
q_gen = q_gen_mc+q_gen_motor_abs; % [W]
Q_gen = power_to_energy(times,q_gen);

avg_motor_q_gen = mean(q_gen_motor); % [W]
avg_mc_q_gen = mean(q_gen_mc); % [W]

%% Radiator Heat Rejection
v_dot = 7; % [LPM]
Cp_water = 4186; % [J/(kg*K)]

liters_to_meters_cubed = 1/1000; % [m^3/L]
seconds_to_minutes = 1/60; % [min/s]
density_water = 1000; % [kg/m^3]
m_dot = v_dot*liters_to_meters_cubed*seconds_to_minutes*density_water; % [kg/s]

q_out = m_dot*Cp_water*(new_water_out_temps-new_water_in_temps); % [W]
Q_out_check = power_to_energy(times,q_out); % [J]
Q_out = rad_q_out(m_dot,Cp_water,new_water_in_temps,new_water_out_temps,times); % [J]

%% Test Intervals
pad = 10; % [s]

ramp_1_start_time = 760+pad; % [s] gotten from manual inspection
ramp_1_end_time = 1350-pad; % [s] gotten from manual inspection
ramp_1_start_index = find_index_from_time(ramp_1_start_time,times);
ramp_1_end_index = find_index_from_time(ramp_1_end_time,times);

cooldown_1_start_time = 1350+pad; % [s] gotten from manual inspection
cooldown_1_end_time = 1515-pad; % [s] gotten from manual inspection
cooldown_1_start_index = find_index_from_time(cooldown_1_start_time,times);
cooldown_1_end_index = find_index_from_time(cooldown_1_start_time,times);

ramp_2_start_time = 1515+pad; % [s] gotten from manual inspection
ramp_2_end_time = 2380-pad; % [s] gotten from manual inspection
ramp_2_start_index = find_index_from_time(ramp_2_start_time,times);
ramp_2_end_index = find_index_from_time(ramp_2_end_time,times);

cooldown_2_start_time = 2380+pad; % [s] gotten from manual inspection
cooldown_2_end_time = times(end); % [s]
cooldown_2_start_index = find_index_from_time(cooldown_2_start_time,times);
cooldown_2_end_index = find_index_from_time(cooldown_2_end_time,times);

%% Thermal Mass Loop
% res = 
% tol = 


% %% Cooldown Scenario
% cooldown_start_time = 1365; % [s] gotten from manually looking at cooldown start time
% cooldown_end_time = 1500; % [s] gotten from manually looking at cooldown end time
% 
% cooldown_start_time_index = find_index_from_time(cooldown_start_time,times); 
% cooldown_end_time_index = find_index_from_time(cooldown_end_time,times);
% cooldown_times = times(cooldown_start_time_index:cooldown_end_time_index);
% 
% final_cooldown_start_time = 2300; % [s] gotten from manually looking at cooldown start time
% 
% final_cooldown_start_time_index = find_index_from_time(final_cooldown_start_time,times); 
% final_cooldown_times = times(final_cooldown_start_time_index:end);

% old derivative code
% y1_cooldown_mc_temps = new_mc_temps(cooldown_start_time_index:cooldown_end_time_index);
% y2_cooldown_mc_temps = new_mc_temps(cooldown_start_time_index+1:cooldown_end_time_index+1);
% y1_cooldown_motor_temps = new_motor_temps(cooldown_start_time_index:cooldown_end_time_index);
% y2_cooldown_motor_temps = new_motor_temps(cooldown_start_time_index+1:cooldown_end_time_index+1);
% x1_cooldown_times = times(cooldown_start_time_index:cooldown_end_time_index);
% x2_cooldown_times = times(cooldown_start_time_index+1:cooldown_end_time_index+1);
% 
% d_mc_temp_dt = backwards_euler(y1_cooldown_mc_temps,y2_cooldown_mc_temps,x1_cooldown_times,x2_cooldown_times);
% d_motor_temp_dt = backwards_euler(y1_cooldown_motor_temps,y2_cooldown_motor_temps,x1_cooldown_times,x2_cooldown_times);

% cooldown_water_in_temps = new_water_in_temps(cooldown_start_time_index:cooldown_end_time_index);
% cooldown_water_out_temps = new_water_out_temps(cooldown_start_time_index:cooldown_end_time_index);
% 
% delta_water_temps = cooldown_water_out_temps - cooldown_water_in_temps;

figure % this figure shows the voltage and current side-by-side
subplot(1,2,1)
plot(times,voltage)
title("Voltage")
subplot(1,2,2)
plot(times,current)
title("Current")

figure % this figure shows that the motor generates more heat than the motor controller
hold on
plot(times,q_gen_mc,'DisplayName','MC')
plot(times,q_gen_motor_abs,'DisplayName','Motor')
hold off
legend('Location','best')
title("Heat Generation in MC and Motor")
ylabel("Q_{gen} [W]")
xlabel("Time [s]")

figure % this figure compares q_gen and q_diss
hold on
plot(times,q_gen,'DisplayName','q_{gen}')
plot(times,q_out,'DisplayName','q_{diss}')
hold off
legend('Location','best')
title('Heat Generation vs. Heat Dissipation')
ylabel('Power [W]')
xlabel('Time [s]')
text(100,4500,("Q_{out} = "+num2str(Q_out/1000)+" kJ"+newline+"Q_{gen} = "+num2str(Q_gen/1000)+" kJ"));

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

% figure % this figure shows motor, mc and water temps for the cooldown period
% hold on
% plot(cooldown_times,y1_cooldown_mc_temps,'DisplayName','MC Temps')
% plot(cooldown_times,y1_cooldown_motor_temps,'DisplayName','Motor Temps')
% plot(cooldown_times,cooldown_water_in_temps,'DisplayName','Water In Temps')
% plot(cooldown_times,cooldown_water_out_temps,'DisplayName','Water Out Temps')
% hold off
% xlabel('Time [s]')
% ylabel('Temperature [°C]')
% grid on
% legend

% figure % this figure shows dT/dt during cooldown for the motor and mc
% subplot(2,1,1)
% plot(cooldown_times,d_mc_temp_dt,'b')
% xlabel('Time [s]')
% xlim([cooldown_start_time,cooldown_end_time])
% ylabel('Temperature Change [°C/s]')
% title('MC Temp During Cooldown')
% subplot(2,1,2)
% plot(cooldown_times,d_motor_temp_dt,'b')
% xlabel('Time [s]')
% xlim([cooldown_start_time,cooldown_end_time])
% ylabel('Temperature Change [°C/s]')
% title('Motor Temp During Cooldown')

% figure % this figure shows motor, mc and water temps for the final cooldown period
% hold on
% plot(final_cooldown_times,new_mc_temps(final_cooldown_start_time_index:end),'DisplayName','MC Temps')
% plot(final_cooldown_times,new_motor_temps(final_cooldown_start_time_index:end),'DisplayName','Motor Temps')
% plot(final_cooldown_times,new_water_in_temps(final_cooldown_start_time_index:end),'DisplayName','Water In Temps')
% plot(final_cooldown_times,new_water_out_temps(final_cooldown_start_time_index:end),'DisplayName','Water Out Temps')
% hold off
% xlabel('Time [s]')
% ylabel('Temperature [°C]')
% grid on
% legend

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
function data_out = average_duplicates(data_in)
    [num_rows,num_cols] = size(data_in);
    unique_times = unique(data_in(:,1))';
    data_out = zeros([length(unique_times),num_cols]);
    for i = 1:length(unique_times)
        log_ind_dupes = (data_in(:,1) == unique_times(i));
        dupes = data_in(log_ind_dupes,2:end);
        ave_dupes = mean(dupes,1);
        data_out(i,:) = [unique_times(i),ave_dupes];
    end
end

function output = reinterpolate(old_time_array,data_array,new_time_array)
    [~, unique_time_index, ~] = unique(old_time_array);
    unique_times = old_time_array(unique_time_index);
    unique_data = data_array(unique_time_index);
    output = interp1(unique_times,filloutliers(unique_data,"nearest","movmedian",5),new_time_array,"linear"); % fillmethod "nearest" may not be the best but it eliminates the NaN values that appear at the beginning of the time series when the fillmethod "previous" is used and an outlier is detected
end

function q_gen_mc = mc_heat(V,I)
    I = abs(I);
    q_gen_mc = zeros(size(V));
    a = 0.000244;
    b = 1.073;
    c = 1.744;
    offset = 268; % this offset may be invalid for zero power consumption: something to look into
    for i = 1:length(V)
        if I(i) <= 5
            q_gen_mc(i) = 0;
        else
            q_gen_mc(i) = a*V(i).^b .* I(i).^c + offset;
        end
    end
end

% function dydx = backwards_euler(y_1,y_2,x_1,x_2)
%     dydx = (y_2-y_1)./(x_2-x_1);
% end

function times_index = find_index_from_time(time,times)
    difference = times - time;
    [~,times_index] = min(abs(difference));
end

function Q_out = rad_q_out(m_dot,Cp,T_inlet,T_outlet,time_water)
    % Outputs Q_out in Joules
    Q_out = trapz(time_water,m_dot*Cp.*(T_outlet-T_inlet));
end

function energy = power_to_energy(time,power)
    energy = trapz(time,power);
end

function Cm = Cm_general(q_gen,Q_out,q_time,T_motor_initial,T_motor_final,T_mc_initial,T_mc_final,k)
    % Funtion for solution of Cm for general case:
    % Cm = (INTEGRAL{q_gen - q_out dt})/(T_m + k*T_mc)
    Q = trapz(q_time,q_gen)-trapz(q_time,Q_out); 
    T_m = T_motor_final-T_motor_initial;
    T_mc = T_mc_final-T_mc_initial;
    Cm = Q/(T_m-k*T_mc);
end

function k = k_cooldown(Q_out,C_motor,T_motor_initial,T_motor_final,T_mc_initial,T_mc_final)
    T_m = T_motor_final-T_motor_initial;
    T_mc = T_mc_final-T_mc_initial;
    k = Q_out/(C_motor*T_mc) - T_m/T_mc;
end