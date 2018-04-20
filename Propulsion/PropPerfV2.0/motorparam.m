function [p0,Isp,m_dot,c,F,maxt,maxct] = motorparam()

p0 = 2.76; %required prop tank pressure (MPa)
Isp = 232.1; %Specific Impulse Motor (1/s)
m_dot = 12*39.5*(10^-3); %Engine Flow Rate (kg/s)(from spec sheet)
c = Isp*9.81;  %Effective Exhaust Velocity (m/s)
F = Isp*9.81*m_dot; %Engine Thrust (N)
maxt = 0; %maximum single fire burn time
maxct = 38888.9; %maximum cumulative engine burn time

