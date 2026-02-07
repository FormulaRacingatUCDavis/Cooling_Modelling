%% FORMULA ITERATION PROJECT
clear all
clc
close all

%% Givens
r_b = 0.1*10^-2;    %Bead radius [m]
r_t = 0.4*10^-2;    %Tissue radius [m]
q_gen_b = 10^8;     %Volumetric Heat Gen [W/m^3]
R_tc = 0.001;       %Contact Resistance [m^2K/W]
T_inf = 37.5;       %T infinity [C]
h = 75;             %Convective htc [W/m^2K]
k_b = 0.1;          %Bead Conductive htc [W/mK]

%% Computation
figure()
