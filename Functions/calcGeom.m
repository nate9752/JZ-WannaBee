function [aircraft,geom] = calcGeom(aircraft,geom)
% calcGeom 
%   
%   - This function will size various geometric features of the aircraft,
%   including fuselage length, tails, and control surfaces. Many parameters 
%   come from Raymer
%%%

gross = aircraft.gross;
cw = geom.wing.meanchord;
S = geom.wing.Sref;
b = aircraft.b;
AR = aircraft.wingAR;

% Wing 
% Nose to LE wing is 40% of fuselage
lam = 0.7;   % milt taper ratio , [0.5 0.7]
cr = 2*S / (b*(1+lam));
ct = lam*cr;


% Fuselage Sizing
l_fuselage_homebuilt = 3.5*gross^0.23;   % Homebuilt - composite, length fuselage
% l_fuselage_general = 4.37*gross^0.23;   % general aviation single engine length fuselage
% l_fuselage = 1/2 * (l_fuselage_general + l_fuselage_homebuilt) * 1.5;
l_fuselage = 0.75 * l_fuselage_homebuilt;   % scaling factor bc storage requirement

% Horizontal Tail Sizing
taper_ht = 0.6;    % taper ratio horizontal tail [0.6 1]
ARht = 0.5 * AR;

Cht = 0.6;   % average for horizontal tail coefficient
Lh = 0.6*l_fuselage;   % length from 1/4c wing to 1/4t
Sht = Cht*cw*S/Lh;   % area of horizontal tail

bh = sqrt(Sht * ARht);   % span horizontal tail
ch = Sht / bh;   % mean chord of horizontal tail
ch_r = 2*Sht / (bh*(1+taper_ht));   % root chord horizontal tail
ch_t = taper_ht*ch_r;   % tip chord horizontal tail 


% Vertical Tail Sizing
taper_vt = 0.65;   % taper ratio vertical tail [0.6 1]
ARvt = 1.5;   % aspect ratio vertical tail [1.3 2]
Cvt = 0.04;   % average vertical tail coefficient
Lv = 0.6*l_fuselage;   % length from 1/4c wing to 1/4t
Svt = Cvt*b*S/Lv;   % area of vertical tail

bv = sqrt(Svt * ARvt);   % span vertical tail
cv = Svt / bv;   % chord vertical tail
cv_r = 2*Svt / (bv*(1+taper_vt));   % root chord vertical tail
cv_t = taper_vt*cv_r;   % tip chord vertical tail 


% Control Surface Sizing 
aileron_span = 0.35 * b;   % one half on each wing
aileron_chord = 0.25 * cw;
elevator_span = .925 * bh;
elevator_chord = 0.325 * ch;
rudder_span = 0.90 * bv;
rudder_chord = 0.30 * cv;

nose2LE = l_fuselage - (Lh + 3*ch/4 + cw/4);


%% Packaging

% wing
geom.wing.taper = lam;
geom.wing.cr = cr;
geom.wing.ct = ct;
geom.wing.nose2LE = nose2LE;

% fuselage
geom.fuselage.lf = l_fuselage;

% horizontal tail
geom.horztail.Sh = Sht;
geom.horztail.chord = ch;
geom.horztail.taper_ratio = taper_ht;
geom.horztail.rootchord = ch_r;
geom.horztail.tipchord = ch_t;
geom.horztail.span = bh;
geom.horztail.AR = ARht;
geom.horztail.Lh = Lh;
geom.horztail.Vht = Cht;


% vertical tail
geom.verttail.Sv = Svt;
geom.verttail.chord = cv;
geom.verttail.taper_ratio = taper_vt;
geom.verttail.rootchord = cv_r;
geom.verttail.tipchord = cv_t;
geom.verttail.span = bv;
geom.verttail.AR = ARvt;
geom.verttail.Lv = Lv;
geom.verttail.Vvt = Cvt;


geom.control.aileron.span = aileron_span;
geom.control.aileron.chord = aileron_chord;
geom.control.elevator.span = elevator_span;
geom.control.elevator.chord = elevator_chord;
geom.control.rudder.span = rudder_span;
geom.control.rudder.chord = rudder_chord;



%% Report Outputs
fprintf('\n\n-------Geom Sizing-------\n\n');
fprintf('Wing Span %.2f ft, Area %.2f ft^2, Chord %.2f ft\n',b,S,S/b);
fprintf('Horizontal Tail Span %.2f ft, Area %.2f ft^2, Chord %.2f ft\n',bh,Sht,ch);
fprintf('Vertical Tail Span %.2f ft, Area %.2f ft^2, Chord %.2f ft\n',bv,Svt,cv);
fprintf('Length c/4 wing to c/4 tail %.2f ft\n',Lv);
fprintf('Fuselage Length %.2f ft\n\n',l_fuselage);


end