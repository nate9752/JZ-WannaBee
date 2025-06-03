function plotGeom(aircraft)
% plotGeom(aircraft)
%
%   - This function will take in aircraft geometry data and plot different
%     views of the aircraft. I plan on doing this in 2D space, but maybe
%     later I could iterate and change this to 3D.
%   - Current version doesn't take into account taper ratios of wing or 
%     tails, assumes both have taper ratio of 1 (rectangular).
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
htaily = [-b_ht -b_ht b_ht b_ht -b_ht];

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
% foils = [-b -b/2 b/2 b];
% wingx = []; wingy = []; wingz = [];
% for i = 1:length(foils)
%     wingy = [wingy linspace(foils(i),foils(i),length(wingAirfoil(:,1)))];
%     wingx = [wingx; wingAirfoil(:,1)];
%     wingz = [wingz; wingAirfoil(:,2)];
% end
% plot3(wingAirfoil(:,1),linspace(b,b,length(wingAirfoil(:,1))),wingAirfoil(:,2),'r');
hold on; grid on; axis equal;
% 
% plot3(wingAirfoil(:,1),linspace(b/2,b/2,length(wingAirfoil(:,1))),wingAirfoil(:,2),'r');
% plot3(wingAirfoil(:,1),linspace(-b/2,-b/2,length(wingAirfoil(:,1))),wingAirfoil(:,2),'r');
% plot3(wingAirfoil(:,1),linspace(-b,-b,length(wingAirfoil(:,1))),wingAirfoil(:,2),'r');
% plot3([LE LE],[0 0],[0 0]);
% foil1 = 
wingx = [LE TE TE LE LE];
wingy = [-b -b b b -b];

% plot3(wingx,wingy',wingz,'r');

% Plot Fusulage

plot(fuselagex,fusulagey,'k');
plot(wingx, wingy,'r');
plot(htailx,htaily,'b');
plot(vtailx,vtaily,'m');

title('Preliminary Aircraft Geometry');
xlabel('x [ft]'); ylabel('y [ft]'); zlabel('z [ft]');

aircraft.plot = aircraftGeomPlot;

end