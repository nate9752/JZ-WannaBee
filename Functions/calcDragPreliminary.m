function aircraft = calcDragPreliminary(aircraft,atmosphere)
% calcDragPreliminary
%   
%   - This function is a preliminary estimate at the drag our aircraft will
%   be subjected to during flight. This code uses no CFD data, and instead
%   takes our preliminary estimates at various sizing features and uses
%   them in an in class drag buildup method. 
%
%   (Cdo + Cdi + Cdc) -> D = Cd*q*S.  
%%%


% Astmosphere
rho = atmosphere.rho(end);   % density sl/ft^3
Re_l = rho*(aircraft.aero.V_cruise) / (atmosphere.mu);   % Re/l ft^-1

M = aircraft.aero.V_cruise/atmosphere.a(end);

%% Geometry

components = aircraft.geom.components;
if any(strcmp(components,'wing'))
    % Wings
    cw = aircraft.geom.wing.meanchord;   % chord ft
    df = aircraft.geom.wing.df;   % wing covered by fuselage
    Sref = aircraft.geom.wing.Sref;   % reference area ft^2
    Lam_w = aircraft.geom.wing.Lam_w;   % Lambda (capital) angle deg
    tc_w = aircraft.geom.wing.tc_w;   % ratio of thickness to chord 
    Qfw = aircraft.geom.wing.Qfw;   
    
    Rew = Re_l*cw;
    Cfw = 0.455 / (log10(Rew))^2.58;
    Swetw = (Sref-cw*df) * 2 * 1.02;   % wetted wing area [ft^2] 
    Z = (2-M^2)*cos(Lam_w) / sqrt(1-M^2*cos(Lam_w));   % sweep correction factor 
    FFw = 1 + Z*(tc_w) + 100*(tc_w)^4;   % form factor 
    
    Cdow = FFw*Cfw*Swetw*Qfw/Sref;   % parasitic drag coefficient wing
    few = Cdow * Sref;   % flat plate equivalent area
end

if any(strcmp(components,'fuselage'))
    % fuselage 
    lf = aircraft.geom.fuselage.lf;   % length ft
    Df = aircraft.geom.fuselage.diam_fuselage;   % diameter ft
    Qff = aircraft.geom.fuselage.Qff; 
    
    Ref = Re_l * lf;
    Cff = 0.455 / (log10(Ref))^2.58;   % skin friction coefficient 
    Lamf = lf/Df;  
    Swetf = pi*Df*lf*(1-2/Lamf)^(2/3) * (1+1/Lamf^2);   % wetted area [ft^2]
    FFf = 0.9 + 5/(Lamf^1.5) + Lamf / 400;   % form factor fuselage
    
    Cdof = FFf*Qff*Swetf*Cff/Sref;   % parasitic drag coefficient fuselage
    fef = Cdof * Sref;   % flat plate area
end

if any(strcmp(components,'horztail'))
    % horizontal tail 
    ch = aircraft.geom.horztail.chord;   % chord ft
    Sh = aircraft.geom.horztail.Sh;   % horizontal tail area ft^2
    Lam_ht = aircraft.geom.horztail.Lam_ht;   % Lambda of horizontal tail (rad)
    tc_ht = aircraft.geom.horztail.tc_ht;   % thickness to chord ratio horizontal tail
    Qf_ht = aircraft.geom.horztail.Qf_ht;
    
    Re_ht = Re_l*cw;
    Cf_ht = 0.455 / (log10(Re_ht))^2.58;
    Swet_ht = Sh * 2 * 1.02;   % wetted wing area [ft^2] 
    Z = M^2*cos(Lam_ht) / sqrt(1-M^2*cos(Lam_ht));   % sweep correction factor 
    FF_ht = 1 + Z*(tc_ht) + 100*(tc_ht)^4;   % form factor 
    
    Cdo_ht = FF_ht*Cf_ht*Swet_ht*Qf_ht/Sref;   % parasitic drag coefficient
    feh = Cdo_ht * Sref;   % flat plate equivalent area
