% Filename: MLI_RadiatorTradeStudy
% MLI Material and Radiator Area Trade Study
% Space 582 - Orbital ATK SMART RSD, Thermal Control Subsystem

clc
clear

% Load Material Property Values
MaterialsScript
MaterialsNamesScript

% Declare Global Variables
global a_MLI_design e_MLI_design minA_r ...
    s h A_b A_s A_total SB_const e_rad_open...
    e_rad_closed a_rad_open a_rad_closed r_p r_a F_p_nadir F_p_side ...
    F_a_nadir F_a_side A_MLI

% Spacecraft and Given Parameters
S_max = 1421;               %W/m^2; max solar irradiance
S_min = 1323;               %W/m^2; min solar irradiance
S_avg = 1368;               %W/m^2; avg solar irradiance
max_IR_flux = 1314;         %W/m^2; maximum IR flux
aph_IR_flux = 1226;         %W/m^2; aphelion IR flux
min_IR_flux = 5;            %W/m^2; minimum IR flux
Q_op_max = 792*.5;
Q_off = 0;                  %W; non-operating waste heat
T_op_min = 10+273;          %K; minimum operating temperature
T_op_max = 30+273;          %K; maximum operating temperature
T_off_min = 2+273;          %K; minimum survival temperature
s = 2;                      %m; spacecraft side length
h = 0.6;                    %m; spacecraft height
A_b = s^2;                  %m^2; hexagonal area
A_s = s*h;                  %m^2; side area
A_total = 2*A_b+4*A_s;      %m^2; total surface area
SB_const = 5.67051e-8;      %W/m^2/K^4; Stefan-Boltzmann constant
max_albedo = 0.13;          %maximum Moon albedo
avg_albedo = 0.073;         %average Lunar subsolar albedo
e_rad_open = e_rad*0.8;     %open radiator emittance
e_rad_closed = e_rad*0.1;   %closed radiator emittance
a_rad_open = a_rad;         %open radiator absorptance
a_rad_closed = a_rad*2;     %closed radiator absorptance
r_p = 3573;                 %km; min perilune
r_a = 100734;                %km; max apolune
F_p_nadir = viewFactor(r_p,0); %Perilune, nadir-pointing view factor
F_p_side = viewFactor(r_p,90); %Perilune, side-pointing view factor
F_a_nadir = viewFactor(r_a,0); %Apolune, nadir-pointing view factor
F_a_side = viewFactor(r_a,90); %Apolune, side-pointing view factor

% 3D Matrix Dimensions
w = length(e_MLI_outer);
x = length(e_MLI_interior);
y = length(e_MLI_inner);
z = length(layers);
solA_4D = zeros(length(layers),w,x,y,z);

%% Determine Optimal MLI Combination
% External Loads
q_s = a_MLI.*S_max;%W/m^2; max solar heat load per unit area
Q_s = q_s.*A_b;         %W; max solar heat load

q_alb_nadir = a_MLI.*S_max*max_albedo*F_p_nadir; %nadir albedo
q_alb_side = a_MLI.*S_max*max_albedo*F_p_side; %side albedo
Q_alb = q_alb_nadir*A_b + q_alb_side*4*A_s; %W;  albedo heat load

q_IR_nadir = e_MLI.*max_IR_flux*F_p_nadir;%nadir rad IR per m^2
q_IR_side = e_MLI.*max_IR_flux*F_p_side; %side albedo
Q_IR = q_IR_nadir.*A_b + q_IR_side*4*A_s; %W;  IR heat load

Q_ext = Q_s + Q_alb + Q_IR; %Cumulative External Heat Loads

% Minimum Heat Lost through MLI
Q_MLI_min_divA = e_MLI.*SB_const*(T_op_max-5)^4; %10 K contingency

% Heat Rejected through Radiator
Q_rad_divA = e_rad_open.*SB_const*(T_op_max-5)^4; %10 K contingency
Q_rad_divA = repmat(Q_rad_divA,w,x,y,z);

% Heat In
Q_in = repmat(Q_op_max,w,x,y,z) + Q_ext;
% Heat Out
Q_out_x = Q_MLI_min_divA*A_total;
Q_out_y = Q_rad_divA-Q_MLI_min_divA;

% Calculate Radiator Area
A_r = (Q_in-Q_out_x)./Q_out_y;

%% Post Processing for MLI Optimization

% Find Smallest Area
[~,minA_r_ind] = min(A_r(:));

