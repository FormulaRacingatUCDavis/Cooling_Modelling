
%Read Files
MC_V = readmatrix('MC_Voltage.csv');
MC_C = readmatrix('MC_Current.csv');
MC_T = readmatrix('021_MC_Temps.csv');


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
plot(powerCSV(:,1), powerCSV(:,2))

for j = (length(powerCSV)-1)%maybe find average to avoid gross graph
    powerCSV;
end

%%
Input.Power = powerCSV; %KJ
close all;
sim('MCModel.slx');
plot(ans.MCTout+273.15);
hold on
plot(MC_T(:,1), MC_T(:, 4)+273.15);
plot(MC_C(:,1), MC_C(:,2));
%Graph seems to have fluctuations, maybe ddont do offset voltage*current
%method(??)


% close all;
% hold on;
% plot(time2, avgPower*1000, 'o')
% plot(time2, power2)

