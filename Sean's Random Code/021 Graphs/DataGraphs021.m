%Read Matricies
Motor_temps = readmatrix('021_Motor_Temps.csv');
Water_temps = readmatrix('021_Water_Temps.csv');
MC_Temps = readmatrix('021_MC_Temps.csv');
MC_C = readmatrix('MC_Current.csv');
Rad_temp = readmatrix('021_Radiator_Air_Temps.csv');
close all
hold on

% HeatFlow = readmatrix("M_tab2.csv");
% L= length(HeatFlow);
% HeatFlow2 = [linspace(0,800,L)',HeatFlow'];
% plot(HeatFlow2(:,1),HeatFlow2(:,2))
% plot(Motor_temps(:,1),Motor_temps(:,2))
% plot(Water_temps(:,1), Water_temps(:,2))
% plot(Water_temps(:,1), Water_temps(:,4))
plot(MC_Temps(:,1), MC_Temps(:,4))
% plot(MC_C(:,1),MC_C(:,2))
plot(Rad_temp(:,1),Rad_temp(:,3)-Rad_temp(:,2))

format short g
N = length(MC_C);
time = zeros(N,1);
power = zeros(N,1);
K = length(MC_V);
MC_C = abs(MC_C); %Some current values are negative bc of overshoot current draw


%Time signatures dont match up between the voltage and current runs, length
%of current matrix > voltage matrix, use current matrix time logging and
%multiply each current by voltage until time for current is bigger than
%time for voltage, then repeat
p = 1;
for i = 1:N-1 
    time(i) = MC_C(i, 1);

   if MC_V(p,1) > MC_C(i,1)
       power(i) = MC_V(p,2) * MC_C(i,2);
   end

   if MC_V(p,1) < MC_C(i,1)
       p = p + 1;
   end
end

power2 = power(351:5748);
time2 = time(351:5749);

intPower = sum(power2 .* diff(time2) )/1000 %KJ, integral of all power values in run
totalTime = time(5749) - time(351);
avgPower = intPower/totalTime %KJ/s, avg power in run
power2(5399) = 0; % extension of matrix so I can plot
powerCSV = [time2 (power2)];
% plot(powerCSV(:,1), powerCSV(:,2))
ExtensionT = [linspace(1,49, 49)' zeros(49,1)];
powerCSV = [[linspace(1,49, 49)' zeros(49,1)];powerCSV];
powerCSV = [powerCSV;[linspace(760,920,160)' zeros(160,1)]];
for j = (length(powerCSV)-1)%maybe find average to avoid gross graph
    powerCSV;
end

plot(powerCSV())