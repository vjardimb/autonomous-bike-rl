clear all
clc
addpath(genpath(pwd))
%% Bike Parameters

% 1. Base parameters
w = 1.034;                                                                                              % wheel base [m]
c = 0.09;                                                                                               % trail [m]
lambda = 18.0;                                                                                          % steering head angle [deg]

g = 9.81;                                                                                               % gravity [m/s^2]
hat_n = [0;0;1];                                                                                        % plane normal

% 2. Rear Wheel
radiusRW = 0.32;                                                                                        % radius [m]
lengthRW = 0.03;                                                                                        % thickness [m]
massRW = 2;                                                                                             % mass[kg]
rhoRW = massRW / (pi * radiusRW^2 * lengthRW);                                                          % density [kg/m^3]
momentInertiaRW = [0.25*massRW*radiusRW^2 0.5*massRW*radiusRW^2 0.25*massRW*radiusRW^2];                % Moment of inertia [kg-m^2]

% 3. Rear Frame
cylRF = 0.05;                                                                                           % radius [m]
mB = 15;                                                                                                % mass [kg]

% 4. Front Frame                   
cylFF = 0.05;                                                                                           % radius [m]
mH = 5;                                                                                                 % mass [kg]

% 5. Front wheeel
radiusFW = 0.325;                                                                                       % radius [m]
lengthFW = 0.03;                                                                                        % thickness [m]
massFW = 2;                                                                                             % mass [kg]
rhoFW = massFW / (pi * radiusFW^2 * lengthFW);
momentInertiaFW = [0.25*massFW*radiusFW^2 0.5*massFW*radiusFW^2 0.25*massFW*radiusFW^2];                % Moment of inertia [kg-m^2]

% 5. Derived geometrical parameters of frames   (!! Not to be modified)
% 5.1 Base geomtery (not to be modified!!)
frontHinge = 0.15 * w;
lengthFF = frontHinge / (sind(lambda));
adj = lengthFF * cosd(lambda);
lengthRF = sqrt((w-frontHinge)^2 + adj^2);
angleRF =  atan(adj / (w-frontHinge));
angleRF = angleRF * (180/pi);
steeringAngle = (90 - lambda);
angleFF = (lambda);

% 6. Moment of Inertias of rear and front frame
momentInertiaB = [9.2 11 2.8];                                                                          % Rear Frame Moment of inertia [kg-m^2}
ProductsofInertiaB = [0 2.4 0];                                                                         % Rear Frame products of inertia [kg-m^2]

momentInertiaH = [0.05892 0.06 0.00708];                                                                % Front frame Moment of inertia [kg-m^2]
ProductsofInertiaH = [0 -0.00756 0];                                                                    % Front frame products of inertia [kg-m^2]

CenterOfMassB_in_I = [0.35;0;0.7];                                                                      % Input Center of Mass here in global reference frame(Rear Frame)
% (Not to be modified!!)
CenterOfMassB_in_Z = [CenterOfMassB_in_I(1);0;CenterOfMassB_in_I(3) - radiusRW];
transMy = [cosd(90 - angleRF) 0 sind(90 - angleRF); 0 1 0; -sind(90 - angleRF) 0 cosd(90 - angleRF)];
d_Z1_in_I = transpose(transMy) * [lengthRF/2*cosd(angleRF);0;lengthRF/2*sind(angleRF)];
CenterOfMassB_in_B = transpose(transMy) * CenterOfMassB_in_Z;
CenterOfMassB_in_B = CenterOfMassB_in_B - d_Z1_in_I;
% (------------------------------------------------------------------------------------)

CenterOfMassH_in_I = [0.95;0;0.7];                                                                      % Input Center of Mass here in global reference frame(Front Frame)
% (Not to be modified!!)
CenterOfMassH_in_Z = [CenterOfMassH_in_I(1)-w;0;CenterOfMassH_in_I(3) - radiusFW];
transMy = [cosd(angleFF) 0 sind(angleFF); 0 1 0; -sind(angleFF) 0 cosd(angleFF)];
transMy = transpose(transMy);
d_Z2_in_I = transpose(transMy) * [-lengthFF/2*sind(angleFF);0;lengthFF/2*cosd(angleFF)];
CenterOfMassH_in_B = transpose(transMy) * CenterOfMassH_in_Z;
CenterOfMassH_in_B = CenterOfMassH_in_B - d_Z2_in_I;
% (------------------------------------------------------------------------------------)
%% Plane parameters

