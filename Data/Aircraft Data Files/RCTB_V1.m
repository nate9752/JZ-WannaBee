% Aircraft Input file 
% Remote Controlled Tube and Wing - Version 1
%    - NACA 2412 wings, NACA 0012 for tails.
%    - Mid wing, foam fuselage and wings, small wingspan, Standard horizontal
%     and vertical stabilizer.
%    - No payload.
%

aircraft = struct();
aircraft.name = 'RCTB_V1';

%% Build Material (can fill out later once a build process is selected)

fuselageMaterial = 'PLA';   % Foam, Wood, PLA
fuselageDensity = 77.4107;   % [lbf/ft^3]
aeroMaterial = 'PLA';   % Foam, Wood, PLA
aeroDensity = 77.4107;   % [lbf/ft^3]

% Volumes - for now, I am assuming a 4% infil. As the CAD develops further
% I will update these values. 
fuselageVolume = 0.07*0.10;   % [ft^3]
wingVolume = 0.19*0.10;   % [ft^3]
horztailVolume = 0.016*0.10;   % [ft^3]
verttailVolume = 0.002*0.10;   % [ft^3]



%% Desired Flight Conditions

V_cruise = 60;   % cruise speed [ft/s]
V_climb = 45;   % climb speed [ft/s]
V_stall = 30;   % stall speed [ft/s] <- USC 2024 DBF report



%% Aircraft Performance

Clmax = 1.4;   % maximum lift coefficient
AR = 6;   % Desired Aspect Ratio

% New Raymer Estimates
Swet_Sref = 3.8;   % Flying Wing 2.1
                   % Sailplane 2.35
                   % Single Prop 3.8
                   % Twin Boom 4.2
                   % Jet Transport 6.3
                   % Supersonic Fighter 4.6

kLD = 11;          % Non Retractable Landing Gear Prop a/c 9
                   % Retractable Landing Gear Prop a/c 11
                   % High AR a/c 13
                   % Military Jets 14
                   % Sailplanes / Gliders 15
                   % Airliners 15.5


% LD Approximation
LDmax = kLD*sqrt(AR/Swet_Sref);   % Max Efficiency
LDmaxend = 0.866 * LDmax;         % Max Endurance


% Oswald Efficiency Estimation 
e = 1.78 * (1 - 0.045 * AR^0.68) - 0.64;   % No LE Sweep
% e = 4.61 * (1 - 0.045 * AR^0.68) * cosd(Lam_w)^0.15 - 3.1;   % >30 deg LE Sweep
% Interpolate between the two for 0 < Sweep < 30 


% Cdmin Estimate
Cdmin = 0.03;        % High AR skinny wing 0.01 - 0.015
                     % Cessna "big wing" 0.028 - 0.03
                     % long big wing 0.04


Clmin = 0;           % Symmmetric Airfoil 0
                     % Cambered Airfoil 0.1 - 0.2
                     % Cambered high lift 0.4 - 0.45


% Assemble Drag Polar
k1 = 1/(pi*e*AR);   % Quadratic Lift Term
k2 = -2*k1*Clmin;   % Linear Lift Term
Cdo = Cdmin + k1*Clmin;   % Zero Lift Drag Coeff

Cl = linspace(-0.2, 1.5);
Cd = Cdo + k1*Cl.^2 + k2*Cl;



%% Preliminary Geom Estimates

components = {'wing', 'fuselage','horztail','verttail'};

%%% Wings %%%
wingsections = 2;
b = 3;   % wingspan [in]
camber_w = 0.24;   % camber location for NACA 2412
tc_w = 0.12;   % thickness to chord NACA 2412
df = 0;   % wing covered by fuselage; 0 b/c high wing config
Qfw = 1;   % high wing config interference value
lambda_w = 1;   % wing taper ratio
Lam_w = 0 * pi/180;   % sweep angle (capital lambda) wing

