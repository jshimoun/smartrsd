
%% Documentation
% Animate approach to DSG with docked Cygnus-Std
% Abhiram Krishnan
% Space 583 | W18
% SMART RSD

%% Generate view
%[percentage_u,percentage_w,fits] = pinhole(2,50,-2,0,0.035,45,16/9,3);

filename = 'approach_vv_offset2.gif';

start = 100;
inc = -1;
count = (start-0)/abs(inc);
offset = linspace(10,0,count+1);
q = 0;
for i=start:inc:start+count*inc
    q = q+1;
    %[percentage_u,percentage_w,fits] = pinhole(2,i,-2,0,0.035,45,16/9,3);
    %figure(3);
    [percentage_u,percentage_w,fits] = pinhole(0,i,offset(q),offset(q),0.035,45,16/9,3);
    figure(2);
    frame = getframe;
    close all;
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if i==start
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append');
    end
end
