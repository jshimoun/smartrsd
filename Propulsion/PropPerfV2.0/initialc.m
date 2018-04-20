function [c,md,mp,mvv,p0,p1,T1,m,M,rho,gamma,V1,m_dot,F,maxt,maxct]=initialc
% Call Initial conditions
% TO:DO re-organize for motor, propellant, pressurant systems

md = 764; %Spacecraft dry mass (kg)
mp = 239; %Propellant Initial Mass (kg)
mvv = 5300; %Visiting Vehicle Mass (kg) 1400-1500
rho = 1020; %density of fuel (kg/m^3) %Hydrazine:1020 MMH/NTO(1.6):1592 Hydrazine/NTO(1.34):1474.8

[p0,Isp,m_dot,c,F,maxt,maxct] = motorparam();
[p1,T1,M,gamma,V1,m] = pressurantparam();

