% Filename: a_eff.m
% Effective Absorptance using Effective Emittance
% Space 582 - Orbital ATK SMART RSD, Thermal Control Subsystem
function [ a_MLI ] = a_eff( a_outer,e_outer,e_eff )
%Effective absorptance (eq. 23)  
%Source: Effective Solar Absorptance of Multilayer Insulation (P. Bhandari)
SB_const = 5.67051e-8;   %W/m^2/K^4; Stefan-Boltzmann constant
e_0 = 0.02;              %reference value  
S_max = 1421;            %W/m^2
T_1 = 30+273;            %K; maximum operating temperature
T_sb = ((((e_eff.*e_outer)./(e_outer-e_eff)).*T_1^4 + a_outer*S_max/SB_const)./...
            ((e_outer^2)./(e_outer-e_eff))).^(1/4);
a_MLI = (e_0*T_1^4 - ((e_eff.*e_outer)./(e_outer-e_eff)).*(T_1.^4-T_sb.^4)).*SB_const/S_max;        
end