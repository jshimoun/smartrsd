function [ F ] = viewFactor( rsc, gamma )
%This function calculates the view factor (also known as configuration
%factor, geometry factor) Fdl-2, from an infinitesimal surface (dl)
%to the Moon (2). Output, Fe, is unitless.
%Inputs:
%rsc = spacecraft distance to center of Moon (km)
%gamma = angle between normal vector and nadir vector (degrees) 

gammar = gamma.*pi./180; %gamma in radians
Re=1737.4; %Radius of the Moon (km)

H = rsc./Re;
phi_m = asin(1/H);
b = sqrt(H.^2-1);

% if full Moon is visible to the plate
if gammar <= pi./2-phi_m
    F = cos(gammar)./H.^2;
% if part of the Moon is visisible to the plate
elseif gammar > pi./2-phi_m && gammar <= pi./2+phi_m
    tl = 1./2.*asin(b./(H.*sin(gammar)));
    t2 = 1./(2.*H.^2).*(cos(gammar).*acos(-b.*cot(gammar))...
        -b.*sqrt(1-H.^2.*(cos(gammar))^2));
    F = 2./pi.*(pi./4-tl+t2);
%if none of the Moon is visible to the plate
else
    F=0;
end
end 