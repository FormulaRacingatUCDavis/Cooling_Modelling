%Read Matricies
Motor_temps = readmatrix('021_Motor_Temps.csv')
Water_temps = readmatrix('021_Water_Temps.csv')
MC_Temps = readmatrix('021_MC_Temps.csv')
MC_V = readmatrix('MC_Voltage.csv')
MC_I = readmatrix('MC_Current.csv')
close all
hold on
plot(Motor_temps(:,1),Motor_temps(:,2))
plot(Water_temps(:,1), Water_temps(:,2))
plot(Water_temps(:,1), Water_temps(:,4))
plot(MC_temps(:,1), MC_temps(:,4))
