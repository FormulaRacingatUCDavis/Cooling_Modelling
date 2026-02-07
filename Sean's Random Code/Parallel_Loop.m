data = [2	9	5.516
3	16	5.516
4	22	5.516
5	32	8.1878125
6	44	11.75022917
7	56	15.31264583
8	76	18.8750625
9	93	22.43747917
10	115	25.99989583
11	140	29.5623125];

figure;
hold on
plot(data(:,3),data(:,1),"DisplayName","MC")
plot(data(:,2),data(:,1),"DisplayName","Motor")
legend('Location','best')