% Aircraft Input file 
% Remote Controlled Tube and Wing - Version 1
%    - NACA 2412 wings, NACA 0012 for tails.
%    - Mid wing, foam fuselage and wings, small wingspan, Standard horizontal
%     and vertical stabilizer.
%    - No payload.
%

aircraft = struct();

%% Desired Flight Conditions

V_cruise = 60;   % cruise speed [ft/s]
V_climb = 45;   % climb speed [ft/s]
V_stall = 30;   % stall speed [ft/s] <- USC 2024 DBF report
gamma = 15;   % climb angle [deg]
h = 100;   % cruise altitude [ft]



%% Aircraft Performance

LD = 12;   % estimated cruise L/D
e = 0.8;   % Oswalds efficiency factor
Cdo = 0.03;   % preliminary parasitic drag estimate - change later 
Clmax = 1.4;   % maximum lift coefficient



%% Preliminary Geom Estimates
% can estimate from prior projects or other areas

components = {'wing', 'fuselage','horztail','verttail'};

% wings 
b = 3;   % wingspan [in]
tc_w = 0.12;   % thickness to chord NACA 0012
lambda_w = 1;   % wing taper ratio
df = 0;   % wing covered by fuselage; 0 b/c high wing config
Qfw = 1;   % high wing config interference value
Lam_w = 0 * pi/180;   % sweep angle (capital lambda) wing


% fuselage 
diam_fuselage = 0.25;   % diameter fuselage [ft]
Qff = 1;   % interference factor fuselage

% horizontal tail - CHANGE AFTER TAILS SIZING 
tc_ht = 0.12;   % thickness to chord ratio horizontal tail
lambda_ht = 1;   % horizontal tail taper ratio
Qf_ht = 1;   % interference factor horizontal tail
Lam_ht = 0 * pi/180;    % sweep angle (capital lambda) horizontal tail

% vertical tail - CHANGE AFTER TAIL SIZING
tc_vt = 0.12;   % thickness to chord ratio vertical tail
lambda_vt = 1;   % vertical tail taper ratio
Qf_vt = 1;   % interference factor vertical tail
Lam_vt = 0 * pi/180;   % sweep angle (capital lambda) vertical tail



%% Engine

rho_b = 2.37*10^5;   % energy density of lipo battery [J/lbf]
eta_p = 0.6;   % propeller efficiency 
eta_m = 0.6;   % motor efficiency 

% Power Performance Level --> 3D performance = 150
%                             Aerobatic/High Speed = 125
%                             Sport Flying = 110
%                             Basic Trainer = 85
%                             Lightly Loaded Model = 60
PPL = 100;



%% Weights (when concept is more developed)

payload = 0;   % [lbf]



%% Packaging 

aircraft.name = 'RCTB_V1';

% Estimates; all terms that were estimated at a preliminary level
aircraft.estimates.V_cruise = V_cruise;
aircraft.estimates.V_climb = V_climb;
aircraft.estimates.V_stall = V_stall;
aircraft.estimates.gamma = gamma;
aircraft.estimates.cruiseAlt = h;
aircraft.estimates.LD = LD;
aircraft.estimates.Clmax = Clmax;
aircraft.estimates.Cdo = Cdo;
aircraft.estimates.e = e;
aircraft.estimates.wingspan = b;
aircraft.estimates.rho_b = rho_b;
aircraft.estimates.eta_p = eta_p;
aircraft.estimates.eta_m = eta_m;

% engine 
aircraft.engine.rho_b = rho_b;
aircraft.engine.eta_p = eta_p;
aircraft.engine.eta_m = eta_m;
aircraft.engine.PPL = PPL;

% aero
aircraft.aero.V_cruise = V_cruise;
aircraft.aero.V_climb = V_climb;
aircraft.aero.V_stall = V_stall;
aircraft.aero.gamma = gamma;
aircraft.aero.cruiseAlt = h;
aircraft.aero.LD = LD;
aircraft.aero.Clmax = Clmax;
aircraft.aero.Cdo = Cdo;
aircraft.aero.e = e;

% geom
aircraft.geom.components = components;

aircraft.geom.wing.b = b;
aircraft.geom.wing.tc_w = tc_w;
aircraft.geom.wing.lam = lambda_w;
aircraft.geom.wing.df = df;
aircraft.geom.wing.Qfw = Qfw;
aircraft.geom.wing.Lam_w = Lam_w;

aircraft.geom.fuselage.diam_fuselage = diam_fuselage;
aircraft.geom.fuselage.Qff = Qff;

aircraft.geom.horztail.tc_ht = tc_ht;
aircraft.geom.horztail.lam_ht = lambda_ht;
aircraft.geom.horztail.Qf_ht = Qf_ht;
aircraft.geom.horztail.Lam_ht = Lam_ht;

aircraft.geom.verttail.tc_vt = tc_vt;
aircraft.geom.verttail.lam_vt = lambda_vt;
aircraft.geom.verttail.Qf_vt = Qf_vt;
aircraft.geom.verttail.Lam_vt = Lam_vt;

% weight 
aircraft.weight.payload = payload;
