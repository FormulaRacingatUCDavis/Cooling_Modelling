import csv
import glob
import os
import numpy as np

MC_temps3 = []
Motor_temps = []
Water_temps = []
Radiator_temps = []
temp_data = []
MCV = []
MCI = []
Torque = []
RPM_data = []
Pack_voltage_data =[]
Current_data = []
strain_data = []
csv_files = [
r"C:\Users\sean8\Desktop\frucd code\2024-5-11\003_brandon_accel_parsed.csv"]
# r"C:\Users\sean8\Desktop\frucd code\2024-04-27\Parsed\002_brandon_juan_parsed.csv"]
# r"C:\Users\sean8\Desktop\frucd code\2024-04-27\Parsed\003_manny_parsed.csv"]
# r"C:\Users\sean8\Desktop\frucd code\2024-04-27\Parsed\004_accel_brake_chris_parsed.csv"]
# r"C:\Users\sean8\Desktop\frucd code\2024-04-27\Parsed\005_slalom_connor_chris_parsed.csv"]
#print(csv_file)
limit = 32768
# for file in csv_files:
csv_file = csv_files[0]
with open(csv_file, 'r') as csv_file:
    csv_reader = csv.reader(csv_file)
    for line in csv_reader:
        if line != []:    
            if line[0] == 'c0':
                torque_request = float(line[1]) #In Nm
                torque_time = round(float(line[9]),2)
                Torque.append([torque_time,torque_request])
            if line[0] == 'a5':
                RPM = float(line[3]) #RPM
                RPM_time = round(float(line[9]),2)
                RPM_data.append([RPM_time,RPM])
            if line[0] == '380':
                Pack_voltage = float(line[5]) #Pack Voltage
                Pack_voltage_time = round(float(line[9]),2)
                Pack_voltage_data.append([Pack_voltage_time,Pack_voltage])
            if line[0] == '387':
                Current = float(line[1]) #Current
                Current_time = round(float(line[9]),2)
                Current_data.append([Current_time,Current])
            if line[0] == '400':
                Inlet_Water_temp = line[1]
                Outlet_Water_temp = line[3]
                Outlet_air_temp = round(83.35412 - 0.03634221 * float(line[5]) +0.0000034466 * float(line[5])**2,2)
                Inlet_air_temp = round(83.35412 - 0.03634221 * float(line[7]) +0.0000034466 * float(line[7])**2,2)
                temp_time = round(float(line[9]),2)
                temp_data.append([temp_time,Inlet_Water_temp,Outlet_Water_temp,Inlet_air_temp,Outlet_air_temp])
            # if line[0] == '387':
            #     current_draw = 
            if line[0] == 'a2':
                temp_c = line[5]
                motor_time = round(float(line[9]),2)
                Motor_temps.append([motor_time,temp_c])
            # if line[0] == '400':
            #     temp_time = round(float(line[5]),2)
            #     Water_temps.append([temp_time,int(line[1])/10,int(line[2]),int(line[3]),int(line[4])])
            if line[0] == 'a0':
                temp_A = line[1]
                temp_B = line[3]
                temp_C = line[5]
                MC_time = round(float(line[9]),2)
                MC_temps3.append([MC_time,temp_A,temp_B,temp_C])
            if line[0] == '500':
                force = float(line[1])
                strain_time = round(float(line[9]),2)
                strain_data.append([strain_time,force])
            # if line[0] == '401':
            #     Rad_time = float(line[9])*10**-6
            #     Radiator_temps.append([round(Rad_time,2),line[1],line[2],line[3],line[4]])
            # if line[0] == '380':
            #     voltage = int(line[5])/100*256 + int(line[6])/100
            #     if voltage >= limit:
            #         voltage = voltage -2*limit
            #     V_time = float(line[9])*10**-6
            #     MCV.append([round(V_time,2), round(voltage,2)])
            # if line[0] == '387':
            #     current = int(line[1])*256 + int(line[2]) 
            #     if current >= limit:
            #         current = current - (2*limit)
            #     I_time = float(line[9])*10**-6
            #     MCI.append([round(I_time,2),round(current/10,2)])