% --- Section 1 --- %
lambda_w1 = 1;   % taper ratio section 1
spanpct_w1 = 0.5;   % 50% of span is contained in section 1
Lam_w1 = 0 * pi/180;   % sweep angle (capital lambda) wing
theta_w1 = 0;   % twist (deg) section 1, not used for now

% --- Section 2 --- %
lambda_w2 = 1;   % taper ratio section 2
spanpct_w2 = 1 - spanpct_w1;
Lam_w2 = Lam_w1;   % sweep angle, same as previous section
theta_w2 = 0;   % twist (deg) section 2, not used for now


%%%% Fuselage %%% 
diam_fuselage = 0.25;   % diameter fuselage [ft]
Qff = 1;   % interference factor fuselage


%%%% Horizontal Tail %%%
htsections = 1;
tc_ht = 0.12;   % thickness to chord ratio horizontal tail
lambda_ht = 1;   % horizontal tail taper ratio
Qf_ht = 1;   % interference factor horizontal tail
Lam_ht = 0 * pi/180;    % sweep angle (capital lambda) horizontal tail

% --- Section 1 --- %
Lam_ht1 = 0 * pi/180;    % sweep angle (capital lambda) horizontal tail
lambda_ht1 = 1;   % horizontal tail taper ratio
spanpct_ht1 = 1;
theta_ht1 = 0;


%%% Vertical Tail %%%
vtsections = 1;
tc_vt = 0.12;   % thickness to chord ratio vertical tail
lambda_vt = 1;   % vertical tail taper ratio
Qf_vt = 1;   % interference factor vertical tail
Lam_vt = 0 * pi/180;   % sweep angle (capital lambda) vertical tail

% --- Section 1 --- %
Lam_vt1 = 0 * pi/180;    % sweep angle (capital lambda) horizontal tail
lambda_vt1 = 1;   % horizontal tail taper ratio
spanpct_vt1 = 1;
theta_vt1 = 0;


%%%% Landing Gear %%% 
landingGearFlag = 0;



%% Engine

rho_b = 150 * 3600 * 0.737 / 2.20;   % energy density of lipo battery [Wh/kg --> lbf*ft/lbm]
eta_p = 0.75;   % propeller efficiency 
eta_m = 0.85;   % motor efficiency 
eta_esc = 0.98;   % ESC efficiency
K = 0.8;   % Fraction of Battery Discharged

% Power Performance Level --> 3D performance = 150
%                             Aerobatic/High Speed = 125
%                             Sport Flying = 110
%                             Basic Trainer = 85
%                             Lightly Loaded Model = 60
PPL = 100;



%% Weights (Can fill out once a CAD model is developed)

payload = 0;   % [lbf]
fuselageWeight = fuselageVolume * fuselageDensity;
wingWeight = wingVolume * aeroDensity;
horztailWeight = horztailVolume * aeroDensity;
verttailWeight = verttailVolume * aeroDensity;



%% Packaging 

% Estimates; all terms that were estimated at a preliminary level
aircraft.estimates.V_cruise = V_cruise;
aircraft.estimates.V_climb = V_climb;
aircraft.estimates.V_stall = V_stall;
aircraft.estimates.LDmax = LDmax;
aircraft.estimates.LDmaxend = LDmaxend;
aircraft.estimates.Clmax = Clmax;
aircraft.estimates.Cdo = Cdo;
aircraft.estimates.Cdmin = Cdmin;
aircraft.estimates.e = e;
aircraft.estimates.AR = AR;
aircraft.estimates.wingspan = b;
aircraft.estimates.rho_b = rho_b;
aircraft.estimates.eta_p = eta_p;
aircraft.estimates.eta_m = eta_m;
aircraft.estimates.eta_esc = eta_esc;
aircraft.estimates.kbatt = K;


% build material 
aircraft.build.bodyMaterial = fuselageMaterial;
aircraft.build.aeroMaterial = aeroMaterial;

