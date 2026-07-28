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


Clmin = 0.1;           % Symmmetric Airfoil 0
                       % Cambered Airfoil 0.1 - 0.2
                       % Cambered high lift 0.4 - 0.45


% Assemble Drag Polar
k1 = 1/(pi*e*AR);   % Quadratic Lift Term
k2 = -2*k1*Clmin;   % Linear Lift Term
Cdo = Cdmin + k1*Clmin;   % Zero Lift Drag Coeff

Cl = linspace(-0.2, 1.5);
Cd = Cdo + k1*Cl.^2 + k2*Cl;



%% Preliminary Aero Geom Estimates

build_components = {'wing','horztail','verttail','fusblock','tailblock','bodypole'};

%%% Wings %%%
wingsections = 2;
b = 3;   % wingspan [in]
df = 0;   % wing covered by fuselage; 0 b/c high wing config
Qfw = 1;   % high wing config interference value
w_offset = 0.75/12;   % z shift in wing (ft)


% --- Station 1 --- % 
aircraft.geom.wing.AF.name{1} = 'NACA2412';
aircraft.geom.wing.AF.tc(1) = 0.12;
aircraft.geom.wing.AF.camber(1) = 0.02;
aircraft.geom.wing.AF.camberLoc(1) = 0.4;
aircraft.geom.wing.AF.dat{1} = readmatrix('naca2412.dat');


% --- Station 2 --- %
aircraft.geom.wing.AF.name{2} = 'NACA2412';
aircraft.geom.wing.AF.tc(2) = 0.12;
aircraft.geom.wing.AF.camber(2) = 0.02;
aircraft.geom.wing.AF.camberLoc(2) = 0.4;
aircraft.geom.wing.AF.dat{2} = readmatrix('naca2412.dat');


% --- Section 1 --- %
aircraft.geom.wing.section(1).taper = 1;
aircraft.geom.wing.section(1).spanpct = 0.35;
aircraft.geom.wing.section(1).sweep = 0;
aircraft.geom.wing.section(1).twist = 0;


% --- Station 3 --- %
aircraft.geom.wing.AF.name{3} = 'NACA2412';
aircraft.geom.wing.AF.tc(3) = 0.12;
aircraft.geom.wing.AF.camber(3) = 0.02;
aircraft.geom.wing.AF.camberLoc(3) = 0.4;
aircraft.geom.wing.AF.dat{3} = readmatrix('naca2412.dat');


% --- Section 2 --- %
aircraft.geom.wing.section(2).taper = .7;
aircraft.geom.wing.section(2).spanpct = 0.65;
aircraft.geom.wing.section(2).sweep = 15;
aircraft.geom.wing.section(2).twist = 0;



%%%% Fuselage %%% 
diam_fuselage = 0.25;   % diameter fuselage [ft]
Qff = 1;   % interference factor fuselage



%%%% Horizontal Tail %%%
htsections = 1;
Qf_ht = 1;   % interference factor horizontal tail


% --- Station 1 --- %
aircraft.geom.horztail.AF.name{1} = 'NACA0012';
aircraft.geom.horztail.AF.tc(1) = 0.12;
aircraft.geom.horztail.AF.camber(1) = 0;
aircraft.geom.horztail.AF.camberLoc(1) = 0;
aircraft.geom.horztail.AF.dat{1} = readmatrix('naca0012.dat');


% --- Station 2 --- %
aircraft.geom.horztail.AF.name{2} = 'NACA0012';
aircraft.geom.horztail.AF.tc(2) = 0.12;
aircraft.geom.horztail.AF.camber(2) = 0;
aircraft.geom.horztail.AF.camberLoc(2) = 0;
aircraft.geom.horztail.AF.dat{2} = readmatrix('naca0012.dat');


% --- Section 1 --- %
aircraft.geom.horztail.section(1).taper = 1;
aircraft.geom.horztail.section(1).spanpct = 1;
aircraft.geom.horztail.section(1).sweep = 0;
aircraft.geom.horztail.section(1).twist = 0;



%%% Vertical Tail %%%
vtsections = 1;
Qf_vt = 1;   % interference factor vertical tail
vt_offset = 0.75/12;   % Vertical tail offset in z direction (ft)


% --- Station 1 --- % 
aircraft.geom.verttail.AF.name = 'NACA0012';
aircraft.geom.verttail.AF.tc = 0.12;
aircraft.geom.verttail.AF.camber = 0;
aircraft.geom.verttail.AF.camberLoc = 0;
aircraft.geom.verttail.AF.dat{1} = readmatrix('naca0012.dat');


% --- Station 2 --- %
aircraft.geom.verttail.section(1).airfoil.name = 'NACA0012';
aircraft.geom.verttail.section(1).airfoil.tc = 0.12;
aircraft.geom.verttail.section(1).airfoil.camber = 0;
aircraft.geom.verttail.section(1).airfoil.camberLoc = 0;
aircraft.geom.vertail.AF.dat{2} = readmatrix('naca0012.dat');


% --- Section 1 --- %
aircraft.geom.verttail.section(1).taper = 0.65;
aircraft.geom.verttail.section(1).spanpct = 1;
aircraft.geom.verttail.section(1).sweep = 30;
aircraft.geom.verttail.section(1).twist = 0;



%%%% Landing Gear %%% 
landingGearFlag = 0;



%% Fuselage Type

% Raymer Fuselage coefficients for length = a * W^C
a_fus = 2;
C_fus = 0.4;
                    % Sailplane unpowered: a = 0.86, C =.48
                    % Sailplane powered: a = 3.68, C = 0.48
                    % Homebuilt composite: a = 3.5, C = .23
                    % General aviation single engine: a = 4.37, C = .23
                    % General aviation twin engine: a = .86, C = .42
                    % Twin_turboprop: a = .37, C = .51
                    % Flying boat: a = 1.05, C = .4
                    % Jet trainer: a = .79, C = .41
                    % Jet fighter: a = .93, C = .39
                    % Military cargo: a = .23, C = .50
                    % Jet_transport: a = .67, C = .43



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
aircraft.aero.k1 = k1;
aircraft.aero.k2 = k2;

% geom
aircraft.geom.components = build_components;

% geom.wing
aircraft.geom.wing.sections = wingsections;
aircraft.geom.wing.b = b;
aircraft.geom.wing.df = df;
aircraft.geom.wing.Qfw = Qfw;
aircraft.geom.wing.offset = w_offset;

% geom.fuselage
aircraft.geom.fuselage.diam_fuselage = diam_fuselage;
aircraft.geom.fuselage.Qff = Qff;
aircraft.geom.fuselage.a_fus = a_fus;
aircraft.geom.fuselage.C_fus = C_fus;


% geom.horztail
aircraft.geom.horztail.sections = htsections;
aircraft.geom.horztail.Qf = Qf_ht;


% geom.verttail
aircraft.geom.verttail.sections = vtsections;
aircraft.geom.verttail.Qf = Qf_vt;
aircraft.geom.verttail.offset = vt_offset;

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

