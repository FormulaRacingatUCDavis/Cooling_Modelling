%Read Matricies
clear all; clc; 
Motor_temps = readmatrix('021_Motor_Temps.csv');
Water_temps = readmatrix('021_Water_Temps.csv');
MC_Temps = readmatrix('021_MC_Temps.csv');
MC_V = readmatrix('MC_Voltage.csv');
MC_I = readmatrix('MC_Current.csv');
Rad_temps = readmatrix('021_Radiator_Air_Temps.csv');
Qgen_calc = (readmatrix('021_Qgen_simulink.csv'))';
Qgen_calc_mat = [linspace(0,800, 800001)' Qgen_calc]; %Qgen is recorded in intervals of 0.001 seconds, done to get matching time indicies 

% Qgen_calc_mat2 = [];
% inc = 1;
% k = 1;
% for i = 1:length(Qgen_calc_mat)
%     if Qgen_calc_mat(i, 1) == inc
%         Qgen_calc_mat2(k,:) = Qgen_calc_mat(i,:);
%         inc = inc + 0.01;
%         k = k+ 1;
%     else
% 
%     end
% end

close all
%hold on
%plot(Rad_temps(:,1), Rad_temps(:, [2:5]));
% plot(Motor_temps(:,1),Motor_temps(:,2))
% plot(Water_temps(:,1), Water_temps(:,2))
% plot(Water_temps(:,1), Water_temps(:,4))
% plot(MC_Temps(:,1), MC_Temps(:,4))
%legend('location', 'best')

%% Difference Plotting
int1x = Rad_temps(:, 1);
int1v = Rad_temps(:, [2:5]);
xq1 = (3.32:0.01:919.74)';
Rad_temps2 = [xq1 interp1(int1x, int1v, xq1)];
Rad_MCTempDiff = [xq1 Rad_temps2(:,3)-Rad_temps2(:,2)];
Rad_MotorTempDiff = [xq1 Rad_temps2(:,5)-Rad_temps2(:,4)];

int2x = Water_temps(:, 1);
int2v = Water_temps(:, [2:5]);
xq2 = (3.28:0.01:919.73)';
Water_temps2 = [xq2 interp1(int2x, int2v, xq2)];
Water_MCTempDiff = [xq2 Water_temps2(:,3) - Water_temps2(:,2)];
Water_MotorTempDiff = [xq2 Water_temps2(:,5) - Water_temps2(:,4)];

MC_Temps_Hi = [MC_Temps(:,1) MC_Temps(:,4)];
int3x = MC_Temps_Hi(:, 1);
int3v = MC_Temps_Hi(:, 2);
xq3 = (3.23:0.01:919.7)';
MC_Temps_HiEx = [xq3 interp1(int3x, int3v, xq3)];
%plot(MC_Temps_HiEx(:,1), MC_Temps_HiEx(:,2))


% subplot(2,1,1);
% hold on
% plot(Rad_MCTempDiff(:,1), Rad_MCTempDiff(:,2));
% plot(Rad_MotorTempDiff(:,1), Rad_MotorTempDiff(:,2));
% legend('location', 'best')
% 
% subplot(2,1,2);
% hold on
% plot(Water_MCTempDiff(:,1), Water_MCTempDiff(:,2));
% plot(Water_MotorTempDiff(:,1), Water_MotorTempDiff(:,2));
% plot(Qgen_calc_mat(:,1) ,Qgen_calc_mat(:,2)/1000);
% legend('location', 'best')

% for i = 1:length(Rad_MCTempDiff)-1
%     Rad_MCTempDiff(i,2) = (Rad_MCTempDiff(i+1,2)+ Rad_MCTempDiff(i,2)) / 2;
%     if Rad_MCTempDiff(i)
%     end
% end

Rad_TempDiff = [xq1 Rad_MCTempDiff(:,2) Rad_MotorTempDiff(:,2)];
Water_TempDiff = [xq2 Water_MCTempDiff(:, 2) Water_MotorTempDiff(:,2)];

%maybe take whole number indexes 
for i = length(Rad_TempDiff)-1
    
end

%% hA(air) Calculations

%First assuming watertemp data isnt bad
mW_dot = 0.1333333333333333333333333333333; %kgW/s
Cw = 4186; %J/kgK 
Conv_water1 = mW_dot * Cw * Water_TempDiff(:,2);
x = Qgen_calc_mat(3281:10:end, 2);
y = Conv_water1(1:79673);
hA_air1 = (Qgen_calc_mat(3281:10:end, 2) - Conv_water1(1:79673))./(MC_Temps_HiEx(6:79678, 2) - 10); %index at which Qgen starts at 3.28s and Conv ends at 800s


%Now assuming with an average velocity
Vavg = 17.26; %m/s
rho_air = 1.296; %kg/m^3
w = 0.12; %m
h = 0.21; %m
A = w*h; %m^2
Ca = 1005; %J/kgK
mA_dot = rho_air * Vavg * A;
Conv_rad = mA_dot * Ca * Rad_TempDiff(:,2);
hA_air2 = (Qgen_calc_mat(3321:10:end, 2) - Conv_rad(1:79669))./(MC_Temps_HiEx(10:79678, 2) -10);


subplot(2,1,1);
hold on
plot(Rad_MCTempDiff(:,1), Rad_MCTempDiff(:,2));
plot(Rad_MotorTempDiff(:,1), Rad_MotorTempDiff(:,2));
plot(MC_Temps_HiEx(:,1), MC_Temps_HiEx(:,2));
title('Radiator Temps of MC and Motor');
legend('location', 'best')
% 
% subplot(4,1,2);
% hold on
% plot(Water_MCTempDiff(:,1), Water_MCTempDiff(:,2));
% plot(Water_MotorTempDiff(:,1), Water_MotorTempDiff(:,2));
% title('Water Temps of MC and Motor');
% legend('location', 'best')
% 
subplot(2,1,2);
hold on

% plot(xq1(1:79669), hA_air2, 'DisplayName', 'hA using radiator data');
% plot(xq1, Conv_rad);
% plot(xq2(1:79673), hA_air1, 'DisplayName', 'hA using water data');
% plot(xq2, Conv_water1);
% plot(Qgen_calc_mat(:,1) ,Qgen_calc_mat(:,2), 'DisplayName', 'Total Heat Flow');
title('hA(air) calculated from rad temp and water temp data and respective heat transfer');
legend('location', 'best')
%Note: Conv_water1 and Conv_rad are "supposed" to be equal

%Use hA_air2 to find average hA_air and put into equation to find total
%heat transfer again to compare to original

hA_water2 = (Qgen_calc_mat(3321:10:end, 2) - hA_air2.*(MC_Temps_HiEx(10:79678, 2) -10))./(MC_Temps_HiEx(10:79678, 2)-Water_temps2(10:79678, 2));
hA_water2 = filloutliers(hA_water2,"next"); %getting rid of outliers that go to infinity
plot(xq1(1:79669), hA_water2, 'DisplayName', 'hA_water using radiator data');
% hA_water1=(Qgen_calc_mat(3281:10:end, 2) - hA_air1.*(MC_Temps_HiEx(6:79678, 2) -10))./(MC_Temps_HiEx(6:79678, 2)-Water_temps2(10:79678, 2));
% plot(xq2(1:79669), hA_water1, 'DisplayName', 'hA_water using water data');

hA_rad = Conv_rad(10:79678,1)./(Water_temps2(10:79678, 2) - Rad_temps2(10:79678,2));
plot(xq1(1:79669), hA_rad,'DisplayName', 'radiator')
%% Finding average hA values
timestep = 0.01;
total_time =xq1(71170)-xq1(5219);
average_hA_air2 = sum(hA_air2(5219:71169).*timestep)/total_time; %getting average by taking integral and dividing by total time
y = 355.*ones(79669,1);
% plot(xq1(1:79669), y,'DisplayName', 'average')
% plot(xq1(5219:71169),hA_air2(5219:71169),'DisplayName', 'hA_air')

average_hA_water2 = sum(hA_water2(5219:71169).*timestep)/total_time;
y = 756*ones(79669,1);
% plot(xq1(1:79669), y,'DisplayName', 'average')

average_hA_rad = sum(hA_rad(5219:71169).*timestep)/total_time;
y = 406*ones(79669,1);
plot(xq1(1:79669), y,'DisplayName', 'radiator')

