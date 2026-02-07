close all
power = readmatrix("Conner_Skidpad_Power.csv");
MC_temps = readmatrix("004_MC_Temp.csv");
Motor_temps = readmatrix("004_Motor_temp.csv");
Water_temps = readmatrix("004_Water_Air_Temp.csv");
for i = 2:5
    Water_temps(:,i) = smoothdata(Water_temps(:,i),"gaussian"); 
end
Motor_temps(:,2) = smoothdata(Motor_temps(:,2),"gaussian");
MC_temps(:,3) = smoothdata(MC_temps(:,3),"gaussian");
figure()
subplot(4,1,1)
hold on
plot(Water_temps(:,1),Water_temps(:,2),'DisplayName','Inlet')
plot(Water_temps(:,1),Water_temps(:,3),'DisplayName','Outlet')
legend('Location','best')
xlabel("Time [s]")
ylabel("Temp [C]")
title("Water Temp")
% ylim([20,40])
% subplot(4,1,2)
% hold on
% plot(Water_temps(:,1),Water_temps(:,4),'DisplayName','Inlet')
% plot(Water_temps(:,1),Water_temps(:,5),'DisplayName','Outlet')
% legend('Location','best')
% title("Air Temp")
subplot(4,1,2)
plot(Motor_temps(:,1),Motor_temps(:,2))
title('Motor Temp')
xlabel("Time [s]")
ylabel("Temp [C]")
subplot(4,1,3)
plot(MC_temps(:,1),MC_temps(:,3))
title("MC Temps")
xlabel("Time [s]")
ylabel("Temp [C]")
subplot(4,1,4)
plot(power(:,1),power(:,4))
title("Power")
xlabel("Time [s]")
ylabel("Power [W]")