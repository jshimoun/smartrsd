%% Determine pressurant tank initial pressure and thrust needed for given dV req.  
clear
[c,md,mp,mvv,p0,p1,T1,m,M,rho,gamma,V1,m_dot,F,maxt,maxct]=initialc;    % Gather Initial Conditions
dVreq = [24.1,25,25,25];     % Delta V req. for each burn (m/s)
p2 = p1;                      %Intialize Pressure 
j = 1;                        %initialize counter
dt = 0.1;                     %time step (s)
vi = 0.9;                     %initial spacecraft velocity (leaving keep out zone)
dVt = zeros(1,size(dVreq,2)); %initialize dV summation for loop condition
flip = [375 0 250 0];         %vector of coast times to complete flip of RSD stack
%35 %208

for i = 1:size(dVreq,2)  %loop through each dV requiremnt is met
    while abs(dVt(i)) < dVreq(i) %loop until each dV requiremnt is met
    
        %determine if burn has VV mass
        if i==3||i==4
            m0(j)=mp(j)+md+mvv;  %VV is active in last two burns
        else
            m0(j)=mp(j)+md;      %no VV in first two burns
        end
       
        [a(j),vf(j),dV(i,j),d(j)] = dVcalc(F,m0(j),vi,dt,i);             %dV calcs for step (see fxn code)
        [tp(j),mp(j+1),dmf(j),mf(j)] = fueluse(dV(i,j),mp(j),m0(j),c,F); %dV calcs for step (see fxn code)
        [p2(j),T2(j)] = is_expansion(p1,T1,V1,gamma,dmf(j),rho);         %dV calcs for step (see fxn code)
        pused(j)=sum(dmf);   %total fuel used
        dVt(i)=sum(dV(i,:)); %total dV in manuvers
        distT(j)=sum(d);     %total distance in manuver
        
        vi=vf(j);      %update initial velocity
        T1=T2(j);      %update initial temp
        p1=p2(j);      %update initial pressure
        tc(j) = dt*j;  %current simulation time
        j=j+1;         %update indexing counter
    end 
    stopb(i) = j-1;
    if i==1||i==3 
        flipt=0;
        z=1;
        while flipt<flip(i)  %simulate cost during flip manuvers
            if i==3||i==4
                m0(j)=mp(j)+md+mvv;
            else
                m0(j)=mp(j)+md;
            end
        
            [a(j),vf(j),dV(i,j),d(j)] = dVcalc(0,m0(j),vi,dt,i);
            [tp(j),mp(j+1),dmf(j),mf(j)] = fueluse(dV(i,j),mp(j),m0(j),c,F);
            [p2(j),T2(j)] = is_expansion(p1,T1,V1,gamma,dmf(j),rho);
            flipt=dt*z;
            pused(j)=sum(dmf);   %propellant used
            dVt(i)=sum(dV(i,:));
            distT(j)=sum(d);
            vi=vf(j); %update initial velocity
            T1=T2(j); %update initial temp
            p1=p2(j); %update initial pressure
            tc(j) = dt*j;
            j=j+1;
            z=z+1;
        end
    end
    stopc(i) = j-1;
end

figure(1)
subplot(2,2,1)
plot(tc,distT);
title('Distance Traveled');xlabel('Time (s)');ylabel('Distance (m)');grid on

subplot(2,2,2)
plot(distT,vf);
title('Relative Velocity');xlabel('Time (s)');ylabel('Velocity (m/s)');grid on

subplot(2,2,3)
plot(distT,mp(1:j-1));
title('Propellant Mass');xlabel('Distance (m)');ylabel('Propellant Mass (kg)');grid on

subplot(2,2,4)
plot(distT,p2);
title('Pressurant Pressure');xlabel('Distance (m)');ylabel('Propellant Used (kg)');grid on

hymargin = (mp(end)/mp(1))*100  %hydrazine margin
hemargin = ((p2(end)/p0)-1)*100 %helium margin
vfuel = mp(1)/rho               %total fuel volume used
