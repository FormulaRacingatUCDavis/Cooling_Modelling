import csv
path = r'C:\Users\sean8\Desktop\frucd code\20.csv'
MC_temps1 = []
MC_temps2 = []
MC_temps3 = []
Motor_temps = []
Radiator_air_temps = []
MC_water_temps = []
Motor_water_temps = []
Accumulator_current_draw = []
Torque_requested = []
HI_temp = []
Pack_voltage = []   
def translateMC1(list,line):
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
    list.append([temp_a/10,temp_b/10,temp_c/10,int(line[7])/10,int(line[8])/10])

def translateMC2(list,line):
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
    temp_d = int(line[7]*256) + int(line[8])
    if temp_d >= limit:
        temp_d = temp_d - 2*limit
    list.append([temp_a/10,temp_b/10,temp_c/10,temp_d/10])

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
    list2.append([float(line[9])/10**6,temp_c/10])

def translateVoltage(list,line):
    limit = 32768
    voltage = int(line[5])*256 + int(line[6])
    if  voltage >= limit:
        voltage = voltage - 2*limit
    list.append([voltage/100])

def translateCurrent(list,line):
    limit = 32768
    current = int(line[5])*256 + int(line[6])
    if  current >= limit:
        current = current - 2*limit
    list.append([current])

with open(path, 'r') as csv_file:
    csv_reader = csv.reader(csv_file)
    for line in csv_reader:
        if line[0] == 'A0':
            translateMC1(MC_temps1,line)
        elif line[0] == 'A1':
            translateMC2(MC_temps2,line)
        elif line[0] == 'A2':
            translateMC3(MC_temps3,Motor_temps,line)
        elif line[0] == '401':
            Radiator_air_temps.append(line[1:5])
        elif line[0] == '400':
            MC_water_temps.append(line[1:3])
            Motor_water_temps.append(line[3:5])
        elif line[0] == '380':
            HI_temp.append(line[1])
            translateVoltage(Pack_voltage,line)
        elif line[0] == '387':
            translateCurrent(Accumulator_current_draw,line)

MC_fields1 = ['Module A Temp','Module B Temp','Module C Temp','Gate Driver Board Temp']
MC_fields3 = ['Coolant/RTD #4 Temp','Hot Spot/RTD #5 Temp']
Motor_fields = ['Time','Motor Temps']
Radiator_fields = ['MC Inlet','MC Outlet','Motor Inlet','Motor Outlet']
MC_water_fields = ['MC Water Inlet','MC Water Outlet']
Motor_water_fields = ['Motor Water Inlet','Motor Water Outlet']
HI_temp_fields = ['Temperature']
Pack_voltage_fields = ['Volts']
Accumulator_current_draw_fields = ['Amps']
Torque_requested_fields = ['N*m']
writepath = r'C:\Users\sean8\Desktop\frucd code\Motor Temps.csv'
with open(writepath,'w',newline='') as csv_file:
    write = csv.writer(csv_file)
    write.writerow(Motor_fields)
    write.writerows(Motor_temps)
"""
print(MC_temps1)
print(MC_temps2)
print(MC_temps3)

print(Radiator_air_temps)

print(Motor_temps)

print(Pack_voltage)
"""