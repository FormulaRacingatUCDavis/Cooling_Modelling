import csv
import glob
import os
#Setting up lists to store data from csv
Accumulator_current_draw = []
Torque_requested = []
HI_temp = []
Pack_voltage = []

Accumulator_current_draw_fields = ['Time (s)','Amps']
Torque_requested_fields = ['Time (s)','N*m']
HI_temp_fields = ['Time (s)','Temperature (Degrees C)']
Pack_voltage_fields = ['Time (s)','Volts']

#Getting all folder paths
folder_path = r"C:\Users\sean8\Desktop\frucd code\Motor Temp Test"
all_files = glob.glob(os.path.join(folder_path,'*.csv'))
#print(all_files)

#Parameters
limit = 32768
time_current = 0
time_torque = 0
time_HI_temp = 0
time_voltage = 0

#Iterating over all files
for i in range(len(all_files)):
    with open(all_files[i], 'r') as csv_file:
        csv_reader = csv.reader(csv_file)
        for line in csv_reader:
            if line != []:    
                if line[0] == 'A2':
                    current = int(line[5])*256 + int(line[6])
                    if  current >= limit:
                        current = current - 2*limit
                    time_current = time_current + float(line[9])*10**-6 
                    Accumulator_current_draw.append([round(time_current,2),current])
                if line[0] == 'C0':
                    torque = int(line[2])*256 + int(line[1])
                    if torque >= limit:
                        torque = torque - 2*limit
                    time_torque = time_torque + float(line[9])*10**-6
                    Torque_requested.append([round(time_torque,2),torque/10])
                if line[0] == '380':
                    voltage = int(line[5])*256 + int(line[6])
                    high_temp = int(line[1])
                    if voltage >= limit:
                        voltage = voltage - 2*limit
                    time_voltage = round(time_voltage + float(line[9])*10**-6,2)
                    Pack_voltage.append([time_voltage,voltage/100])
                    HI_temp.append([time_voltage,high_temp])


#Exporting to each csv file
writepath = r"C:\Users\sean8\Desktop\frucd code\Accumulator Current Draw.csv"
with open(writepath,'w',newline='') as csv_file:
    write = csv.writer(csv_file)
    write.writerow(Accumulator_current_draw_fields)
    write.writerows(Accumulator_current_draw)

writepath = r"C:\Users\sean8\Desktop\frucd code\Torque Requested.csv"
with open(writepath,'w',newline='') as csv_file:
    write = csv.writer(csv_file)
    write.writerow(Torque_requested_fields)
    write.writerows(Torque_requested)

writepath = r"C:\Users\sean8\Desktop\frucd code\Pack Voltage.csv"
with open(writepath,'w',newline='') as csv_file:
    write = csv.writer(csv_file)
    write.writerow(Pack_voltage_fields)
    write.writerows(Pack_voltage)

writepath = r"C:\Users\sean8\Desktop\frucd code\HI Temps.csv"
with open(writepath,'w',newline='') as csv_file:
    write = csv.writer(csv_file)
    write.writerow(HI_temp_fields)
    write.writerows(HI_temp)