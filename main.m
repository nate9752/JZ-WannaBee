% Aircraft Sizing Code
%
%   Author: Nate Carey
%
%   This code will serve as the center of our aircraft sizing caluclations,
%   as well as our general performance analysis and trade studies. This 
%   code draws inspiration from JZ-X, JetZero's in house aircraft sizing
%   tool. I have taken much of my own code from a previous project,
%   design build fly, in which me and a group of engineers built an RC
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
%        relevent control surfaces.
%      - (long term) CAD for more accurate weights analysis. 
%      - (long term / not really necessary) fix calcDragPreliminary to
%        account for new section/station aircraft geom layout.
%      - Continue developing openVSP modeling. (fuselage components) 
%      - Develop cruise and descent simulation functions.
%      - Output analytical performance data based on Anderson eqns.
%      - Change / Check calcGeom   
%         - Reformat wing location sizing
%         - Reformat Tail sizing methods
%         - Reformat control surface sizing methods
%      
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;
timer = tic();

cd(fileparts(mfilename("fullpath")));
addpath(genpath(pwd));


%% Flags

flight_flag = 1;   % set to true to run a mission
openVSP_flag = 0;   % set to true to run OpenVSP simulation



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



%% Load Atmosphere

atmosphere = buildAtmosphere;   % Standard Atmosphere Structure



%% Load Aircraft Inputs

inputs = loadInputs(aircraft_input, battery_input, ESC_input, motor_input,...
                    propeller_input, servo_input, mission_input);

mission = loadMission(inputs);   % Loads Mission Details
aircraft = loadAircraft(inputs);   % Loads Aircraft Input File 
aircraft = loadEngine(inputs, aircraft);   % Loads Propulsion System



%% General Sizing 

% This section first calculates a battery weight fraction for the aircraft,
% then finds the intersection along some historical data -> 
% Wpl + Wbatt = Wgross - Wempty
% This data is then used in our constraint matrix to find W/S and W/P

aircraft = calcBatteryWeightFraction(aircraft,mission);
aircraft = plotWeightIntersect(aircraft);
aircraft = plotConstraintAnalysis(aircraft,mission,atmosphere);


% Next, the propulsion system will be sized using some preliminary
% equations, iteration is encouraged as this will only pick ideal
% properties based on historical data.

aircraft = sizeProp(aircraft);
aircraft = loadPropMap(inputs, aircraft);


% Then, some prelimary geometry, drag calculations, and structural 
% calculations are preformed. 

aircraft = calcGeom(aircraft);
% aircraft = calcDragPreliminary(aircraft,atmosphere);
% plotVnDiagram(atmosphere,aircraft);


% At this stage a CAD model can be developed and a more detailed weight 
% breakdown and systems view can be created.

aircraft = buildWeight(aircraft);



%% Run Open VSP

if openVSP_flag
    
    aircraft = runVSP(aircraft);

else

    aircraft = readVSPdata(aircraft);

end



%% Fly Standard Mission 

if flight_flag

    mission = runMission(aircraft,mission,atmosphere);

end



%% Output 

fprintf('\n\nTotal Simulation Time: %.3f\n',toc(timer));
clear timer;