% engine 
aircraft.engine.rho_b = rho_b;
aircraft.engine.eta_p = eta_p;
aircraft.engine.eta_m = eta_m;
aircraft.engine.eta_ESC = eta_esc;
aircraft.engine.kbatt = K;
aircraft.engine.PPL = PPL;

% aero
aircraft.aero.V_cruise = V_cruise;
aircraft.aero.V_climb = V_climb;
aircraft.aero.V_stall = V_stall;
aircraft.aero.LDmax = LDmax;
aircraft.aero.LDmaxend = LDmaxend;
aircraft.aero.Clmax = Clmax;
aircraft.aero.Cdo = Cdo;
aircraft.aero.Cdmin = Cdmin;
aircraft.aero.e = e;
aircraft.aero.AR = AR;

% geom
aircraft.geom.components = components;

% geom.wing
aircraft.geom.wing.sections = wingsections;
aircraft.geom.wing.b = b;
aircraft.geom.wing.tc = tc_w;
aircraft.geom.wing.camber = camber_w;
aircraft.geom.wing.df = df;
aircraft.geom.wing.Qfw = Qfw;
aircraft.geom.wing.lam = lambda_w;
aircraft.geom.wing.Lam = Lam_w;
aircraft.geom.wing.sec1.lam = lambda_w1;
aircraft.geom.wing.sec1.Lam = Lam_w1;
aircraft.geom.wing.sec1.spanpct = spanpct_w1;
aircraft.geom.wing.sec1.theta = theta_w1;
aircraft.geom.wing.sec2.lam = lambda_w2;
aircraft.geom.wing.sec2.Lam = Lam_w2;
aircraft.geom.wing.sec2.spanpct = spanpct_w2;
aircraft.geom.wing.sec2.theta = theta_w2;

% geom.fuselage
aircraft.geom.fuselage.diam_fuselage = diam_fuselage;
aircraft.geom.fuselage.Qff = Qff;

% geom.horztail
aircraft.geom.horztail.sections = htsections;
aircraft.geom.horztail.tc = tc_ht;
aircraft.geom.horztail.lam = lambda_ht;
aircraft.geom.horztail.Qf = Qf_ht;
aircraft.geom.horztail.Lam = Lam_ht;
aircraft.geom.horztail.sec1.lambda = lambda_ht1;
aircraft.geom.horztail.sec1.Lam = Lam_ht1;
aircraft.geom.horztail.sec1.spanpct = spanpct_ht1;
aircraft.geom.horztail.sec1.theta = theta_ht1;

% geom.verttail
aircraft.geom.verttail.sections = vtsections;
aircraft.geom.verttail.tc = tc_vt;
aircraft.geom.verttail.lam = lambda_vt;
aircraft.geom.verttail.Qf = Qf_vt;
aircraft.geom.verttail.Lam = Lam_vt;
aircraft.geom.verttail.sec1.lambda = lambda_vt1;
aircraft.geom.verttail.sec1.Lam = Lam_vt1;
aircraft.geom.verttail.sec1.spanpct = spanpct_vt1;
aircraft.geom.verttail.sec1.theta = theta_vt1;

% geom.landingGear
aircraft.geom.landingGearFlag = landingGearFlag;


% weight 
aircraft.weight.payload = payload;
aircraft.weight.sum.fuselage = fuselageWeight;
aircraft.weight.sum.wing = wingWeight;
aircraft.weight.sum.horztail = horztailWeight;
aircraft.weight.sum.verttail = verttailWeight;



%% Plotting and Output

fprintf('------Aircraft Input File Preliminary Calcs------\n');
fprintf('Vcruise = %.3f ft/s\n',V_cruise);
fprintf('Vstall = %.3f ft/s\n',V_stall);
fprintf('Drag Polar: Cd = %.3f + %.3fCL^2 + %.3fCL',Cdo,k1,k2);

