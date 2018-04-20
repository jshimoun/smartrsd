
%% Documentation
% Generate point cloud of DSG based on three moonnus-Standard modules
% Abhiram Krishnan
% Space 583 | W18
% SMART RSD

%% Function
function [X,Y,Z] = moon_pointcloud(dist_from_camera,vdist,hdist,focal_length,plot_in)
    radius = 1736482;
    [X,Z,Y] = sphere(50);
    X = radius*X + hdist;
    Y = radius*Y + dist_from_camera+focal_length+radius;
    Z = radius*Z + vdist;
    X = reshape(X,[1,size(X,1)*size(X,2)]);
    Y = reshape(Y,[1,size(Y,1)*size(Y,2)]);
    Z = reshape(Z,[1,size(Z,1)*size(Z,2)]);
    if plot_in > 0
        figure;
        plot3(X,Y,Z,'b.');
        xlabel('x'); ylabel('y'); zlabel('z');
    end
end