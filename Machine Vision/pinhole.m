
%% Documentation
% Camera Pinhole Projection
% Abhiram Krishnan
% Space 583 | W18
% SMART RSD

%% Function
function [percentage_u,percentage_w,fits] = pinhole(point_cloud,dist_from_camera,...
                            vdist,hdist,focal_length,fov,aspect_ratio,plot_in)

X = [];
Y = [];
Z = [];

%% Point Cloud
if point_cloud == 0 % cygnus
    [X_model,Y_model,Z_model] = cygnusstd_pointcloud(dist_from_camera,vdist,hdist,focal_length,plot_in,1);
elseif point_cloud == 1 % dsg
elseif point_cloud == 2 % cygnus and dsg
    [X_cygnus,Y_cygnus,Z_cygnus] = cygnusstd_pointcloud(0,vdist,hdist,focal_length,plot_in,1);
    [X_dsg,Y_dsg,Z_dsg] = dsg_pointcloud(dist_from_camera,vdist,hdist,focal_length,plot_in);
    X_model = [X_cygnus,X_dsg];
    Y_model = [Y_cygnus,Y_dsg];
    Z_model = [Z_cygnus,Z_dsg];
elseif point_cloud == 3 % robotic arm workspace
    [X_model,Y_model,Z_model] = wsSphere(dist_from_camera,vdist,hdist,plot_in);%wsGen(dist_from_camera,vdist,hdist,plot_in);
elseif point_cloud == 4 % moon
    [X_model,Y_model,Z_model] = moon_pointcloud(dist_from_camera,vdist,hdist,focal_length,plot_in);
end

[Y_model,sort_indices] = sort(Y_model,'descend');
X_model = X_model(sort_indices);
Z_model = Z_model(sort_indices);

%% Generate FOV circle and image dimensions
angle = linspace(0,2*pi,20);
fov_radius = tan(fov/2*pi/180)*focal_length;
fov_points = [fov_radius*cos(angle); focal_length*ones(size(angle)); fov_radius*sin(angle)];
fov_imgtheta = atan2(1,aspect_ratio);
fov_imgpoints = [fov_radius*cos(fov_imgtheta)*[1,1,-1,-1,1];
                focal_length*[1,1,1,1,1];
                fov_radius*sin(fov_imgtheta)*[1,-1,-1,1,1]];

%% Apply pinhole model

% Project
[u_model,w_model] = pinhole_projection(X_model,Y_model,Z_model,focal_length);
[u_fovcirc,w_fovcirc] = pinhole_projection(fov_points(1,:),fov_points(2,:),fov_points(3,:),focal_length);
[u_fovimg,w_fovimg] = pinhole_projection(fov_imgpoints(1,:),fov_imgpoints(2,:),fov_imgpoints(3,:),focal_length);

% Plot
if plot_in > 0
    figure; hold on;
    %plot(u_model,w_model,'b.');
    for i=1:1:length(u_model)
        %fprintf('%d %d %d\n',i,u_model(i),w_model(i));
        percentage = (Y_model(i)-min(Y_model))/(max(Y_model)-min(Y_model));
        plot(u_model(i),w_model(i),'.','MarkerEdgeColor',[percentage,0,1-percentage]);
    end
    plot(u_fovcirc,w_fovcirc,'g.');
    plot(u_fovimg,w_fovimg,'g-');
    title(sprintf('s/c is %0.3fm away, %0.1fm up, %0.1fm right',dist_from_camera,vdist,hdist));
    axis equal;
    if plot_in == 3
        axis([min(u_fovimg) max(u_fovimg) min(w_fovimg) max(w_fovimg)]);
    end
end

%% Determine image statistics to return

% Does the projection fit fully in the image?
fits = 1;
min_model_u = min(u_model);
max_model_u = max(u_model);
min_model_w = min(w_model);
max_model_w = max(w_model);
min_fovimg_u = min(u_fovimg);
max_fovimg_u = max(u_fovimg);
min_fovimg_w = min(w_fovimg);
max_fovimg_w = max(w_fovimg);
if min_model_u<min_fovimg_u || min_model_w<min_fovimg_w || max_fovimg_u<max_model_u || max_fovimg_w<max_model_w
    fits = 0;
end

% What percentage of the image does the image take up?
percentage_u = (max_model_u-min_model_u)/(max_fovimg_u-min_fovimg_u);
percentage_w = (max_model_w-min_model_w)/(max_fovimg_w-min_fovimg_w);

end



