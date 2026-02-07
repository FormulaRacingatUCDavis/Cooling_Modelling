
%Read Files
MC_V = readmatrix('MC_Voltage.csv');
MC_C = readmatrix('MC_Current.csv');
MC_T = readmatrix('021_MC_Temps.csv');
MC_Temps_Hi = [MC_Temps(:,1) MC_Temps(:,4)];
int3x = MC_Temps_Hi(:, 1);
int3v = MC_Temps_Hi(:, 2);
xq3 = (3.23:0.01:919.7)';
MC_Temps_HiEx = [xq3 interp1(int3x, int3v, xq3)];
%scaling coefficients
a= 0.000244;
b=1.073;
c=1.744;
offset = 268;

format short g
N = length(MC_C);
time = zeros(N,1);
power = zeros(N,1);
power_scale1 = zeros(N,1);
power_scale2 = zeros(N,1);
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
       power_scale1(i) = a*(504^b)*(MC_C(i,2))^c + offset ;
       power_scale2(i) = a*(MC_V(p,2))^b*(MC_C(i,2))^c + offset;    
   end
   
   if MC_V(p,1) < MC_C(i,1)
       p = p + 1;
   end
end

power2 = power(351:5748);
powerscale1 = power_scale1(351:5748);
powerscale2 = power_scale2(351:5748);
time2 = time(351:5749);

intPower = sum(power2 .* diff(time2) )/1000; %KJ, integral of all power values in run
totalTime = time(5749) - time(351);
avgPower = intPower/totalTime; %KJ/s, avg power in run
power2(5399) = 0; % extension of matrix so I can plot
powerscale1(5399) = 0;
powerscale2(5399) = 0;
powerCSV = [time2 (power2)];
powerscale1csv = [time2 ,powerscale1];
powerscale2csv = [time2 ,powerscale2];
ExtensionT = [linspace(1,49, 49)' zeros(49,1)];
% powerCSV = [[linspace(1,49, 49)' 1000.*avgPower.*ones(49,1)];powerCSV];
% powerCSV = [powerCSV;[linspace(760,800, 40)' 1000.*avgPower.*ones(40,1)]];
powerCSV = [[linspace(1,49, 49)' zeros(49,1)];powerCSV;[linspace(760,800, 40)' zeros(40,1)]];
powerscale1csv = [[linspace(1,49, 49)' zeros(49,1)];powerscale1csv];
powerscale1csv = [powerscale1csv;[linspace(760,800, 40)' zeros(40,1)]];
powerscale2csv = [[linspace(1,49, 49)' zeros(49,1)];powerscale2csv];
powerscale2csv = [powerscale2csv;[linspace(760,800, 40)' zeros(40,1)]];
close all
hold on
plot(powerCSV(:,1),0.1*powerCSV(:,2),'DisplayName','Original Power')
plot(powerscale1csv(:,1),powerscale1csv(:,2),'DisplayName', 'Constant Voltage')
plot(powerscale2csv(:,1),powerscale2csv(:,2),'DisplayName','Manufacturer Model')
for j = (length(powerCSV)-1)%maybe find average to avoid gross graph
    powerCSV;
end
% writematrix(powerCSV,'021_powerCSV.csv')
%%
Input.Power = powerscale2csv; %KJ
close all;
sim('MCModel.slx');
plot(ans.MCTout,'DisplayName', 'Model MC Temps');%+273.15);
hold on
plot(MC_T(:,1), MC_T(:, 4), 'DisplayName', 'MC Temps From Trackday');%+273.15);    
% plot(MC_Temps_HiEx(:,1), MC_Temps_HiEx(:,2), 'DisplayName', 'MC Temps From Trackday')
% plot(MC_C(:,1), MC_C(:,2));
%Graph seems to have fluctuations, maybe ddont do offset voltage*current
%method(??)
% plot(powerCSV(:,1), powerCSV(:,2))
% plot(ans.HeatFlow/1000, 'DisplayName', 'Heat Flow')
% H = ans.HeatFlow.Data;
% writematrix(H,'M_tab2.csv')
% close all;
% hold on;
% plot(time2, avgPower*1000, 'o')
% plot(time2, power2)

