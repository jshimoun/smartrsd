
%% Documentation
% Determine how much Cygnus-Std docked to SMART RSD occludes the view
% Abhiram Krishnan
% Space 583 | W18
% SMART RSD

%% Generate view
tic
%[percentage_u,percentage_w,fits] = pinhole(2,50,-2,0,0.035,45,16/9,3);
[percentage_u,percentage_w,fits] = pinhole(2,20,-2,0,0.035,45,16/9,3);
toc
