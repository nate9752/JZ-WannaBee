function plotGeom(aircraft)
% plotGeom(aircraft)
%
%   - This function will take in aircraft geometry data and plot different
%     views of the aircraft. I plan on doing this in 2D space, but maybe
%     later I could iterate and change this to 3D.
%   - Current version doesn't take into account taper ratios of wing or 
%     tails, assumes both have taper ratio of 1 (rectangular).
%
%   ** Currently this code supports a 2D view of the aircraft. Future
%   iterations can support a 3D model 
%
%% Unpackage Aircraft Geometry

b = aircraft.geom.wing.b;
c = aircraft.geom.wing.meanchord;
nose2LE = aircraft.geom.wing.nose2LE;
lf = aircraft.geom.fuselage.lf;
r_fuselage = aircraft.geom.fuselage.diam_fuselage / 2;
c_ht = aircraft.geom.horztail.chord;
b_ht = aircraft.geom.horztail.span;
c_vt = aircraft.geom.verttail.chord;
b_vt = aircraft.geom.verttail.span;
tc_vt = aircraft.geom.verttail.tc_vt;

% fuselage
fuselagex = [0 lf lf 0 0];
fusulagey = [-r_fuselage -r_fuselage r_fuselage r_fuselage -r_fuselage];
% fuselagez = [];


% Horizontal Tail
htLE = lf - c_ht;   % horizontal tail leading edge 
htTE = lf;
htailx = [htLE htTE htTE htLE htLE];
htaily = [-b_ht/2 -b_ht/2 b_ht/2 b_ht/2 -b_ht/2];

% Vertical Tail
vtLE = htLE;
vtTE = htLE + c_vt;
t_vt = tc_vt * c_vt;   % thickness vertical tail
vtailx = [vtLE vtTE vtTE vtLE vtLE];
vtaily = [-t_vt -t_vt t_vt t_vt -t_vt];


aircraftGeomPlot = figure();

% Plot Wing
% wingAirfoil = c * readmatrix('naca2412.dat');
LE = nose2LE;
TE = nose2LE + c;
hold on; grid on; axis equal;
wingx = [LE TE TE LE LE];
wingy = [-b/2 -b/2 b/2 b/2 -b/2];

% Plot Fusulage

plot(fuselagex,fusulagey,'k');
plot(wingx, wingy,'r');
plot(htailx,htaily,'b');
plot(vtailx,vtaily,'m');

title('Preliminary Aircraft Geometry');
xlabel('x [ft]'); ylabel('y [ft]'); zlabel('z [ft]');

aircraft.plot = aircraftGeomPlot;

end