clear;clc;
%% Initializations
% can change the inputs to whatever you want them to be
% currently have old values for link lengths

% Length of joints
lj1 = 0.126;    % Dynamixel
lj2 = 0.108;    % Dynamixel

% Radius of links and joints
r = 0.1;   % link radius

rj1 = 0.054/2; % Dynamixel
rj2 = 0.054/2;   % Dynamixel

% Link lengths (from end of joint to start of next joint)
l1 = 0;
l2 = 0.45;
interl3 = 0.4;
l3 = interl3-2*rj1;
l4 = 0;
l5 = 0;
l6 = 0.22;   %added term = c.g. of end effector relative to end of joint
ltotal = l1+l2+l3+l4+l5+l6; %total length of links

% Mass of each link
density = 2700;
ml1 = density*l1*pi*r^2;
ml2 = density*l2*pi*r^2;
ml3 = density*interl3*pi*r^2;
ml4 = density*l4*pi*r^2;
ml5 = density*l5*pi*r^2;
ml6 = density*l6*pi*r^2;

% Total mass of links
mlTot = ml1 + ml2 + ml3 + ml4 + ml5 + ml6;

% Half angle of rotation (radians)
delTheta = pi/2;    

% Joints 1-3 and 4-6 Mass
mj1 = 0.853; % Dynamixel
mj2 = 0.710; % Dynamixel
mjTot = 3 * mj1 + 3 * mj2;  %total mass of joints

% Distances to centers of mass for each component (link/joint)
d1 = lj1 + l1/2;
d2 = d1 + l1/2 + rj1;
d3 = d2 + rj1 + l2/2;
d4 = d3 + l2/2 + rj1;
d5 = d4 + rj1 + l3/2;
d6 = d5 + l3/2 + rj2;
d7 = d6 + rj2 + l4/2;
d8 = d7 + l4/2 + rj2;
d9 = d8 + rj2 + l5/2;
d10 = d9 + l5/2 + lj2/2;
d11 = d10 + lj2/2 + l6;

% Mass of object = mass of object + end effector (35kg)
mob = input('Mass of object? ');
Mee = 40;
Mobj = mob + Mee;
Robj = 1;
%5 - 10 seconds in tiny time steps for resolution
t = linspace(5,10,10000); 

% Joint Inertias
ij1 = 3e-6; % Dynamixel
ij2 = 3e-6; % Dynamixel
%% Moment of Inertia Equations

Iobj = 2/5*Mobj*Robj^2; % assuming a sphere for object at end of end effector 
%i1 = 1/12*mj1*lj1^2+ml2*l1^2/12+ml1*d1^2+pi*rj1^4/4+mj1*d2^2+1/12*ml2*l2^2+ml2*d3^2+pi*rj1^4/4+mj1*d4^2+1/12*ml3*l3^2+ml3*d5^2+pi*rj2^4/4+mj2*d6^2+1/12*ml4*l4^2+ml4*d7^2+pi*rj2^4/4+mj2*d8^2+1/12*ml5*l5^2+ml5*d9^2+1/12*mj2*lj2^2+mj2*d10^2+Iobj+Mobj*d11^2;
i1 = ij1+ij1+1/12*ml2*l2^2+ml2*(d3-d2)^2+ij1+mj1*(d4-d2)^2+1/12*ml3*l3^2+ml3*(d5-d2)^2+ij2+mj2*(d6-d2)^2+1/12*ml4*l4^2+ml4*(d7-d2)^2+ij2+mj2*(d8-d2)^2+1/12*ml5*l5^2+ml5*(d9-d2)^2+ij2+mj2*(d10-d2)^2+Iobj+Mobj*(d11-d2)^2;
i2 = ij1+1/12*ml2*l2^2+ml2*(d3-d2)^2+ij1+mj1*(d4-d2)^2+1/12*ml3*l3^2+ml3*(d5-d2)^2+ij2+mj2*(d6-d2)^2+1/12*ml4*l4^2+ml4*(d7-d2)^2+ij2+mj2*(d8-d2)^2+1/12*ml5*l5^2+ml5*(d9-d2)^2+ij2+mj2*(d10-d2)^2+Iobj+Mobj*(d11-d2)^2;
i3 = ij1+1/12*ml3*l3^2+ml3*(d5-d4)^2+ij2+mj2*(d6-d4)^2+1/12*ml4*l4^2+ml4*(d7-d4)^2+ij2+mj2*(d8-d4)^2+1/12*ml5*l5^2+ml5*(d9-d4)^2+ij2+mj2*(d10-d4)^2+Iobj+Mobj*(d11-d4)^2;
i4 = ij2+1/12*ml4*l4^2+ml4*(d7-d6)^2+ij2+mj2*(d8-d6)^2+1/12*ml5*l5^2+ml5*(d9-d6)^2+ij2+mj2*(d10-d6)^2+Iobj+Mobj*(d11-d6)^2;
i5 = ij2+1/12*ml5*l5^2+ml5*(d9-d8)^2+ij2+mj2*(d10-d8)^2+Iobj+Mobj*(d11-d8)^2;
i6 = ij2+Iobj;

%% Joint 1 Torques
for i = 1:length(t)
    T1(i) = i1 .* (2 .* delTheta)./t(i)^2;
end
% testTime = input('time? ');
% assocT = i1*2*delTheta/testTime^2

testTorque = input('Torque from joint 1? ');
assocTime = sqrt(i1*2*delTheta/testTorque)

%% Joint 2 Torques
for i = 1:length(t)
    T2(i) = i2 .* (2 .* delTheta)./t(i)^2;
end

%% Joint 3 Torques
for i = 1:length(t)
    T3(i) = i3 .* (2 .* delTheta)./t(i)^2;
end

%% Joint 4 Torques
for i = 1:length(t)
    T4(i) = i4 .* (2 .* delTheta)./t(i)^2;
end
testTorque4 = input('Torque from joint 4? ');
assocTime4 = sqrt(i4*2*delTheta/testTorque4)

%% Joint 5 Torques
for i = 1:length(t)
    T5(i) = i5 .* (2 .* delTheta)./t(i)^2;
end

%% Joint 6 Torques
for i = 1:length(t)
    T6(i) = i6 .* (2 .* delTheta)./t(i)^2;
end
% testTorque6 = testTorque4;
% assocTime6 = sqrt(i6*2*delTheta/testTorque6)
joints = [T1', T2', T3', T4', T5', T6'];    % collection of joint times/torques
%% Plotting
for i = 1:6
    subplot(2,3,i)
    plot(t, joints(:,i))
    title(sprintf('Torque vs Time for Joint %d',i))
    xlabel('Time (s)')
    ylabel('Torque (N*m)')
end

tq1 = 10.1;
aTime1 = [sqrt(i1*2*delTheta/tq1),sqrt(i2*2*delTheta/tq1),sqrt(i3*2*delTheta/tq1)];
w1 = delTheta.*180/pi./aTime1;

tq2 = 3.9;
aTime2 = [sqrt(i4*2*delTheta/tq2),sqrt(i5*2*delTheta/tq2),sqrt(i6*2*delTheta/tq2)];
w2 = delTheta.*180/pi./aTime2;

%% Random dimensions/parameters
lengthTot = l1+l2+l3+l4+l5+l6+lj1+lj2+4*rj1+4*rj2;
massTot = mjTot + mlTot + Mobj;
massArm= mjTot + mlTot;
JPow1 = 72;    % Dynamixel
JPow2 = 45.6;    % Dynamixel
powTot = 3*(JPow1 + JPow2);