
%% Calculates how much the visiting vehicle impedes the navigation cameras
% Space 583 WN18
% Abhiram Krishnan

%% Geometry [mks]

r_camera            = 2.5;          % [m] dist from centerline to camera
horiz_fov           = 90*pi/180;    % [rad] horizontal field of view of camera
vert_fov            = 60*pi/180;    % [rad] vertical field of view of camera
horiz_pix           = 640;          % [pixels] horizontal resolution of camera
vert_pix            = 480;          % [pixels] vertical resolution of camera
r_vv                = 3.07/2;       % [m] radius of the visiting vehicle
cam_offset          = 0.6;          % [m] distance of the camera behind the visiting vehicle
len_vv              = 6.3;          % [m] length of the visiting vehicle

%% Calculations

cam_radial_dist = r_camera - r_vv;
vv_circle = linspace(0,2*pi);
cam_to_vv_end = cam_offset + len_vv;

idx = 0.25;
[fovx,fovy] = meshgrid(-cam_to_vv_end*tan(horiz_fov/2):idx:cam_to_vv_end*tan(horiz_fov/2),...
    r_camera-cam_to_vv_end*tan(vert_fov/2):idx:r_camera+cam_to_vv_end*tan(vert_fov/2));
intersection = zeros(size(fovx,1),size(fovy,2));
distances = zeros(size(fovx,1),size(fovy,2));
maxdist = 0;
for i=1:1:size(fovx,1)
    for j=1:1:size(fovy,2)
        close all;
        centerline_vec = [-cam_to_vv_end,0,0];
        centerline_vec = centerline_vec/norm(centerline_vec);
        camline_vec = [-cam_to_vv_end,fovx(i,j),fovy(i,j)-r_camera];
        camline_vec = camline_vec/norm(camline_vec);
        crossp = cross(centerline_vec,camline_vec);
        crossp = crossp/norm(crossp);
        centerline_plane = [crossp -cam_to_vv_end*crossp(1)];
        %{
        camline_plane = [crossp ...
            crossp(1)*-cam_to_vv_end+crossp(2)*fovx(i,j)+crossp(3)*fovy(i,j)];
        dist = abs(sum(centerline_plane.*[0,0,r_camera,1])) / sqrt(sum(centerline_plane.^2));
        distances(i,j) = dist;
        if dist<r_vv && fovy(i,j)<r_camera
            intersection(i,j) = 1;
        end
        %}
        param_t = (-r_camera*crossp(3)) / (camline_vec(2)*crossp(3)-camline_vec(3)*crossp(2));
        distances(i,j) = param_t*camline_vec(1);
        if 0<param_t*camline_vec(1) && param_t*camline_vec(1)<cam_to_vv_end && sqrt((r_camera+camline_vec(2)*param_t)-(centerline_vec(2)*param_t))^2+((camline_vec(3)*param_t)-(centerline_vec(3)*param_t)^2)<r_vv
            intersection(i,j) = 1;
        end
    end
end

%% Plot

% Side view
figure(1); hold on;
title('side view')
xlabel('x [m]'); ylabel('y [m]');
plot([0,len_vv],[0,0],'k--');                                           % centerline
plot(-cam_offset,r_camera,'ro');                                        % camera
plot([0,len_vv,len_vv,0,0],[r_vv,r_vv,-r_vv,-r_vv,r_vv],'b-');          % vv
plot([len_vv,-0.6,len_vv],[r_camera+cam_to_vv_end*tan(vert_fov/2),...   % fov
    r_camera,r_camera-cam_to_vv_end*tan(vert_fov/2)],'r-');
axis tight equal

% What the camera sees
figure(2); hold on;
title('camera view')
xlabel('x [m]'); ylabel('y [m]');
plot([-cam_to_vv_end*tan(horiz_fov/2),cam_to_vv_end*tan(horiz_fov/2),...
    cam_to_vv_end*tan(horiz_fov/2),-cam_to_vv_end*tan(horiz_fov/2),...
    -cam_to_vv_end*tan(horiz_fov/2)],[r_camera-cam_to_vv_end*tan(vert_fov/2),...
    r_camera-cam_to_vv_end*tan(vert_fov/2),r_camera+cam_to_vv_end*tan(vert_fov/2),...
    r_camera+cam_to_vv_end*tan(vert_fov/2),r_camera-cam_to_vv_end*tan(vert_fov/2)],'r-');
for i=1:1:size(fovx,1)
    for j=1:1:size(fovy,2)
        if intersection(i,j) == 1
            plot(fovx(i,j),fovy(i,j),'r.');
        end
    end
end
plot(cos(vv_circle),sin(vv_circle),'b-');
axis tight equal

% This should be interesting
figure(3); hold on;
xlabel('x'); ylabel('y'); zlabel('z');
title('other camera view')
for i=1:1;size(fovx,1)
    for j=1:1:size(fovy,2)
        disp('hi')
        if intersection(i,j) == 1
            plot3([-cam_offset,len_vv],[0,fovx(i)],[r_camera,fovy(j)],'r-');
        end
    end
end
view(3);




