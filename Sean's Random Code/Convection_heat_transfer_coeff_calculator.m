%% Convection heat transfer coefficient equation
% Plug in different parameters depending on scenario you want to sim

% ONLY VALID FOR Turbulent, 0.6 ≲ 𝑃r ≲ 60, 𝑅e𝑥 ≲ 10^8

%% Air properties

% Fill in depending on temperature you want to evalutate at

Cp = 1; %[J/ kg C°]
mu = 1; %[Pa s]
rho = 1; %[kg/m3]
k_fluid = 1; %[W/mK]
u = 1; %[m/s]

%% 
d = 1; % diameter of brake rotor as "characteristic length" of flat plate
Re = (rho*u*d)/mu; 
Pr = (Cp*mu)/k_fluid;

h = k_fluid*(0.0296*Re^(4/3)*Pr^(1/3))/d;
disp("Convective Heat Transfer Coeff.: " + num2str(h) +" [W/m^2 K]")