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
%   To use this code, first an aircraft data file must be made, starting
%   with version 1. This includes basic performance parameters and some
%   known design criteria. Then, once the preliminary sizing is complete,
%   an XFLR5 model or CAD can be made to place the known weights in the
%   aircraft, at which point the aircraft data file can be iterated to
%   version two containing these weights and their locations. 
%
%
%   TO DO: 
%      - plotGeom function that gives a rough 3D view of aircraft and all
%      relevent control surfaces. Can update aircraft model to V2 once
%      XFLR5 data is completed.
%      - Preliminary drag buildup function.
%      - Start inporting XFLR5 data. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;
timer = tic();

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
% This data is then used in our constraint matrix to find W/S and W/P

aircraft = calcBatteryWeightFraction(aircraft,mission);
aircraft = plotWeightIntersect(aircraft);
aircraft = plotConstraintAnalysis(aircraft,atmosphere);


% Next, the propulsion system will be sized using some preliminary
% equations, iteration is encouraged as this will only pick ideal
% properties based on historical data.

aircraft = sizeProp(aircraft);


% Then, some prelimary geometry, drag calculations, and structural 
% calculations are preformed. 

aircraft = calcGeom(aircraft);
aircraft = calcDragPreliminary(aircraft,atmosphere);

% plotVnDiagram(atmosphere,aircraft);
% plotGeom(aircraft);






%% Output 


fprintf('\n\nTotal Simulation Time: %.3f\n',toc(timer));
clear timer;