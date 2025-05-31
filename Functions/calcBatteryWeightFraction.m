function  aircraft = calcBatteryWeightFraction(aircraft,mission)
%weightEstimation 
%   This code will develop an energy map of the mission and use this to
%   size the weight of the aircraft and the weight of the battery. 

fprintf('\n--------Weight Fraction Estimations--------\n\n')

% general unpackaging
gamma = aircraft.aero.gamma;
V_cruise = aircraft.aero.V_cruise;
V_climb = aircraft.aero.V_climb;
cruise_alt = aircraft.aero.cruiseAlt;
LD = aircraft.aero.LD;
rho_b = aircraft.engine.rho_b;
eta_p = aircraft.engine.eta_p;
eta_m = aircraft.engine.eta_m;

cruiseDuration = mission.cruiseDuration;

% Energy consumption in level flight (Wb/W) 
fprintf('Time in cruise: %.2f seconds.\n',cruiseDuration);
WBlf_W = 1.356*V_cruise*cruiseDuration / (eta_p*eta_m*LD*rho_b);   % weight fraction level flight

% Energy consumption turning flight (Wb/W)
WBtu_W = 0;
if mission.turning.flag 
    t_turning = numTurns*2*pi*turnradius / V_cruise; 
    fprintf('Time in turns: %.2f seconds.\n',t_turning);
    WBtu_W = 1.356 * V_cruise * t_turning / (LD*eta_p*eta_m*rho_b); 
end

% Energy consumption in climbing flight (Wb/W)
V_up = sind(gamma)*V_climb;
climbDuration = cruise_alt/V_up;   % seconds 
fprintf('Time in climb: %.2f seconds.\n\n',climbDuration);
WBcl_W = 1.356*V_climb*climbDuration / (eta_p*eta_m*rho_b) *...
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

aircraft.weight.WB_W = WB_W;

end

