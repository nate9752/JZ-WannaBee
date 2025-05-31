function  aircraft = calcBatteryWeightFraction(aircraft,engine,mission)
%weightEstimation 
%   This code will develop an energy map of the mission and use this to
%   size the weight of the aircraft and the weight of the battery. 

fprintf('\n--------Weight Fraction Estimations--------\n\n')

% general unpackaging
gamma = aircraft.gamma;
V_cruise = aircraft.V_cruise;
V_climb = aircraft.V_climb;
h_cruise = mission.cruise_alt;
LD = aircraft.LD;
rhob = engine.rhob;
eta_p = engine.eta_p;
eta_m = engine.eta_m;
straight = mission.straight;
turnradius = mission.turnradius; 
numTurns = mission.numLaps;

% Energy consumption in level flight (Wb/W) 
straight_distance = straight * numTurns * 2;   % three laps, two straightaways
t_cruise = straight_distance / V_cruise;
fprintf('Time in cruise: %.2f seconds.\n',t_cruise);
WBlf_W = 1.356*V_cruise*t_cruise / (eta_p*eta_m*LD*rhob);

% Energy consumption turning flight (Wb/W)
t_turning = numTurns*2*pi*turnradius / V_cruise; 
fprintf('Time in turns: %.2f seconds.\n',t_turning);
WBtu_W = 1.356 * V_cruise * t_turning / (LD*eta_p*eta_m*rhob); 

% Energy consumption in climbing flight (Wb/W)
V_up = sind(gamma)*V_climb;
t_climb = h_cruise/V_up;   % seconds 
fprintf('Time in climb: %.2f seconds.\n\n',t_climb);
WBcl_W = 1.356*V_climb*t_climb / (eta_p*eta_m*rhob) *...
                                 (cosd(gamma)/LD + sind(gamma));

% Energy consumption warmup and takeoff (Wb/W)
WBto_W = 0.002;   % general assumption from class
% WBwu_W = 745.7*t_takeoff / (eta_m*rhob*WP);   % dont have inverse of power loading at this stage
WBwu_W = 10*WBto_W;   % general relationship from class 

% Energy consumption (Wb/W)
WB_W = WBlf_W + WBtu_W + WBcl_W + WBto_W + WBwu_W;
% WB_W = 4.2 * WB_W;   % 4.2 max volatage discharge 
% WB_W = 2 * WB_W;

fprintf('Weight Fraction Buildup: \n');
fprintf('1/W * [WB = WBto + WBwu + WBcl + WBlf + WBtu]\n');
fprintf('%.4f + %.4f + %.4f + %.4f + %.4f = %.4f\n\n',WBto_W,WBwu_W,WBcl_W,WBlf_W,WBtu_W,WB_W);

aircraft.WB_W = WB_W;

end

