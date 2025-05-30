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

aircraft_input = "RCTB_V1.m";   % first RC tube and wing project, Version 1


%% Propulsion Selection 

% Battery Seleciton 
battery_input = "generic_battery";

% ESC Selection 
ESC_input = "generic_ESC";

% Motor Selection
motor_input = "generic_motor";

% Propeller Selection
propeller_input = "generic_propeller";

% Servo Selection 
servo_input = "generic_servo";

% Miscellaneous Selection 



%% Mission Selection 

mission_input = "generic_mission";



%% Load Aircraft Inputs

inputs = loadInputs(aircraft_input, battery_input, ESC_input, motor_input,...
                    propeller_input, servo_input);

aircraft = loadAircraft(inputs);
aircraft = loadEngine(inputs, aircraft);
aircraft = loadControls(inputs, aircraft);
aircraft = loadAero(inputs, aircraft);


%% Load CFD Data 



%% Simulations

