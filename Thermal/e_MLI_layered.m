% Filename: e_MLI_layered.m
% Effective Emittance for N Interior Layers
% Space 582 - Orbital ATK SMART RSD, Thermal Control Subsystem
function [ e ] = e_MLI_layered( e1,e2,N )
e = (1 ./ (1./e1+1./e2-1)).*(1./(N+1));
end