Voltage_array = [data[1] for data in Pack_voltage_data]
Current_array = [data[1] for data in Current_data]
Power_consumption = [voltage*current for voltage,current in zip(Voltage_array,Current_array)]
Power = [[data[0] for data in Pack_voltage_data ], Voltage_array,Current_array,Power_consumption]
Motor_fields = ['Time (s)','Motor Temps']
Water_Air_temps_fields = ['Time (s)', 'Inlet Water Temp (C)', 'Outlet Water Temp (C)', 'Inlet Air Temp (C)', 'Outlet Air Temp (C)' ]
MC_fields = ['Time (s)', 'MC Temp A', 'MC Temp B', 'MC Temp C']
Radiator_fields = ['Time (s)', 'MC In','MC Out','Motor In','Motor Out']
MC_Ifields = ['Time (s)', 'Current']
MC_Vfields = ['Time (s)', 'Voltage']
Torque_fields = ['Time (s)', 'Torque Requested (Nm)']
RPM_fields = ['Time (s)', 'RPM']
Pack_Voltage_fields = ['Time (s)', 'Voltage']
Current_fields = ['Time (s)', 'Current (DC Amps)']
Power_fields = ['TIme (s)', 'Pack Voltage', 'Current (DC Amps)', 'Power Consumption (W)']
Strain_fields = ['Time (s)', 'Reading']
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
writepath = r"C:\Users\sean8\Desktop\frucd code\2024-5-11\Parsed\Brandon_Acceleration_RPM.csv"
with open(writepath,'w',newline='') as csv_file:
    write = csv.writer(csv_file)
    write.writerow(RPM_fields)
    write.writerows(RPM_data)
writepath = r"C:\Users\sean8\Desktop\frucd code\2024-5-11\Parsed\Brandon_Acceleration_Torque.csv"
with open(writepath,'w',newline='') as csv_file:
    write = csv.writer(csv_file)
    write.writerow(Torque_fields)
    write.writerows(Torque)
row = []
i = 0
writepath = r"C:\Users\sean8\Desktop\frucd code\2024-5-11\Parsed\Brandon_Acceleration_Power.csv"
with open(writepath,'w',newline='') as csv_file:
    write = csv.writer(csv_file)
    write.writerow(Power_fields)
    for lines in Voltage_array:
        for inner_array in Power:
            row.append(inner_array[i])
        write.writerow(row)
        row = []
        i += 1
# writepath = r"C:\Users\sean8\Desktop\frucd code\2024-04-27\Parsed\005_Water_Air_Temp.csv"
# with open(writepath,'w',newline='') as csv_file:
#     write = csv.writer(csv_file)
#     write.writerow(Water_Air_temps_fields)
#     write.writerows(temp_data)
# writepath = r"C:\Users\sean8\Desktop\frucd code\2024-04-27\Parsed\005_Motor_temp.csv"
# with open(writepath,'w',newline='') as csv_file:
#     write = csv.writer(csv_file)
#     write.writerow(Motor_fields)
#     write.writerows(Motor_temps)
#     writepath = r"C:\Users\sean8\Desktop\frucd code\2024-04-27\Parsed\005_MC_Temp.csv"
# with open(writepath,'w',newline='') as csv_file:
#     write = csv.writer(csv_file)
#     write.writerow(MC_fields)
#     write.writerows(MC_temps3)
# writepath = r"C:\Users\sean8\Desktop\frucd code\2024-5-11\Parsed\Conner_Skidpad_Strain_Gauge.csv"
# with open(writepath,'w',newline='') as csv_file:
#     write = csv.writer(csv_file)
#     write.writerow(Strain_fields)
#     write.writerows(strain_data)