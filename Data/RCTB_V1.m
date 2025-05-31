% Aircraft Input file 
% Remote Controlled Tube and Wing - Version 1
%    - NACA 2412 wings, NACA 0012 for tails.
%    - Mid wing, foam fuselage and wings, small wingspan, Standard horizontal
%     and vertical stabilizer.
%    - No payload.
%

aircraft = struct();

%% Desired Flight Conditions

V_cruise = 50;   % cruise speed [ft/s]
V_climb = 40;   % climb speed [ft/s]
gamma = 15;   % climb angle [deg]
h = 100;   % cruise altitude [ft]


%% Engine and Aircraft Performance
rho_b = 2.37*10^5;   % energy density of lipo battery [J/lbf]
eta_p = 0.6;   % propeller efficiency 
eta_m = 0.6;   % motor efficiency 
LD = 12;   % estimated cruise L/D
e = 0.8;   % Oswalds efficiency factor
Cdo = 0.025;   % preliminary parasitic drag estimate - change later 


%% Preliminary Drag Estimates (No CFD) 
% can estimate from prior projects or other areas

components = {'wings', 'fuselage','horztail','verttail'};

% wings 
b = 5;   % wingspan [ft]
tc_w = 0.12;   % thickness to chord NACA 0012

% fuselage 
diam_fuselage = 0.50;   % diameter fuselage [ft]

% horizontal tail - CHANGE AFTER TAILS SIZING 
tc_ht = 0.12;   % thickness to chord ratio horizontal tail

% vertical tail - CHANGE AFTER TAIL SIZING
tc_vt = 0.12;   % thickness to chord ratio vertical tail


%% Weights (when concept is more developed)

payload = 0;   % [lbf]


%% Packaging 

aircraft.name = 'RCTB_V1';

% Estimates; all terms that were estimated at a preliminary level
aircraft.estimates.V_cruise = V_cruise;
aircraft.estimates.V_climb = V_climb;
aircraft.estimates.gamma = gamma;
aircraft.estimates.cruiseAlt = h;
aircraft.estimates.LD = LD;
aircraft.estimates.e = e;
aircraft.estimates.wingspan = b;
aircraft.estimates.rho_b = rho_b;
aircraft.estimates.eta_p = eta_p;
aircraft.estimates.eta_m = eta_m;

% engine 
aircraft.engine.rho_b = rho_b;
aircraft.engine.eta_p = eta_p;
aircraft.engine.eta_m = eta_m;

% aero
aircraft.aero.V_cruise = V_cruise;
aircraft.aero.V_climb = V_climb;
aircraft.aero.gamma = gamma;
aircraft.aero.cruiseAlt = h;
aircraft.aero.LD = LD;
aircraft.aero.e = e;

% geom
aircraft.geom.components = components;

aircraft.geom.wing.b = b;
aircraft.geom.wing.tc_w = tc_w;

aircraft.geom.fuselage.diam_fuselage = diam_fuselage;

aircraft.geom.horztail.tc_h = tc_ht;

aircraft.geom.verttail.tc_v = tc_vt;

% weight 
aircraft.weight.payload = payload;
