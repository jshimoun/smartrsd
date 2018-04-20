%{

epsGen.m
SMART power subsystem sizing

Author: Jared Shimoun
Date: 1/29/18

%}

clear
clc

%% TYPES OF MANEUVERS
% Cruise [1]
% Grapple [2]
% PrimBurns [3]
% Cruise w VV [4]
% Proximity Ops [5]

%% TUG ORDER
% Grapple (2) for 10 min
% ProxOps (5) for 4.75 min
% PrimBurns (3) for 0.0455 min
% Cruise (1) for 6.25 min
% PrimBurns (3) for 0.37 min
% ProxOps (5) for 5 min
% Grapple (2) for 10 min
% Cruise w VV (4) for 4.17 min
% PrimBurns (3) for 2.4 min
% Cruise w VV (4) for 3.47 min
% PrimBurns (3) for 1.14 min
% ProxOps (5) for 43.34 min
% Grapple (2) for 10 min
% ProxOps (5) for 5 min
% Grapple (2) for 10 min

tug_man = [2, 5, 3, 1, 3, 5, 2, 4, 3, 4, 3, 5, 2, 5, 2];
t = [10, 4.75, 0.05, 6.25, 0.37, 5, 10, 3.47, 2.4, 4.17, 1.14, 43.34, 10, 5, 10];
tug_man_len = length(tug_man);
t_tug_man = ceil(sum(t));

%% Set Average Power Requirement
P_avg = 475; % Total power (W)
    
%% Set peak power requirements

p_Cruise = 759; % W
p_Grapple = 1342; % W
p_PrimBurns = 1955; % W
p_Cruise_w_VV = 759; % W
p_ProxOps = 920; % W

p = [p_Cruise, p_Grapple, p_PrimBurns, p_Cruise_w_VV, p_ProxOps];
p_peak = p;

% Set tug peak power
p_tug_total = 0;
for i = 1:tug_man_len
    cman = tug_man(i);
    p_tug_total = p_tug_total + p(cman);
end

%% Convert time to hours
min2hr = 1/60;
t_hr = t*min2hr;

%% Compute battery capacity for each phase


% Caculate total battery capacity
cap_total = 0;
for j = 1:tug_man_len
    cman = tug_man(j);
    cap_total = cap_total + p(cman)*t_hr(j);
end

cap_total

%% Compute solar array approximate size
%Triple Junction GaAs parameters
X_e = 0.60; % Assuming peak power tracking
X_d = 0.80; % Assuming peak power tracking
n_EOL = 0.28; % end of life efficiency
wc_SF = 1420; % Worst case max solar flux (W/m^2)
theta = 20; % Worst case incidence angle in degrees
T_e = 0; % hours operating in eclipse
T_d = 24; % hours operating in daylight
I_d = 0.975; % Inherent degradation
L = 5; % Satellite lifetime in years
D = 0.05; % Degredation per year (for Triple Junction GaAs)
rho_sa = 2.8; % kg/m^2

% Calculate power during eclipse and daylight
P_e = P_avg; % Power during eclipse (W)
P_d = P_avg; % Power during daylight (W)

% Beginning of life power
P0 = n_EOL * wc_SF; % nominal power
P_BOL = P0*I_d*cosd(theta);

% Life degradation
L_d = (1 - D)^L;

% Calcualate solar array power
P_sa = ((P_e*T_e)/X_e + (P_d*T_d)/X_d) / T_d;

% Calcualte EOL power
P_EOL = P_BOL * L_d;

% Calculate solar panel mass and size
A_sa = P_sa / P_EOL
M_sa = A_sa * rho_sa

%% Plots

% Set peak powers
i = 1;
P_peak_mat = zeros(1, t_tug_man*100);
for j = 1:tug_man_len
    cman = tug_man(j);
    inc = i + t(j)*100;
    P_peak_mat(i:inc) = p_peak(cman);
    i = t(j)*100 + i;
end

figure(1)
time = 0:0.01:(t_tug_man-0.01);
plot(time(1:10959), P_peak_mat(1:10959), 'linewidth', 2);
set(gca, 'fontsize', 12);
xlabel('Time (minutes)', 'fontsize', 14)
ylabel('Power (W)', 'fontsize', 14)
title('Approximate Peak Power for Tug Task', 'fontsize', 14)

