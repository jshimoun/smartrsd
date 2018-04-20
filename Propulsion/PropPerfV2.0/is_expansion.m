function [p2 T2] = is_expansion(p1,T1,V1,gamma,dmf,rho)
% Calculate post burn pressure and temperature in pressurant tank
% Pressure in pressurant tank should not be less than prop tank presssure

dV = dmf/rho ;                  %volume of fuel used during burn (m^3)
p2 = p1*(V1/(V1+dV))^gamma;     %ullage tank pressure after burn (MPa)
T2 = T1*(p2/p1)^(1/(1+gamma));  %temperature ullage tank after burn (MPa)