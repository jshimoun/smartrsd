
%% Documentation
% Assess how well the robotic arm workspace can be seen from a particular camera view
% Abhiram Krishnan
% Space 583 | W18
% SMART RSD

%% Setup
addpath(genpath('roboticarm_workspace'))

%% Generate view
%[percentage_u,percentage_w,fits] = pinhole(3,0.75,0.15,0.15,0.035,120,16/9,1);
[percentage_u,percentage_w,fits] = pinhole(3,3,0.3,0.3,0.035,120,16/9,1);

