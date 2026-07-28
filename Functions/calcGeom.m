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

geom = aircraft.geom;

%% Wing 

if aircraft.geom.wing.sections == 2
    lam_w1 = geom.wing.section(1).taper;   % taper of section 1
    y_w1 = geom.wing.section(1).spanpct * b/2;   % span of section 1

    lam_w2 = geom.wing.section(2).taper;   % taper of section 2
    y_w2 = y_w1 + geom.wing.section(2).spanpct * b/2;   % span of section 2

    cr = (Sref/2) / (.5*(1+lam_w1)*y_w1 + 0.5*(lam_w1+lam_w1*lam_w2)*y_w2);   % root chord station 0

    c1 = lam_w1*cr;   % chord station 1
    c2 = lam_w2*c1;   % chord station 2

    aircraft.geom.wing.c = [cr c1 c2];
    aircraft.geom.wing.y = [0 y_w1 y_w2];

end



%% Fuselage Sizing

a_fus = aircraft.geom.fuselage.a_fus;
C_fus = aircraft.geom.fuselage.C_fus;

l_fuselage_homebuilt = a_fus*gross^C_fus;   % Raymer Fuselage Length
l_fuselage = l_fuselage_homebuilt;




%% Horizontal Tail Sizing - Raymer Chapter 6

ARht = 0.5 * AR;

Cht = 0.6;   % average for horizontal tail coefficient
Lh = 0.6*l_fuselage;   % length from 1/4c wing to 1/4c tail
Sht = Cht*cw*Sref/Lh;   % area of horizontal tail
bh = sqrt(Sht * ARht);   % span horizontal tail
ch = Sht / bh;   % mean chord of horizontal tail

if aircraft.geom.horztail.sections == 1
    lam_ht1 = geom.horztail.section(1).taper;
    y_ht1 = geom.horztail.section(1).spanpct * bh/2;

    ch_r = 2*Sht / (bh*(1+lam_ht1));   % root chord horizontal tail
    ch_t = lam_ht1*ch_r;   % tip chord horizontal tail 

    aircraft.geom.horztail.c = [ch_r ch_t];
    aircraft.geom.horztail.y = [0 y_ht1];
end



%% Vertical Tail Sizing - Raymer Chapter 6

ARvt = 1.5;   % aspect ratio vertical tail [1.3 2]
Cvt = 0.04;   % average vertical tail coefficient
Lv = 0.6*l_fuselage;   % length from 1/4c wing to 1/4t
Svt = Cvt*b*Sref/Lv;   % area of vertical tail
bv = sqrt(Svt * ARvt);   % span vertical tail
cv = Svt / bv;   % mean chord vertical tail

if aircraft.geom.verttail.sections == 1
    lam_vt1 = geom.verttail.section(1).taper;
    y_vt1 = geom.verttail.section(1).spanpct * bv;

    cv_r = 2*Svt / (bv*(1+lam_vt1));   % root chord horizontal tail
    cv_t = lam_vt1*cv_r;   % tip chord horizontal tail 

    aircraft.geom.verttail.c = [cv_r cv_t];
    aircraft.geom.verttail.y = [0 y_vt1] + aircraft.geom.verttail.offset;
end



%% Control Surface Sizing - Raymer Chapter 6

aileron_span = 0.35 * b;
aileron_chord = 0.25 * cw;
elevator_span = .9 * bh;
elevator_chord = 0.325 * ch;
rudder_span = 0.90 * bv;
rudder_chord = 0.30 * cv;

nose2LE = l_fuselage - (Lh + 3*ch/4 + cw/4);



%% Packaging

% wing
aircraft.geom.wing.nose2LE = nose2LE;
% aircraft.geom.wing.wingVolume = WingVolume;


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
aircraft.geom.horztail.Cht = Cht;


% vertical tail
aircraft.geom.verttail.Sv = Svt;
aircraft.geom.verttail.chord = cv;
aircraft.geom.verttail.rootchord = cv_r;
aircraft.geom.verttail.tipchord = cv_t;
aircraft.geom.verttail.span = bv;
aircraft.geom.verttail.AR = ARvt;
aircraft.geom.verttail.Lv = Lv;
aircraft.geom.verttail.Cvt = Cvt;


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
fprintf('Fuselage Length %.2f ft, Length Nose to Leading Edge %.2f\n\n',l_fuselage,nose2LE);



%% Call to plotGeom

plotGeom(aircraft);


end