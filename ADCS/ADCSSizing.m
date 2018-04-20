% Space 582 HW 3 Prob 1 - Disturbance Torques

% Gravity Gradient Torque
mu = 4.905e12; %m^3/s^2; Moon gravitational constant
r = 1737.1e3;    %m; Moon radius
R = 49000+r;   %m; orbital altitude
I_x = 71225.44; %66533;     %kg*m^2; moment of inertia about x-axis
I_y = 71225.44; %66533;      %kg*m^2; moment of inertia about y-axis
I_z = 5046.57; %3410;     %kgm^2; moment of inertia about z-axis
theta = 1;   %deg; maximum deviation of z-axis from local vertical

T_g = (3*mu)/(2*R^3)*abs(I_z-I_y)*sind(2*theta); %Max Gravity Torque


% Solar Radiation Torque
F_s = 1367;    %W/m^2; solar constant
c = 3e8;       %m/s; speed of light
A_s = 9.65;   %m^2; surface area
q = 0.95;       %solar reflectivity, body-mounted arrays
i = 0;         %deg; angle of incidence from Sun
d_cpo = 0.1;   %m; offset distance from CoM to solar and aero CoPs

F = (F_s/c)*A_s*(1+q)*cosd(i); %Max Solar Radiation Pressure Force
T_sp = F*d_cpo; %Max Solar Radiation Torque


% Magnetic Field Torque
D = 0.1;       %A*m^2; magnetic dipole of s/c
M = 0;   %T*m^3; Earth magnetic moment
lambda = 2;   %unitless; function of magnetic latitude

B = 2*M/R^3*lambda; %Earth magnetic field intensity
T_m = D*B; %Magnetic Torque


% Aerodynamic Torque
rho = 0; %kg/m^3; atmospheric density
C_d = 1;       %drag coefficient
A = 1;         %m^2; frontal surface area
v = sqrt(mu/R);%m/s; s/c velocity

F_d = 0.5*rho*C_d*A*v^2; %Drag Force
T_a = F_d*d_cpo; %Max Aerodynamic Torque

%% Part C

% Reaction Wheel Sizing
P = 1200; %3*24*60*60; %s orbital period
p = 2*60;
h = max([T_g,T_sp,T_m,T_a])*P*1.5%(0.707/15)%Angular Momentum Storage

%Thruster Sizing
momen = 8;%68;
L = 1.5;
t = 1;
F_th = momen/(L*t)
pulses = 1*3*4;% 1 pulse(mom. dump), 3 axes, 4 total maneuvers, 1 tug
Isp = 225; %65; %s 65s for cold gas
Ft = pulses*1*F_th;
g = 9.8;
M_p = Ft/(Isp*g)
V_p = M_p./1.2504
slew_torque = (4*pi*I_x)./((0.5.*60.*60).^2) %slew for 10 minutes