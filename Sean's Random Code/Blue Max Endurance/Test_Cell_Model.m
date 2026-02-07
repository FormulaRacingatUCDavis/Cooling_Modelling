clc 
clear all
close all
%% Assumptions
%Heat generation within the batteries are uniform
%Lumped Capacitance (Battery has uniform temperature distribution)
%Treat fins on heat sink as rectangular fins
%Constant Resistance of battery?
%% Constants
h_air = 30; %[W/m^2 K]
t_fin = 0.00122; %[m]
L_fin = 0.00930; %[m]
w_base = 0.31064; %[m]
L_base = 0.14394; %[m]
N_fins = 20; 
k_sink = 237; %[W/mK]
T_amb = 31; %[C]
R_bat = 0.0135; %[Ohms] Taken from average internal resistance
T_inf = 35; %[C]
t_sink = 0.00191; %[m]

m_cell = 64.92*10^-3; %[kg]
Cp_cell = 1360; %[J/K kg]
%% Data
data = readmatrix("FE11 Endurance Full Data V2.xlsx");
data2 = readmatrix('Edurance_Current.csv');
voltage = data(:,2); %[V]
current = data2(:,2); %[A]
SOC = data(:,7); %[%]
% Times using time-matched endurance data with loss of current data
% times = data(:,1); %[s]

% Times using raw endurance current data (using uniform time step to
% account for repeated recorded time values
times =  (0:data2(end,1)/(length(data2(:,1))-1):data2(end,1))'; %[s]
%% Heat Generation
Qdot_gen = zeros(size(times));
Qdot_rev = zeros(size(times));
Q_gen = zeros(size(times));

Qdot_ohm = (current./4).^2 .*R_bat; 
dUdT = 0;

%% Heat Dissipation
Q_out = zeros(size(times));
Qdot_out = zeros(size(times));
A_base = w_base*L_base; 
L_c = L_fin + t_fin/2;
A_p = L_c*t_fin;
eff = .95; 
A_fin = 2*L_fin*w_base + t_fin*w_base;

R_paste = 0; %Assuming no contact resistance 
R_cond = t_sink/(k_sink*A_base);
R_base = 1/(h_air*(A_base-N_fins*t_fin*w_base));
R_fins = N_fins/(eff*h_air*A_fin);
R_heatsink = (1/R_base + 1/R_fins)^(-1);

R_eq = R_paste + R_cond + R_heatsink;
% R_eq = 1/(h_air*5.48*10^-6);

%% Calculations
%Note, time steps from data are kind of fucked since each recorded time is
%repeated twice, thus we cannot integrate over the time between each data
%point since half of them will have 0 time difference.

%Since the difference between the recorded times is ~.5 seconds, going to assume a
%uniform time step of .25 seconds between each time step

% t_step = .25; %[s]
% time = zeros(size(times));
% for n = 2:length(times)
%     time(n) = time(n-1) + t_step;
% end
t_step = times(end)/length(times);
T_cell = zeros(size(times));
%Initial conditions
Qdot_rev(1) = current(1)*T_amb*dUdT;
Qdot_gen(1) = Qdot_ohm(1) - Qdot_rev(1);
Q_gen(1) = Qdot_gen(1)*t_step;
Qdot_out(1) = (T_amb-T_inf)/(R_eq*48); %48 is number of cells that we are taking heat out of
Q_out(1) = Qdot_out(1)*t_step;
T_cell(1) = (Q_gen(1)-Q_out(1))/(m_cell*Cp_cell) + T_amb;

for i = 2:length(times)
    Qdot_rev(i) = current(i)*T_cell(i-1)*dUdT;
    Qdot_gen(i) = Qdot_ohm(i) - Qdot_rev(i);
    Q_gen(i) = Qdot_gen(i)*t_step;
    Qdot_out(i) = (T_cell(i-1)-T_inf)/(R_eq*48); %48 is number of cells that we are taking heat out of
    Q_out(i) = Qdot_out(i)*t_step;
    T_cell(i) = (Q_gen(i)-Q_out(i))/(m_cell*Cp_cell) + T_cell(i-1);
end

%% Plotting

figure()
subplot(2,1,1)
plot(times,T_cell)
title("Cell Temperature")
xlabel('Time [s]')
ylabel('Temperature [C]')


subplot(2,1,2)
title("Q comparison")
xlabel( 'Time [s]')
ylabel('Q [W]')
hold on
plot(times,Qdot_gen,'DisplayName', 'Q_{gen}')
plot(times,Qdot_out,'DisplayName', 'Q_{out}')
legend(Location="best")