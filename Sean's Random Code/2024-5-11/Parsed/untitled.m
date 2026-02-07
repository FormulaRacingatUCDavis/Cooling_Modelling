% test = readtable('005_Motor_temp.csv');
% test2 = readtable('005_MC_Temp.csv');
% disp(max(test(2:end,2)))
% disp(max(test2(2:end,3)))

%Constants
% Ma = sqrt(2);
% U_inf = 1; %Free stream velocity
% B = sqrt(Ma^2 - 1); 
% tau = 0.1;
% 
% %Grid Generation / Key Indicies
% dx = 0.02;
% dy = tan(asin(1/Ma))*dx;
% x = -2*dx:dx:3;
% y = -3+dy/2:dy:3-dy/2;
% [XX,YY] = meshgrid(x,y);
% ind_up = find(y > 0,1,'first'); % upper surface index for y direction
% ind_low = find(y < 0,1,'last'); % lower surface index for y direction
% ind_le = find(x == 0); % leading edge index for x direction
% ind_te = find(x == 1); % trailing edge index for x direction
% ind_airfoil = ind_le:ind_te; % indices on the airfoil for x direction
% xb = x(ind_airfoil);
% C = xb(end) -xb(1);
% YB_upper = [tau*xb(1:26),tau*(1-xb(27:end))];
% YB_lower = -YB_upper;
close all
power = readmatrix("Conner_Skidpad_Power.csv");
MC_temps = readmatrix("Conner_Skidpad_MC_Temps.csv");
Motor_temps = readmatrix("Conner_Skidpad_Motor_Temps.csv");
Water_temps = readmatrix("Conner_Skidpad_Water_Air_Temps.csv");
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
title("Water Temp")
ylabel("Temperature [C]")
xlabel("Time [s]")
ylim([25,45])
subplot(4,1,2)
hold on
plot(Water_temps(:,1),Water_temps(:,4),'DisplayName','Inlet')
plot(Water_temps(:,1),Water_temps(:,5),'DisplayName','Outlet')
ylabel("Temperature [C]")
xlabel("Time [s]")
legend('Location','best')
title("Air Temp")
subplot(4,1,3)
plot(Motor_temps(:,1),Motor_temps(:,2))
title('Motor Temp')
ylabel("Temperature [C]")
xlabel("Time [s]")
subplot(4,1,4)
plot(MC_temps(:,1),MC_temps(:,3))
title("MC Temps")
ylabel("Temperature [C]")
xlabel("Time [s]")
% subplot(5,1,5)
% plot(power(:,1),power(:,4))
% title("Power")
% ylim([0,5000])
