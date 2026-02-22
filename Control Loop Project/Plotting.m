close all
clc

MC_Temps = readmatrix("MC_Temps.csv");
Motor_Temps = readmatrix("Motor_Temps.csv");
Water_Air_Temps = readmatrix("Water_Air_Temps.csv");
data = readmatrix("FE11 Endurance Full Data V2.xlsx");
power = data(:,2).*data(:,3);
times =  (0:data(end,1)/(length(data(:,1))-1):data(end,1))';
p = 0;
counter = 0;
for i = 1:length(power)
    if power(i) > 1000
        p = p + power(i);
        counter = counter +1;
    end
end
avg_power = sum(p)/(1000*counter);

figure()
subplot(2,1,1)
hold on
plot(MC_Temps(:,1),filloutliers(MC_Temps(:,4),"previous","movmedian",5),'DisplayName','MC Temps')
plot(Motor_Temps(:,1),Motor_Temps(:,2),'DisplayName','Motor Temps')
xlabel("Time [s]")
xlim([0,2700])
ylabel("Temperature [C]")
title("Motor and MC Temps")
legend('Location','best')

subplot(2,1,2)
plot(times,power./1000)
xlabel("Time [s]")
ylabel("Power [kW]")
title("Power Draw")
xlim([0,2700])

figure()
subplot(3,1,1)
hold on
Water_Air_Temps_smooth = smoothdata(Water_Air_Temps(:,2));
plot(Water_Air_Temps(:,1),filloutliers(Water_Air_Temps(:,2),"previous","movmedian",5),'DisplayName','Inlet Temps')
plot(Water_Air_Temps(:,1),filloutliers(Water_Air_Temps(:,3),"previous","movmedian",5),'DisplayName','Outlet Temps')
xlabel('Time [s]')
ylabel('Temperature [C]')
title('Water Temps')
legend('Location','best')
xlim([0,2700])

subplot(3,1,2)
hold on
plot(MC_Temps(:,1),filloutliers(MC_Temps(:,4),"previous","movmedian",5),'DisplayName','MC Temps')
plot(Motor_Temps(:,1),Motor_Temps(:,2),'DisplayName','Motor Temps')
xlabel("Time [s]")
ylabel("Temperature [C]")
title("Motor and MC Temps")
legend('Location','best')
xlim([0,2700])

subplot(3,1,3)
hold on
%Getting water temp time to be same as motor
InletWater = zeros(length(Water_Air_Temps(7:end,2))/2-1,2);
n=0;
for i = 1:length(InletWater)
    InletWater(i,1:2) = Water_Air_Temps(i+6+n,1:2);
    n = n+1;
end
deltaT_M_W = smoothdata(Motor_Temps(4:2313,2)-filloutliers(InletWater(:,2),"previous","movmedian",5));
plot(InletWater(:,1),deltaT_M_W)
title("Motor vs Inlet Water Delta T")
xlim([0,2700])
% subplot(4,1,4)
% OutletWater = zeros(length(Water_Air_Temps(7:end,2))/2-1,2);
% n=0;
% for i = 1:length(InletWater)
%     OutletWater(i,2) = Water_Air_Temps(i+6+n,3);
%     n = n+1;
% end
% OutletWater(:,1) = InletWater(:,1);
% deltaT_MC_W = smoothdata(MC_Temps(4:2313,4) - filloutliers(OutletWater(:,2),"previous","movmedian",5));
% plot(OutletWater(:,1),deltaT_MC_W)
% title("MC vs Outlet Water Delta T")
%%
deltaT = filloutliers(Water_Air_Temps(:,2),"previous","movmedian",5) - filloutliers(Water_Air_Temps(:,3),"previous","movmedian",5);
figure()
subplot(3,1,1)
hold on
plot(MC_Temps(:,1),filloutliers(MC_Temps(:,4),"previous","movmedian",5),'DisplayName','MC Temps')
plot(Motor_Temps(:,1),Motor_Temps(:,2),'DisplayName','Motor Temps')
xlabel("Time [s]")
xlim([0,2700])
ylabel("Temperature [C]")
title("Motor and MC Temps")
legend('Location','best')

subplot(3,1,2)
plot(Water_Air_Temps(:,1), smoothdata(-deltaT))
title("Water \DeltaT (Outlet - Inlet)")
xlabel('Time [s]')
ylabel('\DeltaT [C]')
avg_deltaT = mean(abs(deltaT));
max_deltaT = max(abs(smoothdata(deltaT)));
Q_avg = 7.5/60*4182*avg_deltaT*10^-3;
Q_max = 7.5/60*4182*max_deltaT*10^-3;
xlim([0,2700])

subplot(3,1,3)
plot(Water_Air_Temps(:,1),smoothdata(7.5./60.*4.182.*-deltaT))
title('Q_{dis} vs Time')
xlabel('Time [s]')
ylabel('Q_{dis} [kJ]')
xlim([0,2700])
%%
figure()
subplot(2,1,1)

deltaT_M_MC = smoothdata(filloutliers(Motor_Temps(:,2),"previous","movmedian",5)-filloutliers(MC_Temps(:,4),"previous","movmedian",5));
plot(MC_Temps(:,1),deltaT_M_MC)
title('Motor and MC \Delta T')
xlabel('Time [s]')
ylabel('\Delta T [C]')

%% Big Plot
figure()
subplot(4,1,1)
hold on
plot(Water_Air_Temps(:,1),filloutliers(Water_Air_Temps(:,2),"previous","movmedian",5),'DisplayName','Inlet Temps')
plot(Water_Air_Temps(:,1),filloutliers(Water_Air_Temps(:,3),"previous","movmedian",5),'DisplayName','Outlet Temps')
xlabel('Time [s]')
ylabel('Temperature [C]')
title('Water Temps')
legend('Location','best')
xlim([0,2700])

subplot(4,1,2)
hold on
plot(MC_Temps(:,1),filloutliers(MC_Temps(:,4),"previous","movmedian",5),'DisplayName','MC Temps')
plot(Motor_Temps(:,1),Motor_Temps(:,2),'DisplayName','Motor Temps')
xlabel("Time [s]")
ylabel("Temperature [C]")
title("Motor and MC Temps")
legend('Location','best')
xlim([0,2700])

subplot(4,1,3)
hold on
%Getting water temp time to be same as motor
InletWater = zeros(length(Water_Air_Temps(7:end,2))/2-1,2);
n=0;
for i = 1:length(InletWater)
    InletWater(i,1:2) = Water_Air_Temps(i+6+n,1:2);
    n = n+1;
end
deltaT_M_W = smoothdata(Motor_Temps(4:2313,2)-filloutliers(InletWater(:,2),"previous","movmedian",5));
plot(InletWater(:,1),deltaT_M_W)
title("Motor vs Inlet Water Delta T")
xlim([0,2700])
xlabel('Time [s]')
ylabel('\DeltaT [C]')

subplot(4,1,4)
plot(Water_Air_Temps(:,1),smoothdata(7.5./60.*4.182.*-deltaT))
title('Q_{dis} vs Time')
xlabel('Time [s]')
ylabel('Q_{dis} [kJ]')
xlim([0,2700])