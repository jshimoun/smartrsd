% Filename: e_eff.m
% Effective Emittance for 3 Different Materials
% Space 582 - Orbital ATK SMART RSD, Thermal Control Subsystem
function [ e_eff ] = e_eff( e1,e2,e3 )
e_eff = e1.*e2.*e3./(1-(1-e1).*(1-e2).*(1-e3));
end

