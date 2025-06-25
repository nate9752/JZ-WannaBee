% JZ WannaBee
%
%   Authors: Nate Carey
%
%   This code will serve as the center of our aircraft sizing caluclations,
%   as well as our general performance analysis and trade studies. This 
%   code draws inspiration from JZ-X, JetZero's in house aircraft sizing
%   tool. I also have taken much of my own code from a previous project,
%   design build fly, in which me and a group of engineers build an RC
%   aircraft in my undergrad. 
%
%   To use this code:
%      1. An aircraft data file must be made, starting
%      with version 1. This includes basic performance parameters and some
%      known design criteria. 
%      2. With initial sizing complete, the user can then size the 
%      propulsion system using eCalc to select specific instramentation. 
%      Then, XFLR5 or open VSP can be used to optimize the aerodynamic 
%      design.
%      3. A CAD model can be made to aid the manufacturing process and to
%      finalize the weights and locations of all systems. Along the way,
%      different versions of the aircraft data file can be made with flags
%      in place to only run the functions that are required at the current
%      stage of the design. 
%
%
%   TO DO: 
%      - plotGeom function that gives a rough 3D view of aircraft and all
%      relevent control surfaces. Can update aircraft model to V2 once
%      XFLR5 data is completed.
%      - Preliminary drag buildup function.
%      - Start inporting XFLR5 data. 
%      - CAD for more accurate weights analysis. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;
timer = tic();

cd(fileparts(mfilename("fullpath")))
addpath(genpath(pwd));


%% Aircraft Geometry Selection 

aircraft_input = "RCTB_V1.m";   % first RC tube and wing project, Version 1



%% Propulsion Selection 

% Battery Seleciton 
battery_input = "LiPo 2200mAh 45-60C";

% ESC Selection 
ESC_input = "max 50A";

% Motor Selection
motor_input = "Cobra C-2808/16 (1780)";

% Propeller Selection
propeller_input = "APC Electric E 8x5";

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