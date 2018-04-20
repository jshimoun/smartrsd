function [Q] = HeaterPower(albedo,IR_flux,S,Q_waste,T_min)
%This function calculates heater power
global a_MLI_design e_MLI_design minA_r ...
    s h A_b A_s A_total SB_const e_rad_open...
    e_rad_closed a_rad_open a_rad_closed r_p r_a F_p_nadir F_p_side ...
    F_a_nadir F_a_side A_MLI
% Set Up Symbolic Solver for Temperature
syms T

%% Heat Loads

q_alb_nadir_MLI = a_MLI_design.*S*albedo*F_a_nadir; %W/m^2; albedo heat flux
q_alb_side_MLI = a_MLI_design.*S*albedo*F_a_side; 
q_alb_side_rad = a_rad_closed*S*albedo*F_a_side; %side albedo
Q_alb = q_alb_nadir_MLI*A_b + q_alb_side_MLI*(4*A_s-minA_r) + ...
    q_alb_side_rad*minA_r;        %W;  albedo heat load

q_IR_nadir_MLI = e_MLI_design.*IR_flux*F_a_nadir; %IR heat  flux
q_IR_side_MLI = e_MLI_design.*IR_flux*F_a_side; 
q_IR_side_rad = e_rad_closed*IR_flux*F_a_side; %side radiator IR
Q_IR = q_IR_nadir_MLI.*A_b + q_IR_side_MLI*(4*A_s-minA_r) + ...
    q_IR_side_rad*minA_r;       %W;  IR heat load

Q_in = Q_alb + Q_IR + Q_waste; %sum of heat loads

%% Heat Lost

% Maximum Heat Lost through MLI 
Q_MLI_max_div_T = e_MLI_design*SB_const*(A_MLI); 

% Heat Rejected through Radiator 
Q_rad_div_T = e_rad_closed*SB_const*(minA_r); 

Q_out = Q_MLI_max_div_T + Q_rad_div_T;

%% Calculate Temperature
%eqn = Q_in == Q_out;
solT = (Q_in./Q_out).^(1/4);%max(real(double(solve(eqn,T))));

%% Determine Heater Power

% Maximum Heat Lost through MLI
Q_MLI_max = e_MLI_design*SB_const*(A_MLI)*(T_min+5)^4; %10 K margin

% Heat Rejected through Radiator
Q_rad = e_rad_closed*SB_const*(minA_r)*(T_min+5)^4; %10 K margin

Q = zeros(8,1);

for i = 1:length(Q_waste)
    if solT(i) > T_min
        Q(i) = 0; %No heat required
    else
        Q(i) = Q_rad + Q_MLI_max - Q_in(i);
    end

end