end

if any(strcmp(components,'verttail'))
    % vertical tail
    cv = aircraft.geom.verttail.chord;   % chord ft
    Sv = aircraft.geom.verttail.Sv;   % vertical tail area ft^2
    Lam_vt = aircraft.geom.verttail.Lam_vt;   % Lambda of vertical tail (rad)
    tc_vt = aircraft.geom.verttail.tc_vt;   % thickness to chord ratio vertical tail
    Qf_vt = aircraft.geom.verttail.Qf_vt;
    
    Re_vt = Re_l*cv;
    Cf_vt = 0.455 / (log10(Re_vt))^2.58;
    Swet_vt = Sv * 2 * 1.02;   % wetted wing area [ft^2] 
    Z = M^2*cos(Lam_vt) / sqrt(1-M^2*cos(Lam_vt));   % sweep correction factor 
    FF_vt = 1 + Z*(tc_vt) + 100*(tc_vt)^4;   % form factor 
    
    Cdo_vt = FF_vt*Cf_vt*Swet_vt*Qf_vt/Sref;   % parasitic drag coefficient
    fev = Cdo_vt * Sref;   % flat plate equivalent area
end

aircraft.aero.wing.Cdo = Cdow;
aircraft.aero.fuselage.Cdo = Cdof;
aircraft.aero.horztail.Cdo = Cdo_ht;
aircraft.aero.verttail.Cdo = Cdo_vt;



%% Parasitic Drag

Cdo = 0;
for i = 1:length(components)
    Cdo = Cdo + aircraft.aero.(string(components(i))).Cdo;
end

Cdo_leakexcres = 0.08*Cdo;   % 8% of Cdo is excressence and leak drag
Cdo = Cdo + Cdo_leakexcres;


%% Induced Drag 
V_cruise = aircraft.aero.V_cruise;

V = V_cruise;
q = 1/2 * V.^2 * atmosphere.rho(end);
Cl = aircraft.weight.gross ./ (q*aircraft.geom.wing.Sref);


% Oswald Efficiency Factor
% e = 0.70;   % lower historical bound  
% e = 0.85;   % upper historical bound 
% e = 0.98 * (1-Df/b);   % Analytical Estimate
e = aircraft.aero.e;

Cdi = Cl.^2 ./ (pi*e*aircraft.geom.wing.AR);   % induced drag (drag due to lift)



%% Compressability Drag - For our case Cdw = 0

Cdc = 0;   % not flying fast enough 


%% Total Drag Coefficient and Drag

Cd = Cdo + Cdi + Cdc;   % total coefficient of drag
D = Cd*q*aircraft.geom.wing.Sref;   % total drag [lbf]


%% Display Outputs to User

fprintf('\n-------Preliminary Drag Estimations-------\n');
fprintf('Parasitic Drag (Cdo) = %.5f\n',Cdo);
fprintf('Induced Drag at Cruise(Cdi) = %.5f\n',Cdi);
fprintf('Compressability Drag (Cdc) = %.5f\n',Cdc);
fprintf('Total Cd = %.5f\n',Cd);
fprintf('Total Drag at Cruise = %.5f [lbf]\n',D);



%% Packaging

% aero
% aero.Takeoff.Cdo = Cdo;
% aero.Takeoff.Cdi = Cdi(1);
% aero.Takeoff.Cdc = Cdc;
% aero.Takeoff.Cd = Cd(1);

% aero.Climb.Cdo = Cdo;
% aero.Climb.Cdi = Cdi(2);
% aero.Climb.Cdc = Cdc;
% aero.Climb.Cd = Cd(2);
% 
aircraft.aero.Cdo = Cdo;
aircraft.aero.Cdi = Cdi;
aircraft.aero.Cdc = Cdc;
aircraft.aero.Cd = Cd;

aircraft.aero.wing.fe = few;
aircraft.aero.fuselage.fe = fef;
aircraft.aero.horztail.fe = feh;
aircraft.aero.verttail.fe = fev;


end