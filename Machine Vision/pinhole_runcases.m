
%% Documentation
% Camera Pinhole Projection
% Abhiram Krishnan
% Space 583 | W18
% SMART RSD

%% Inputs
point_cloud             = 0;                                        % 0 for Cygnus standard
%dist_from_camera_cases  = 50:3:400;                                 % [m]
dist_from_camera_cases  = 1:1:50;                              % [m]
focal_length_cases      = 0.035;                                    % [m]
%fov_cases               = 5:2.5:150;                                % [deg]
fov_cases               = 60:1:150;                                   % [deg]
aspect_ratio            = 16/9;                                     % []
%vertical_pixels         = [720 1080 1440 1800 2160];                % [pix]
vertical_pixels         = [1080];                % [pix]
%resolutions             = {'720p'; '1080p'; '1440p'; '1880p'; '4K'};% [str]
resolutions             = {'1080p'};% [str]
save_plot               = 0;                                        % 0 for no save, 1 for save

%% Run cases
for focal_length=focal_length_cases
    percentage_u = zeros(length(dist_from_camera_cases),length(fov_cases));
    fits = zeros(length(dist_from_camera_cases),length(fov_cases));
    percentage_w = zeros(length(dist_from_camera_cases),length(fov_cases));
    for dist_from_camera=1:1:length(dist_from_camera_cases)
        for fov=1:1:length(fov_cases)
            [percentage_u(dist_from_camera,fov),percentage_w(dist_from_camera,fov),fits(dist_from_camera,fov)]...
                = pinhole(point_cloud,dist_from_camera,0,0,dist_from_camera_cases(dist_from_camera),...
                fov_cases(fov),aspect_ratio,0);
        end
    end
    figure; hold on;
    for dist_from_camera=1:1:length(dist_from_camera_cases)
        for fov=1:1:length(fov_cases)
            if fits(dist_from_camera,fov) == 1
                plot(dist_from_camera_cases(dist_from_camera),fov_cases(fov),'.',...
                    'MarkerSize',18,'MarkerEdgeColor',[1-percentage_u(dist_from_camera,fov),...
                    0,percentage_u(dist_from_camera,fov)]);
            elseif fits(dist_from_camera,fov) == 0
                plot(dist_from_camera_cases(dist_from_camera),fov_cases(fov),'k.',...
                    'MarkerSize',14);
            end
        end
    end
    title('horizontal percentage of image occupied: black=exceeds, blue is more, red is less')
    xlabel('dist from camera [m]');
    ylabel('fov [deg]');
    if save_plot == 1
        saveas(gcf,'plots/percentage_img');
        saveas(gcf,'plots/percentage_img.png');
    end
    for res=1:1:length(vertical_pixels)
        figure; hold on;
        for dist_from_camera=1:1:length(dist_from_camera_cases)
            for fov=1:1:length(fov_cases)
                if fits(dist_from_camera,fov) == 1
                    pixcount_u = percentage_u(dist_from_camera,fov)*vertical_pixels(res)*aspect_ratio;
                    pixcount_w = percentage_w(dist_from_camera,fov)*vertical_pixels(res);
                    pixcount = pixcount_u;
                    if pixcount_w > pixcount_u
                        pixcount = pixcount_w;
                    end
                    if pixcount >= 100
                        plot(dist_from_camera_cases(dist_from_camera),fov_cases(fov),'b.',...
                            'MarkerSize',18);
                    else
                        plot(dist_from_camera_cases(dist_from_camera),fov_cases(fov),'r.',...
                            'MarkerSize',18);
                    end
                elseif fits(dist_from_camera,fov) == 0
                    plot(dist_from_camera_cases(dist_from_camera),fov_cases(fov),'k.',...
                        'MarkerSize',14);
                end
            end
        end
        title(sprintf('%s: blue is >=100pix, red is <100pix',resolutions{res}));
        xlabel('dist from camera [m]');
        ylabel('fov [deg]');
        if save_plot == 1
            saveas(gcf,sprintf('plots/resolution_%s',resolutions{res}));
            saveas(gcf,sprintf('plots/resolution_%s.png',resolutions{res}));
        end
    end
end
