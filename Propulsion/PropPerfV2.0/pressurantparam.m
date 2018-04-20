function [p1,T1,M,gamma,V1,m] = pressurantparam()

p1 = 28.5; %initial pressurant tank pressure (MPa)
T1 = 273.15; %pressurant tank initial temp (K)
M = 4; %molar mass pressurant  (He = 4g/mol, N = 28g/mol)
gamma = 1.66; %specific heat ratio of pressurant (He=1.66, N=1.4)
V1 = .11;  %Pressurant Tank Volume (m^3)
m = ((p1*10^6*V1*M)/(8.314*T1))*10^-3 %mass of pressurant (kg)