xPla = 3e3;                                                                                             % x plane length [m]
yPla = 3e3;                                                                                             % y plane length [m]
zPla = 0.01;                                                                                            % z plane depth [m]

% Grid parameters
Grid.clr = [1 1 1]*1;
Grid.numSqrs = 150;
Grid.lineWidth = 0.02;
Grid.box_h = (xPla-(Grid.lineWidth*(Grid.numSqrs+1)))/Grid.numSqrs;
Grid.box_l = (xPla-(Grid.lineWidth*(1+1)))/1;
Grid.extr_data = Extr_Data_Mesh(yPla,yPla,Grid.numSqrs,1,Grid.box_h,Grid.box_l);
%% Tire parameters

% 1. Contact parameters

% 1. Rear Wheel
k_contact_RW = 1e5;                                                                                     % Vertical stiffness [N/m]
b_contact_RW = 2e3;                                                                                     % Damping [N-s/m]

% 2. Front wheel
k_contact_FW = 1e5;                                                                                     % Vertical stiffness [N/m]
b_contact_FW = 2e3;                                                                                     % Damping [N-s/m]

% 2. Stiffness properties

C_F_alpha = 1e3;                                                                                        % Longitudinal stiffness [N/m]
C_F_kappa = 1e3;                                                                                        % Lateral stiffness [N/m]
CM_phi = 0.3;                                                                                           % Self-Aligining stiffness Coeff [N-m/(rad/m)]

% 3. tire relaxation length
sigma = 0.12;                                                                                           % [m]
% 4. propogation speed relaxation
epsilon = 1e-2;                                                                                         % Avoid division by zero (Not required for tires with relaxation!!)

%% Camera Setup
frontCameraX = -1.75;
frontCameraZ = 0.35;

followerCameraX = 7.5;
followerCameraZ = 3;

isoCameraX = -2;
isoCameraY = -1.0;
isoCameraZ = -2*w;
isoCameraAimX = (1/2)*w + 0.75;

IsoCameraDamping = 30;
IsoCameraStiffness = 5;
Filtering1Dto3DConnection = 0.1;

topViewX = -4.5*w;
topViewY = 0*w;
topViewZ = 1*w;

%% Actuation Limits

max_rw_t = 20.0;                                                                                       % Maximum rear wheel torque [N*m]
max_steer_t = 5.0;                                                                                     % Maximum Steering torque [N*m]

%% isDone triggers

max_lean = 60;                                                                                         % Maximum Lean Angle [deg]
max_cte = 5;                                                                                           % Maximum Cross Track Error (lateral distance to the disired path) [m]
max_bike_x = xPla;                                                                                     % Maximum X Coordinate [m]
max_bike_y = yPla;                                                                                     % Maximum Y Coordinate [m]
max_yaw = 70;                                                                                          % Maximum Orientation Error [deg]
max_steering = 60;                                                                                     % Maximum Steering Angle [deg]

%% Simulation parameters

damp = 0;                                                                                                % Friction in wheel bearings [N*m/(rad/s)]

% Joint IC's (Rear Wheel)
psi0 = 0;                                                                                                % Initial orientation angle [deg]

% IC's on velocity (Rear Wheel)
v0 = 0;                                                                                                 % Initial forward velocity [m/s]
Dtheta0 = v0 / radiusRW;                                                                                % Initial angular velocity [rad/s] (Required to maintian joint constraints)

% IC's on velocity (Front Wheel)
v0_FW = v0;                                                                                              % Initial forward velocity [m/s]
Dtheta0_FW = v0 / radiusFW;                                                                              % Initial angular velocity [rad/s] (Required to maintian joint constraints)

% IC steering angle
delta0 = 0;                                                                                              % Initial steering angle [deg]

% Initial bike position (Rear Wheel)
x0 = 0;                                                                                                  % Initial x coordinate [m]
y0 = 0;                                                                                                  % Initial y coordinate [m]                                                                                           % reference bike speed [m/s]

%% Path Generation Parameters

path_n_points = 50;
path_max_dim = 100;
cvx_hull_n_points = 20;

%% Speed Reference Generator Parameters

min_ref_v = 3;
max_ref_v = 7;

%% Reinforcement Learning (RL) parameters
Ts = 0.025;                                                                                              % Agent sample time
Tf = 10.0;                                                                                               % Simulation end time
trainingMaxEpisodes = 50;
DiscountFactor = 0.99;
MiniBatchSize = 256;
