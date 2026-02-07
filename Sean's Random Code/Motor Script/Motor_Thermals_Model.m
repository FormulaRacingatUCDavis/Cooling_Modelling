%Parameters and Solving for h
p = 998; %Density of water kg/m^3
ID = 0.01; %ID in meters
A = pi*(ID^2)/4; %Cross Sectional Area of pipe
u = 0.5465*10^(-3); %Viscosity in Pa.s (N*s/m^2)
k = .6445; %Thermal Conductivity of water ~50 C (W/m*K)
Cpw = 4180; %Cp water J/kg K
CpA = 900; %Cp Aluminum J/kg K
Q = 7/(60*1000); %Flow rate LPM -> m^3/s
C = 0.023; %Local Friciton Coefficient
v = Q/A; %Flow velocity m/s
L = 1; %Length of coolant channel
Re = (p*v*ID)/u; %Reynolds Number
Pr = (u*Cpw)/k; %Prandtl Number 
Nu = C*(Re^(4/5))*(Pr^0.4); %Nusselt Number w/ assumption n = 0.4 for heating
h = k*Nu/L; %Note: Double Check heat transfer coeff
m_rotor = 4.96; %Mass of Rotor in kg

%Setting up heat equations
Ts = zeros(N,1)

Tw = []