%% Cleanup
clear all
close all
clc 
%% Constants
r_b = 0.1*10^-2;    %Bead radius [m]
r_t = 0.4*10^-2;    %Tissue radius [m]
q_gen_b = 10^8;     %Volumetric Heat Gen [W/m^3]
R_tc = 0.001;       %Contact Resistance [m^2K/W]
T_inf = 37.5;       %T infinity [C]
h = 75;             %Convective htc [W/m^2K]
k_b = 0.1;          %Bead Conductive htc [W/mK]
%% Setup

% Input to run desired case
case_num = input("Enter Case Number: '1', '2', '3', or 'All' :","s");
case_num= convertCharsToStrings(case_num);
while case_num ~= "1" && case_num ~= "2" && case_num ~= "3" && case_num ~= "All"
    disp("Error, Incorrect User Input")
    case_num = input("Enter Case Number: '1', '2', '3', or 'All' :","s"); 
end
%Updating Which Cases to run based on user input
if case_num == "All"
    cases = ["1","2","3"];
else
    cases = case_num;
end

figure()
for j = 1:length(cases)
    %Grid Generation
    Nb = 10;                                       %Number Bead of Nodes
    Nt = 40;                                       %Number of Tissue Nodes
    dr_b = r_b/(Nb-1);                             %Bead Delta r
    dr_t = (r_t-r_b)/(Nt-1);                       %Tissue Delta r
    r = [linspace(0,r_b,Nb),linspace(r_b,r_t,Nt)]; %Radius value for each Temperature node

    %Temperature Matrix Initialization
    T = ones(length(r),2);
    
    %Iteration Initialization
    delta_T = 1;
    tol = 1e-6;
    c = 1;
    while delta_T(end) > tol
        %Iteration Counter
        c=c+1;
        %Determining k_t and q_perf based on case
        switch cases(j)
            case "1"
                k_t = 0.5*ones(size(r)); %Tissue Conductive htc [W/mK]
                q_perf = zeros(size(r)); %Tissue q perferation [W/m^3]
            case "2"
                k_t = -0.621 + 6.03*10^-3* (T(:,c-1) +273.15) - 7.9*10^-6 .* (T(:,c-1)+273.15).^2; %Variable Tissue Conductive htc [W/mK]
                q_perf = zeros(size(r));                                                           %Tissue q perferation [W/m^3]
            case "3"
                k_t = -0.621 + 6.03*10^-3* (T(:,c-1) +273.15) - 7.9*10^-6 .* (T(:,c-1)+273.15).^2; %Variable Tissue Conductive htc [W/mK]
                q_perf = -20000.*(T(:,c-1)-37.5);                                                  %Variable Tissue q perferation [W/m^3]
        end
        
        %Boundary node at the center of the bead
        T(1,c) = q_gen_b*dr_b^2/(6*k_b) + T(2,c-1);
    
        %Interior nodes within the bead
        for i = 2:Nb-1
            T(i,c) = (T(i-1,c-1)*(k_b*4*pi*(r(i)-dr_b/2)^2)/dr_b + q_gen_b*(4/3*pi*((r(i)+dr_b/2)^3-(r(i)-dr_b/2)^3)) ...
            + T(i+1,c-1)*(k_b*4*pi*(r(i)+dr_b/2)^2)/dr_b)/((k_b*4*pi*((r(i)+dr_b/2)^2+(r(i)-dr_b/2)^2))/dr_b); 
        end
    
        %Contact Resitances
    
        T(Nb,c) = (T(Nb-1,c-1)*(k_b*4*pi*(r_b-dr_b/2)^2)/dr_b + q_gen_b*(4/3*pi*(r_b^3-(r_b-dr_b/2)^3)) + T(Nb+1,c-1)*4*pi*r_b^2/R_tc) ...
                /(4*pi*r_b^2/R_tc + (k_b*4*pi*(r_b-dr_b/2)^2)/dr_b);
        
        T(Nb+1,c) = (T(Nb+2,c-1)*(k_t(Nb+1)*4*pi*(r_b+dr_t/2)^2)/dr_t + q_perf(Nb+1)*(4/3*pi*((r_b+dr_t/2)^3-r_b^3)) + T(Nb,c-1)*4*pi*r_b^2/(R_tc)) ...
                  /(4*pi*r_b^2/R_tc + (k_t(Nb+1)*4*pi*(r_b+dr_t/2)^2)/dr_t); 
        
        %Interior nodes within the tissue
        for i = Nb+2:length(r) - 1
            T(i,c) = (T(i-1,c-1)*(k_t(i)*4*pi*(r(i)-dr_t/2)^2)/dr_t + q_perf(i)*(4/3*pi*((r(i)+dr_t/2)^3-(r(i)-dr_t/2)^3)) + T(i+1,c-1)*(k_t(i)*4*pi*(r(i)+dr_t/2)^2)/dr_t) ...
                   /((k_t(i)*4*pi*((r(i)+dr_t/2)^2+(r(i)-dr_t/2)^2))/dr_t); 
        end
    
        %Boundary node at the tissue surface
        T(end,c) = (T(end-1,c-1)*(k_t(end)*4*pi*(r_t-dr_t/2)^2)/dr_t + q_perf(i)*(4/3*pi*(r(end)^3-(r(end)-dr_t/2)^3)) + T_inf*h*(4*pi*r_t^2)) ...
                / (h*(4*pi*r_t^2) + k_t(end)*(4*pi*(r_t -dr_t/2)^2)/dr_t);
        
        %Residual Tracker to check for convergence
        delta_T = [delta_T,max(abs(T(:,c)-T(:,c-1)))];
    end
    
    %Plotting
    if case_num ~= "All" %For individual Cases
        %2D Temperature dsitribution
        switch cases
            case "1"
                name = ("Temperature Distribution" + newline + "Constant k_{bead}, q'''_{perf} = 0 ");
            case "2"
                name = ("Temperature Distribution" + newline + "Variable k_{bead}, q'''_{perf} = 0 ");
            case "3"
                name = ("Temperature Distribution" + newline + "Variable k_{bead} and q'''_{perf}");
        end
        %Adding Extremely small step to plot contact resistances
        r(Nb+1) = r(Nb+1) +0.000001;
        plot(r*100,T(:,end))
        xlabel("r [cm]")
        ylabel("Temperature [C]")
        title(name)
        
        %3D Surface Plot
        figure()
        theta = linspace(0,2*pi,length(r));
        [RR,Theta] = meshgrid(r,theta);
        XX_p = RR.*cos(Theta); % transform polar grid into cartesian form
        YY_p = RR.*sin(Theta);
        [~,TT] = meshgrid(r,T(:,end));
        surf(XX_p,YY_p,TT')
        colorbar;
        title(name)
        zlabel("Temperature [C]")
    else %For All Plots
        hold on
        switch j
            case 1
                name = "Case A";
            case 2
                name = "Case B";
            case 3
                name = "Case C";
        end
        %Adding Extremely small step to plot contact resistances
        r(Nb+1) = r(Nb+1) +0.000001;
        plot(r*100,T(:,end),'DisplayName',name)
        xlabel("r [cm]")
        ylabel("Temperature [C]")
        title("Temperature Distributions Along Radius")
        legend('Location','best')
    end
end