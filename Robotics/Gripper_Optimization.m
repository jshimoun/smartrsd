%%%%%%%%%%%%%Gripper Finger Optimization%%%%%%%%%%%%%%%%%%%%%%%

%%%%%Assume Optimized Gripper Tendons
%Extensor Tendon
k_l = 0.24;
delta_l = 12.0;
%Joint Torsional Spring
k1 = 9.9; 
k2 = 4.5; 
delta_1 = 4.5;
delta_2 = 4.3;

%%%%%%Changeable Parameters
r1 = 2.4; %radii of mandrel 1
r2 = 3.2; %radii of madrel 2
%point 0
t_0x = -25.;
t_0y = 6.0;

%point 1
t_1x = -45.0;
t_1y = 3.6;

%point 2
t_2x = -7.6;
t_2y = 0.9;

%point 3
t_3x = -42.0;
t_3y = -5.0;

%%%%%%%%Solve for Gripper Link Lengths%%%%%%%%
base = 2*(t_0x - t_3x)*4/3; % in mm
link = (t_0x - t_3x - (t_3x - t_2x))*4/3; % in mm
t = 15; %thickness of finger

%%Fully Extended Width%%
full_height = link*sin(pi()/2)+link; %link 1 assumed to be at 45 degree angle + link 2
full_width = base + 2*link*sin(pi()/2)- 2*t;