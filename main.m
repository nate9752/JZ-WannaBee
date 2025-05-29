% JZ WannaBee
%
%   Authors: Nate Carey, Noe Castellanos
%
%   This code will serve as the center of our aircraft sizing caluclations,
%   as well as our general performance analysis and trade studies. This 
%   code draws inspiration from JZ-X, JetZero's in house aircraft sizing
%   tool. 
%
%   TO DO: 
%      - Input basic mission parameters section
%      - Add aircraft inputs sections (load geometries, relevent sizing
%      parameters, information from requirements, etc.).
%      - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all; 

%% Aircraft Geometry Selection 

aircraft_input = "RCTB_V1";   % first RC tube and wing project, Version 1


%% Propulsion Selection 

% Motor Selection
motor_input = "generic_motor";

% Propeller Selection
propeller_input = "generic_propeller";

% ESC Selection 
ESC_input = "generic_ESC";

% Servo Selection 
servo_input = "generic_servo";

% Battery Seleciton 
battery_input = "generic_battery";

% Miscellaneous Selection 



%% Mission Selection 

mission_input = "generic_mission";



%% Load Aircraft Inputs



%% Load CFD Data 



%% Simulations

