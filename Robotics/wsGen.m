%{

wsGen.m
Generate plot of possible workspace

%}

clear 
clc

% Arm Parameters
jointrad1 = 0.1/2;
jointrad2 = 0.1/2;
link1 = 0.25;
link2 = 0.45;
link3 = 0.4;
gripperBaseD = 0.045; % base of gripper diameter
gripperLength = 0.068; % length of first gripper finger
num_links = 5;

% Kinematic Paramters
link1Length = 0.1/2 + 0.13;%link1 + 0.1/2 + 0.13;
link2Length = link2 + jointrad1*2;
link3Length = link3 - jointrad1 + jointrad2;
link4Length = jointrad2*2;
link5Length = gripperBaseD + gripperLength + 0.12 + jointrad2;

% Base
maxBaseAngle = 180;
minBaseAngle = -179;
baseVecLength = length(minBaseAngle:maxBaseAngle);
baseinc = 40;

% Shoulder
maxShoulderAngle = 224;
minShoulderAngle = -45;
shoulderVecLength = length(minShoulderAngle:maxShoulderAngle);

% Elbow
maxElbowAngle = 75;
minElbowAngle = -74;
elbowVecLength = length(minElbowAngle:maxElbowAngle);

% Wrist 1
maxWrist1Angle = 90;
minWrist1Angle = -89;
wrist1VecLength = length(minWrist1Angle:maxWrist1Angle);

% Wrist 2
maxWrist2Angle = 90;
minWrist2Angle = -89;
wrist2VecLength = length(minWrist2Angle:maxWrist2Angle);

% Initialize data
inc = 40;
totalLength = baseVecLength/baseinc + shoulderVecLength/inc + elbowVecLength/inc + wrist1VecLength/inc + wrist2VecLength/inc;
coords = zeros(ceil(totalLength), 3);
count = 1;

% Implement forward kinematics
for i = minBaseAngle:baseinc:maxBaseAngle
%for i = 0
    for j = minShoulderAngle:inc:maxShoulderAngle
        for k = minElbowAngle:inc:maxElbowAngle
            for m = minWrist1Angle:inc:maxWrist1Angle
                for n = minWrist2Angle:inc:maxWrist2Angle
                    jointAngles = [i, j, k, m, n];

                    % DH Table entries (a, al (deg), d, th (deg))
                    dh = [0, 90, link1Length, jointAngles(1);
                        link2Length, 0, 0, jointAngles(2);
                        link3Length, 0, 0, jointAngles(3);
                        link4Length, 90, 0, jointAngles(4)
                        link5Length, 0, 0, jointAngles(5)];

                    coords(count, :) = fk(dh, num_links);
                    count = count + 1;
                end
            end
        end
    end
end

% Plot Results
upperLength = link2Length + link3Length + link4Length + link5Length;

figure(1)
hold on
grid on
scatter3(coords(:, 1), coords(:, 2), coords(:, 3))
plot3([0,0,upperLength], [0,0,0], [0,link1Length,link1Length], 'linewidth', 2)
axis([-1.5 1.5 -1.5 1.5 -1 2])
set(gca,'fontsize',14)
hold off
