% JZ WannaBee
%
%   Authors: Nate Carey, Noe Castellanos
%
%   This code will serve as the center of our aircraft sizing caluclations,
%   as well as our general performance analysis and trade studies. This 
%   code draws inspiration from JZ-X, JetZero's in house aircraft sizing
%   tool. I also have taken much of my own code from a previous project,
%   design build fly, in which me and a group of engineers build an RC
%   aircraft in my undergrad. 
%
%   TO DO: 
%      - Read sizing textbooks to create a more optimized weight and
%      geometry sizing process. 
%      - Start inporting XFLR5 data + optimize drag predictor function. 
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

mission_input = "fiveMinuteFlight.m";



%% Load Aircraft Inputs

inputs = loadInputs(aircraft_input, battery_input, ESC_input, motor_input,...
                    propeller_input, servo_input, mission_input);

mission = loadMission(inputs);
aircraft = loadAircraft(inputs);
aircraft = loadEngine(inputs, aircraft);
aircraft = loadControls(inputs, aircraft);
aircraft = loadAero(inputs, aircraft);


%% Load Atmosphere

atmosphere = buildAtmosphere;


%% General Sizing 

% This section first calculates a battery weight fraction for the aircraft,
% then finds the intersection along some historical data -> 
% Wpl + Wbatt = Wgross - Wempty
%
% This data is then used in our constraint matrix to find W/S and W/P
% Then, some prelimary geometry, drag calculations, and structural 
% calculations are preformed. 

aircraft = calcBatteryWeightFraction(aircraft,mission);

aircraft = plotWeightIntersect(aircraft);
% 
% [aircraft,geom] = plotConstraintAnalysis(aircraft,engine,aero,atmosphere,geom);
% 
% [aircraft,geom] = calcGeom(aircraft,geom);
% aero = calcDragPreliminary(aircraft,atmosphere,geom,weight,aero);
% plotVnDiagram(atmosphere,aircraft);

