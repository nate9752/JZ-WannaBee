function aircraft = calcGeom(aircraft)
% aircraft = calcGeom(aircraft) 
%   
%   - This function will size various geometric features of the aircraft,
%   including fuselage length, tails, and control surfaces. Many parameters 
%   and equations come from Raymer.
%%%

gross = aircraft.weight.gross;
cw = aircraft.geom.wing.meanchord;
Sref = aircraft.geom.wing.Sref;
b = aircraft.geom.wing.b;
AR = aircraft.geom.wing.AR;
lam_ht = aircraft.geom.horztail.lam_ht;
lam_vt = aircraft.geom.verttail.lam_vt;
lam = aircraft.geom.wing.lam;

% Wing 
% Nose to LE wing is 40% of fuselage
cr = 2*Sref / (b*(1+lam));
ct = lam*cr;


% Fuselage Sizing
l_fuselage_homebuilt = 3.5*gross^0.23;   % Homebuilt - composite, length fuselage
% l_fuselage_general = 4.37*gross^0.23;   % general aviation single engine length fuselage
% l_fuselage = 1/2 * (l_fuselage_general + l_fuselage_homebuilt) * 1.5;
% l_fuselage = 0.75 * l_fuselage_homebuilt;   % scaling factor bc storage requirement (senior design)
l_fuselage = l_fuselage_homebuilt;   % converts to inches

% Horizontal Tail Sizing
ARht = 0.5 * AR;

Cht = 0.6;   % average for horizontal tail coefficient
Lh = 0.6*l_fuselage;   % length from 1/4c wing to 1/4t
Sht = Cht*cw*Sref/Lh;   % area of horizontal tail

bh = sqrt(Sht * ARht);   % span horizontal tail
ch = Sht / bh;   % mean chord of horizontal tail
ch_r = 2*Sht / (bh*(1+lam_ht));   % root chord horizontal tail
ch_t = lam_ht*ch_r;   % tip chord horizontal tail 


% Vertical Tail Sizing
ARvt = 1.5;   % aspect ratio vertical tail [1.3 2]
Cvt = 0.04;   % average vertical tail coefficient
Lv = 0.6*l_fuselage;   % length from 1/4c wing to 1/4t
Svt = Cvt*b*Sref/Lv;   % area of vertical tail

bv = sqrt(Svt * ARvt);   % span vertical tail
cv = Svt / bv;   % chord vertical tail
cv_r = 2*Svt / (bv*(1+lam_vt));   % root chord vertical tail
cv_t = lam_vt*cv_r;   % tip chord vertical tail 


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
aircraft.geom.wing.taper = lam;
aircraft.geom.wing.cr = cr;
aircraft.geom.wing.ct = ct;
aircraft.geom.wing.nose2LE = nose2LE;

% fuselage
aircraft.geom.fuselage.lf = l_fuselage;

% horizontal tail
aircraft.geom.horztail.Sh = Sht;
aircraft.geom.horztail.chord = ch;
aircraft.geom.horztail.rootchord = ch_r;
aircraft.geom.horztail.tipchord = ch_t;
aircraft.geom.horztail.span = bh;
aircraft.geom.horztail.AR = ARht;
aircraft.geom.horztail.Lh = Lh;
aircraft.geom.horztail.Vht = Cht;


% vertical tail
aircraft.geom.verttail.Sv = Svt;
aircraft.geom.verttail.chord = cv;
aircraft.geom.verttail.rootchord = cv_r;
aircraft.geom.verttail.tipchord = cv_t;
aircraft.geom.verttail.span = bv;
aircraft.geom.verttail.AR = ARvt;
aircraft.geom.verttail.Lv = Lv;
aircraft.geom.verttail.Vvt = Cvt;


% Control Surfaces 
aircraft.geom.control.aileron.span = aileron_span;
aircraft.geom.control.aileron.chord = aileron_chord;
aircraft.geom.control.elevator.span = elevator_span;
aircraft.geom.control.elevator.chord = elevator_chord;
aircraft.geom.control.rudder.span = rudder_span;
aircraft.geom.control.rudder.chord = rudder_chord;



%% Report Outputs
fprintf('\n\n-------Geom Sizing-------\n');
fprintf('Wing Span %.2f [ft], Area %.2f [ft^2], Chord %.2f [ft]\n',b,Sref,Sref/b);
fprintf('Horizontal Tail Span %.2f [ft], Area %.2f [ft]^2, Chord %.2f [ft]\n',bh,Sht,ch);
fprintf('Vertical Tail Span %.2f [ft], Area %.2f [ft]^2, Chord %.2f [ft]\n',bv,Svt,cv);
fprintf('Length c/4 wing to c/4 tail %.2f ft\n',Lv);
fprintf('Fuselage Length %.2f ft\n\n',l_fuselage);


end