clear; clc; close all
watertemps = readmatrix('Water Temps.csv');
hold on
grid on
%plot(watertemps(:,1 ),watertemps(:,2)- watertemps(:,3))
plot(watertemps(:,1),watertemps(:,2))
plot(watertemps(:,1),watertemps(:,3))
legend("Location", "best")

mean(watertemps(:,2));
mean(watertemps(:,3));
dT = [];
dTemp = [];
dTemp2 = [];
%time = watertemps((1:end-1),1);


% for i = 1:(length(watertemps(:,1))-1)
% 
%     dT(i,1) = watertemps(i+1,1) - watertemps(i,1);
%     dTemp(i,1) = watertemps(i+1, 2) - watertemps(i,2);
%     dTemp2(i,1) = watertemps(i+1, 3) - watertemps(i,3);
% 
% end
% 
% plot(time, dTemp./dT, 'o-')
% %plot(dT, dTemp2, '-')
