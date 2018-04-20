function [C] = HeatConducted(Q,T)
%IR Heat Load
    %A = Area
    %T_r = radiator temp 
    %T_s = source temp
    %Q = heat load 
    
C = Q/(T_s-T_r); 

end