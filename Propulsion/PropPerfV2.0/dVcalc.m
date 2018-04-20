function [a,vf,dV,d] = dVcalc(F,m0,vi,dt,i)
    if i==1||i==3
    a = F/m0;  %calculate vechile acceleration
    else
    a = -F/m0;
    end
    
    if F == 0 %for coasting only
        a=0;
        vf = vi+a*dt;
        dV = vf-vi;
        d=vi*dt;
    else          
        vf = vi+a*dt; %vehicle final velocity
        dV = vf-vi;   %dV given vf and vi
        d = abs((vf^2-vi^2)/(2*abs(a))); %distance traveled 
    end
    
return