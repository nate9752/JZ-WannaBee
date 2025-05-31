function aero = calcDragPreliminary(aircraft,atmosphere,geom,weight,aero)
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
Re_l = rho*(aero.V_cruise) / (atmosphere.mew);   % Re/l ft^-1

M = aero.V_cruise/atmosphere.a(end);

%% Geometry

components = geom.components;
if any(strcmp(components,'wing'))
    % Wings
    cw = geom.wing.meanchord;   % chord ft
    df = geom.wing.df;   % wing covered by fuselage
    Sref = geom.wing.Sref;   % reference area ft^2
    Lamw = geom.wing.Lamw;   % Lambda (capital) angle deg
    tc_w = geom.wing.tc_w;   % ratio of thickness to chord 
    Qfw = geom.wing.Qfw;   
    
    Rew = Re_l*cw;
    Cfw = 0.455 / (log10(Rew))^2.58;
    Swetw = (Sref-cw*df) * 2 * 1.02;   % wetted wing area [ft^2] 
    Z = (2-M^2)*cos(Lamw) / sqrt(1-M^2*cos(Lamw));   % sweep correction factor 
    FFw = 1 + Z*(tc_w) + 100*(tc_w)^4;   % form factor 
    
    Cdow = FFw*Cfw*Swetw*Qfw/Sref;   % parasitic drag coefficient wing
    few = Cdow * Sref;   % flat plate equivalent area
end

if any(strcmp(components,'fuselage'))
    % fuselage 
    lf = geom.fuselage.lf;   % length ft
    Df = geom.fuselage.Df;   % diameter ft
    Qff = geom.fuselage.Qff; 
    
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
    ch = geom.horztail.chord;   % chord ft
    Sh = geom.horztail.Sh;   % horizontal tail area ft^2
    Lamh = geom.horztail.Lamh;   % Lambda of horizontal tail (rad)
    tc_h = geom.horztail.Lamh;   % thickness to chord ratio horizontal tail
    Qf_htail = geom.horztail.Qf_htail;
    
    Re_htail = Re_l*cw;
    Cf_htail = 0.455 / (log10(Re_htail))^2.58;
    Swet_htail = Sh * 2 * 1.02;   % wetted wing area [ft^2] 
    Z = M^2*cos(Lamh) / sqrt(1-M^2*cos(Lamh));   % sweep correction factor 
    FF_htail = 1 + Z*(tc_h) + 100*(tc_h)^4;   % form factor 
    
    Cdo_htail = FF_htail*Cf_htail*Swet_htail*Qf_htail/Sref;   % parasitic drag coefficient
    feh = Cdo_htail * Sref;   % flat plate equivalent area
end

if any(strcmp(components,'verttail'))
    % vertical tail
    cv = geom.verttail.chord;   % chord ft
    Sv = geom.verttail.Sv;   % vertical tail area ft^2
    Lamv = geom.verttail.Lamv;   % Lambda of vertical tail (rad)
    tc_v = geom.verttail.tc_v;   % thickness to chord ratio vertical tail
    Qf_vtail = geom.verttail.Qf_vtail;
    
    Re_vtail = Re_l*cv;
    Cf_vtail = 0.455 / (log10(Re_vtail))^2.58;
    Swet_vtail = Sv * 2 * 1.02;   % wetted wing area [ft^2] 
    Z = M^2*cos(Lamv) / sqrt(1-M^2*cos(Lamv));   % sweep correction factor 
    FF_vtail = 1 + Z*(tc_v) + 100*(tc_v)^4;   % form factor 
    
    Cdo_vtail = FF_vtail*Cf_vtail*Swet_vtail*Qf_vtail/Sref;   % parasitic drag coefficient
    fev = Cdo_vtail * Sref;   % flat plate equivalent area
end

aero.wing.Cdo = Cdow;
aero.fuselage.Cdo = Cdof;
aero.horztail.Cdo = Cdo_htail;
aero.verttail.Cdo = Cdo_vtail;



%% Parasitic Drag

Cdo = 0;
for i = 1:length(components)
    Cdo = Cdo + aero.(string(components(i))).Cdo;
end

Cdo_leakexcres = 0.08*Cdo;   % 8% of Cdo is excressence and leak drag
Cdo = Cdo + Cdo_leakexcres;


%% Induced Drag 
V_cruise = aero.V_cruise;

V = V_cruise;
q = 1/2 * V.^2 * atmosphere.rho(end);
Cl = weight.gross ./ (q*geom.wing.Sref);


% Oswald Efficiency Factor
% e = 0.70;   % lower historical bound  
% e = 0.85;   % upper historical bound 
% e = 0.98 * (1-Df/b);   % Analytical Estimate
e = 0.74;   % lower historical bound

Cdi = Cl.^2 ./ (pi*e*aircraft.wingAR);   % induced drag (drag due to lift)



%% Compressability Drag - For our case Cdw = 0

Cdc = 0;   % not flying fast enough 


%% Total Drag Coefficient and Drag

Cd = Cdo + Cdi + Cdc;   % total coefficient of drag
% D = Cd*q*geom.wing.Sref;   % total drag [lbf]


%% Display Outputs to User

fprintf('\n-------Preliminary Drag Estimations-------\n');
fprintf('\nParasitic Drag (Cdo) = %.5f\n',Cdo);
fprintf('Induced Drag at Cruise(Cdi) = %.5f\n',Cdi);
fprintf('Compressability Drag (Cdc) = %.5f\n',Cdc);
fprintf('Total Cd = %.5f\n',Cd);
% fprintf('Total Drag at Cruise = %.5f [lbf]\n\n\n',D);



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
aero.Cdo = Cdo;
aero.Cdi = Cdi;
aero.Cdc = Cdc;
aero.Cd = Cd;


aero.wing.fe = few;
aero.fuselage.fe = fef;
aero.horztail.fe = feh;
aero.verttail.fe = fev;


end