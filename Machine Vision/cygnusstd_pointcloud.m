
%% Documentation
% Generate point cloud of Cygnus-Standard (dimensions based on Wikipedia)
% Abhiram Krishnan
% Space 583 | W18
% SMART RSD

%% Function
function [X,Y,Z] = cygnusstd_pointcloud(dist_from_camera,vdisp,hdisp,focal_length,plot_in,highres)
% Cygnus Standard: 3.07m diameter, 5.1m length, solar panels are 60"x124"
    % Set up cylinder
    if highres == 1
        angle = linspace(0,2*pi,270);
    else
        angle = linspace(0,2*pi,30);
    end
    cyl_length = 5.1;
    if highres == 1
        length_points = linspace(0,cyl_length,30);
    else
        length_points = linspace(0,cyl_length,20);
    end
    cyl_radius = 3.07/2;
    radius_points = linspace(0,cyl_radius,10);
    % Cylinder outline
    Xcyl = zeros(1,size(angle,2)*size(length_points,2));
    Ycyl = zeros(1,size(angle,2)*size(length_points,2));
    Zcyl = zeros(1,size(angle,2)*size(length_points,2));
    for i=1:1:size(angle,2)
        for j=1:1:size(length_points,2)
            Xcyl((i-1)*size(length_points,2)+j) = cyl_radius*cos(angle(i));
            Ycyl((i-1)*size(length_points,2)+j) = length_points(j) + focal_length;
            Zcyl((i-1)*size(length_points,2)+j) = cyl_radius*sin(angle(i));
        end
    end
    % Cylinder ends
    Xcylface = zeros(1,size(angle,2)*size(radius_points,2)*2);
    Ycylface = zeros(1,size(angle,2)*size(radius_points,2)*2);
    Zcylface = zeros(1,size(angle,2)*size(radius_points,2)*2);
    for i=1:1:size(angle,2)
        for j=1:1:size(radius_points,2)
            Xcylface((i-1)*size(radius_points,2)+j) = radius_points(j)*cos(angle(i));
            Ycylface((i-1)*size(radius_points,2)+j) = focal_length;
            Zcylface((i-1)*size(radius_points,2)+j) = radius_points(j)*sin(angle(i));
            Xcylface((i-1)*size(radius_points,2)+j+size(angle,2)*size(radius_points,2)) = radius_points(j)*cos(angle(i));
            Ycylface((i-1)*size(radius_points,2)+j+size(angle,2)*size(radius_points,2)) = cyl_length + focal_length;
            Zcylface((i-1)*size(radius_points,2)+j+size(angle,2)*size(radius_points,2)) = radius_points(j)*sin(angle(i));
        end
    end
    % Solar panels
    panel_long = linspace(cyl_radius,cyl_radius+3.15,20);
    panel_short = linspace(-1.524/2,1.524/2,10);
    [Xpanel,Ypanel,Zpanel] = meshgrid(panel_long,focal_length,panel_short);
    panel_points = [Xpanel(:) Ypanel(:) Zpanel(:)];
    Xpanel = panel_points(:,1)';
    Ypanel = panel_points(:,2)';
    Zpanel = panel_points(:,3)';
    % Concatenate sections
    X = [Xcyl Xcylface Xpanel -Xpanel]+hdisp;
    Y = [Ycyl Ycylface Ypanel Ypanel]+dist_from_camera;
    Z = [Zcyl Zcylface Zpanel Zpanel]+vdisp;
    % Plot
    if plot_in > 0
        figure; plot3(X,Y,Z,'.'); xlabel('x'); ylabel('y'); zlabel('z');
    end
end