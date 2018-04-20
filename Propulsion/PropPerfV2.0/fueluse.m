function [tp,mp,dmf,mf] = fueluse(dV,mp,m0,c,F)
% Calulate amount of fuel used and burn time for given dV

mf = m0*exp(abs(dV)/(-c)); %Final mass post burn (kg)
dmf = m0-mf;          %Fuel used during burn (kg)
mp = mp-dmf;          %Update propellant mass (kg)
tp = (c*dmf)/F;       %time to complete burn (s)
                      



