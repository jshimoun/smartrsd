
%% Documentation
% Generate point cloud of DSG based on three Cygnus-Standard modules
% Abhiram Krishnan
% Space 583 | W18
% SMART RSD

%% Function
function [X,Y,Z] = dsg_pointcloud(dist_from_camera,vdisp,hdisp,focal_length,plot_in)
    % Grab a Cygnus module and make it Module 1
    [Xcyg1,Ycyg1,Zcyg1] = cygnusstd_pointcloud(0,0,0,focal_length,0,0);
    % Module 2
    Xcyg2 = Xcyg1;
    Ycyg2 = Zcyg1+5.1;
    Zcyg2 = Ycyg1-5.1-3.07/2;
    % Module 3
    Xcyg3 = -Ycyg1+5.1+3.07/2;
    Ycyg3 = Xcyg1+5.1;
    Zcyg3 = Zcyg1;
    % Concatenate into a single point cloud
    X = [Xcyg1 Xcyg2 Xcyg3]+hdisp;
    Y = [Ycyg1 Ycyg2 Ycyg3]+dist_from_camera;
    Z = [Zcyg1 Zcyg2 Zcyg3]+vdisp;
    % Plot
    if plot_in > 0
        figure; plot3(X,Y,Z,'.'); xlabel('x'); ylabel('y'); zlabel('z');
    end
end