% Determine Corresponding Materials
[a,b,c,d] = ind2sub(size(A_r),minA_r_ind);
MLI_outer_opt = MLI_outer_names(a);
MLI_interior_opt = MLI_interior_names(b);
MLI_inner_opt = MLI_inner_names(c);
layers_opt = layers(d);

% Determine Corresponding Parameters
a_MLI_design = a_MLI(a,b,c,d);
e_MLI_design = e_MLI(a,b,c,d);

%% Determine Radiator Area - Hot Case

syms minA_r_sym

% External Loads
q_s = a_MLI_design.*S_max;%W/m^2; max solar heat load per unit area
Q_s = q_s*A_b;         %W; max solar heat load

q_alb_nadir_MLI = a_MLI_design*S_max*max_albedo*F_p_nadir; %nadir albedo
q_alb_side_MLI = a_MLI_design*S_max*max_albedo*F_p_side; %side albedo
q_alb_side_rad = a_rad_open*S_max*max_albedo*F_p_side; %side albedo
Q_alb = q_alb_nadir_MLI*A_b + q_alb_side_MLI*(4*A_s-minA_r_sym) + ...
    q_alb_side_rad*minA_r_sym; %W;  albedo heat load

q_IR_nadir_MLI = e_MLI_design*max_IR_flux*F_p_nadir;%nadir rad IR per m^2
q_IR_side_MLI = e_MLI_design*max_IR_flux*F_p_side; %side MLI IR
q_IR_side_rad = e_rad_open*max_IR_flux*F_p_side; %side radiator IR
Q_IR = q_IR_nadir_MLI.*A_b + q_IR_side_MLI*(4*A_s-minA_r_sym) + ...
    q_IR_side_rad*minA_r_sym; %W;  IR heat load

Q_in = Q_s + Q_alb + Q_IR + Q_op_max; %Cumulative Heat Loads

% Minimum Heat Lost through MLI
Q_MLI_min = e_MLI_design*SB_const*(T_op_max-5)^4*(A_total-minA_r_sym); %10 K contingency

% Heat Rejected through Radiator
Q_rad = e_rad_open*SB_const*(T_op_max-5)^4*minA_r_sym; %10 K contingency

Q_out = Q_MLI_min + Q_rad; %Cumulative Heat Out

% Calculate Radiator Area
eqn_rad = Q_in == Q_out;
minA_r = double(solve(eqn_rad,minA_r_sym));

%% Radiator, MLI, and Louver Mass 
rho_quartz = 2648; %kg/m^3; quartz density
t = 0.0002032;     %m; 8 mil thickness in m
rho_HC = 163;      %kg/m^3; aluminum honceomb structure thickness (from googling)
t_HC = 3.8e-2;     %m; aluminum honeycomb thickness (assumption)
m_rad = minA_r*t*rho_quartz + minA_r*t_HC*rho_HC; %mass of radiator

backed_teflon_density = 0.55;  %kg/m^2
kapton_density = 0.036; %kg/m^2
polymide_density = 0.05;%kg/m^2
A_MLI = A_total-minA_r;
m_MLI = A_MLI*(backed_teflon_density+layers_opt*kapton_density+polymide_density);

A_L = minA_r;       %Louver area same as radiator area
rho_L = 5.4;     %kg/m^2
m_L = A_L*rho_L; %louver mass

% Passive Control Results Table
table(MLI_outer_opt,MLI_interior_opt,MLI_inner_opt,layers_opt,minA_r,...
    m_rad,m_MLI,m_L)
%% Heater Sizing

% Mode Powers (W)
Q = [502;   %repair
     365;   %proximity ops
     357;   %inspection
     792;   %orbit transfer -> no heater required
     365;   %cruise
     447;   %grapple
     365;   %hold
     298];  %hibernation
 
% Mode Names
modes = ["repair";
         "proximity ops";
         "inspection";
         "orbit transfer";
         "cruise";
         "grapple";
         "hold";
         "hibernation"];

Q_op_min = Q.*.1; %Assume 10% waste heat

% Heater Sizing for Cold Case
Q_CC = HeaterPower(avg_albedo,aph_IR_flux,S_min,Q_op_min,T_op_min);

% Heater Sizing for Solar Eclipse
Q_SE = HeaterPower(0,min_IR_flux,0,Q_op_min,T_op_min);
 
% Heater Sizing for Lunar Eclipse
Q_LE = HeaterPower(0,0,S_min,Q_op_min,T_op_min);

% Heater Sizing for Worst Case (No Waste Heat)
Q_WC = HeaterPower(0,0,0,zeros(8,1),T_off_min);

%% Results Table
table(modes,Q_CC,Q_SE,Q_LE,Q_WC)