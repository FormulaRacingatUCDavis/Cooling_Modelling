import csv
import glob
import os

MC_temps3 = []
Motor_temps = []
Water_temps = []
Radiator_temps = []
MCV = []
MCI = []
velocity_front = []
velocity_back = []
def translateMC3(list1,list2,line):
    limit = 32768
    temp_a = int(line[2])*256 + int(line[1])
    if  temp_a >= limit:
        temp_a = temp_a - 2*limit
    temp_b = int(line[4])*256 + int(line[3])
    if temp_b >= limit:
        temp_b = temp_b - 2*limit
    temp_c = int(line[6])*256 + int(line[5])
    if temp_c >= limit:
        temp_c = temp_c - 2*limit
    list1.append([temp_a/10,temp_b/10])
    list2.append([float(line[9])*10**-6,temp_c/10])

csv_file = r"C:\Users\sean8\Desktop\frucd code\Motor Temp Test\021.csv"
#print(csv_file)
limit = 32768
time = 0
water_time = 0
MC_time = 0
Rad_time = 0
V_time = 0
I_time = 0
vfront_time = 0
vback_time = 0
with open(csv_file, 'r') as csv_file:
    csv_reader = csv.reader(csv_file)
    for line in csv_reader:
        if line != []:    
            if line[0] == 'A2':
                temp_c = int(line[6])*256 + int(line[5])
                if temp_c >= limit:
                    temp_c = temp_c - 2*limit
                time = float(line[9])*10**-6
                Motor_temps.append([round(time, 2),temp_c/10])
            if line[0] == '400':
                water_time = round(float(line[9])*10**-6,2)
                Water_temps.append([water_time,int(line[1]),int(line[2]),int(line[3]),int(line[4])])
            if line[0] == 'A0':
                temp_A = int(line[2])*256 + int(line[1])
                if temp_A >= limit:
                    temp_A = temp_A -2*limit
                temp_B = int(line[4])*256 + int(line[3])
                if temp_B >= limit:
                    temp_B = temp_B -2*limit
                temp_C = int(line[6])*256 + int(line[5])
                if temp_C >= limit:
                    temp_C = temp_C -2*limit
                MC_time = float(line[9])*10**-6
                MC_temps3.append([round(MC_time,2),temp_A/10,temp_B/10,temp_C/10])
            if line[0] == '401':
                Rad_time = float(line[9])*10**-6
                Radiator_temps.append([round(Rad_time,2),line[1],line[2],line[3],line[4]])
            if line[0] == '380':
                voltage = int(line[5])/100*256 + int(line[6])/100
                if voltage >= limit:
                    voltage = voltage -2*limit
                V_time = float(line[9])*10**-6
                MCV.append([round(V_time,2), round(voltage,2)])
            if line[0] == '387':
                current = int(line[1])*256 + int(line[2]) 
                if current >= limit:
                    current = current - (2*limit)
                I_time = float(line[9])*10**-6
                MCI.append([round(I_time,2),round(current/10,2)])
            if line[0] == '470':
                velocity_front = int(line[1])*256 + int(line[2])
                if velocity_front >= limit:
                    velocity_front = velocity_front -2*limit
                vback_time = float()
Motor_fields = ['Time (s)','Motor Temps']
Water_temps_fields = ['Time (s)', 'MC Inlet', 'MC Outlet','Motor Inlet','Motor Outlet']
MC_fields = ['Time (s)', 'MC Temp A', 'MC Temp B', 'MC Temp C']
Radiator_fields = ['Time (s)', 'MC In','MC Out','Motor In','Motor Out']
MC_Ifields = ['Time (s)', 'Current']
MC_Vfields = ['Time (s)', 'Voltage']
Wheel_speed_fields = ['Time (s)', 'Left Velocity Front', 'Left Velocity Back']
# writepath = r"C:\Users\sean8\Desktop\frucd code\021 Graphs\021_Motor_Temps.csv"
# with open(writepath,'w',newline='') as csv_file:
#     write = csv.writer(csv_file)
#     write.writerow(Motor_fields)
#     write.writerows(Motor_temps)
# writepath = r"C:\Users\sean8\Desktop\frucd code\021 Graphs\021_Water_Temps.csv"
# with open(writepath,'w',newline='') as csv_file:
#     write = csv.writer(csv_file)
#     write.writerow(Water_temps_fields)
#     write.writerows(Water_temps)
# writepath = r"C:\Users\sean8\Desktop\frucd code\021 Graphs\021_MC_Temps.csv"
# with open(writepath,'w',newline='') as csv_file:
#     write = csv.writer(csv_file)
#     write.writerow(MC_fields)
#     write.writerows(MC_temps3)
# writepath = r"C:\Users\sean8\Desktop\frucd code\021 Graphs\MC_Current.csv"
# with open(writepath,'w',newline='') as csv_file:
#     write = csv.writer(csv_file)
#     write.writerow(MC_Ifields)
#     write.writerows(MCI)
# writepath = r"C:\Users\sean8\Desktop\frucd code\021 Graphs\MC_Voltage.csv"
# with open(writepath,'w',newline='') as csv_file:
#     write = csv.writer(csv_file)
#     write.writerow(MC_Vfields)
#     write.writerows(MCV)
# writepath = r"C:\Users\sean8\Desktop\frucd code\021 Graphs\021 MC Temps.csv"
# with open(writepath,'w',newline='') as csv_file:
#     write = csv.writer(csv_file)
#     write.writerow(MC_fields)
#     write.writerows(MC_temps3)
# writepath = r"C:\Users\sean8\Desktop\frucd code\021 Graphs\021_Radiator_Air_Temps.csv"
# with open(writepath,'w',newline='') as csv_file:
#     write = csv.writer(csv_file)
#     write.writerow(Radiator_fields)
#     write.writerows(Radiator_temps)
writepath = r"C:\Users\sean8\Desktop\frucd code\021 Graphs\021_Velocity.csv"
with open(writepath,'w',newline='') as csv_file:
    write = csv.writer(csv_file)
    write.writerow(Radiator_fields)
    write.writerows(Radiator_temps)