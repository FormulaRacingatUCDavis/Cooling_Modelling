close all
%Input Parameters
P = 1:130; %[kW]
Cp_water = 4.182; %[kJ/kg C]
delta_T_water = 5; %[C]
Cp_copper = 0.392; %[kJ/kg C]
delta_T_critical_mc = 20; %[C]
delta_T_critical_motor = 40;

%Motor Heat Generation
Q_m = (1-0.94).*P; %[kW]
m_dot_motor = 4.31/60; %[kg/s]
Q_out_m = m_dot_motor*Cp_water*delta_T_water; %[kW]
mass_motor = 12.4/2; %[kg]

%Motor Controller Heat Generation
a = 0.000244;
b = 1.073;
c = 1.744;
offset = 268;
V_dc = 537.6; %[V]
V_nom = 460.8; %[V]
I = (P.*1000)./V_nom;
Q_mc = ((a.*V_dc.^b).*I.^c+offset)/1000; %[kW]
m_dot_mc = 9.6/60; %[kg/s]
Q_out_mc = m_dot_mc*Cp_water*delta_T_water; %[kW]
mass_mc = 6.75/2; %[kg]

%Calcs
time_motor = critical_time(mass_motor,Cp_copper,delta_T_critical_motor,Q_m,Q_out_m);
time_mc = critical_time(mass_mc,Cp_copper,delta_T_critical_mc,Q_mc,Q_out_mc);

%Plot
figure;
subplot(2,1,1)
plot(time_motor(26:end),P(26:end))
title("Motor Critical Time Analysis")
ylabel("Continuous Power Output [kW]")
xlabel("Time [s]")
ylim([25 130])

subplot(2,1,2)
plot(time_mc(114:end),P(114:end))
title("Motor Controller Critical Time Analysis")
ylabel("Continuous Power Output [kW]")
xlabel("Time [s]")
% ylim([0 130])
%%
function [time] = critical_time(mass,Cp,delta_T,Q_gen,Q_out)
    Q_total = Q_gen - Q_out;
    time = mass.*Cp.*delta_T./Q_total;
end