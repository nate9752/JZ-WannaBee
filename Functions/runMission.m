function mission = runMission(aircraft,mission,atmosphere)
% [aircraft,mission] = runMission(aircraft,mission)
%
%   - This function will input the finalized aircraft structure and mission
%   specifics and simulate the flight of the aircraft. 
%
%
%%%%


%% Takeoff

mission = calcTakeoff(aircraft,mission,atmosphere);


%% Climb 

mission = calcClimb(aircraft,mission,atmosphere);


%% Cruise 


%% Decent


%% Landing


%% Mission Summary


end