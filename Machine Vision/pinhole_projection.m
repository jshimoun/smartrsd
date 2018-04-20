
%% Documentation
% Apply a pinhole projection to a set of points
% Abhiram Krishnan
% Space 583 | W18
% SMART RSD

%% Function
function [u,w] = pinhole_projection(X,Y,Z,focal_length)

% Define camera projection matrix
C = [focal_length,  0,  0;
     0,             1,  0;
     0,             0,  focal_length];

u = zeros(size(X));
v = zeros(size(Y));
w = zeros(size(Z));

for i=1:1:size(X,2)
    projected = C*[X(i);Y(i);Z(i)];
    u(i) = projected(1)/Y(i);
    v(i) = projected(2)/Y(i);
    w(i) = projected(3)/Y(i);
end

end