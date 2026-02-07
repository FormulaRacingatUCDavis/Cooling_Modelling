p = 998 %Density of water kg/m^3
ID = 0.01 %ID in meters
u = 0.001 %Viscosity in Pa.s
k = .6445 %Thermal Conductivity of water ~50 C
Cp = 4180 %Cp water J/kg K
Q = 7/(60*1000) %Flow rate LPM -> m^3/s
C = 0.023 %Local Friciton Coefficient
v = Q/(pi*(ID/2)^2) %Flow velocity m/s
Re = (p*v*ID)/u %Reynolds Number
Pr = (u*Cp)/k %Prandtl Number 
Nu = C*(Re^(4/5))*(Pr^0.4) %Nusselt Number w/ assumption n = 0.4 for heating
h = 
