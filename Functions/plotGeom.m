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

geom = aircraft.geom;

figure;
hold on; axis equal; grid on; axis tight;


%% Wing Geometry

y = geom.wing.y;
c = geom.wing.c;
nStations = length(y);
xLE = zeros(1,nStations);
xLE(1) = geom.wing.nose2LE;
w_offset = aircraft.geom.wing.offset;

for i = 1:nStations-1
    sweep = geom.wing.section(i).sweep;
    dy = y(i+1) - y(i);  
    xLE(i+1) = xLE(i) + dy * tand(sweep);
end
xTE = xLE + c;


for i = 1:nStations
    statAF = geom.wing.AF.dat{1};
    xaf = statAF(:,1);
    zaf = statAF(:,2);

    X(:,i) = xLE(i) + xaf*c(i);
    Y(:,i) = y(i)*ones(size(xaf));
    Z(:,i) = w_offset + zaf*c(i);

    plot3(X,Y,Z,'k','LineWidth',1.3,'HandleVisibility','off');
    plot3(X,-Y,Z,'k','LineWidth',1.3,'HandleVisibility','off');
end

surf(X,Y,Z,'FaceColor',[0.7 0.7 0.9],'EdgeColor','none','FaceAlpha',0.5,'DisplayName','Wing')
surf(X,-Y,Z,'FaceColor',[0.7 0.7 0.9],'EdgeColor','none','FaceAlpha',0.5,'HandleVisibility','off');

xlabel('X (ft)'); ylabel('Y (ft)'); zlabel('Z (ft)');


%% Horizontal Tail Geometry

y = geom.horztail.y;
c = geom.horztail.c;
nStations = length(y);
xLE = zeros(1,nStations);
xLE(1) = geom.wing.nose2LE + geom.horztail.Lh;

for i = 1:nStations-1
    sweep = geom.horztail.section(i).sweep;
    dy = y(i+1) - y(i);  
    xLE(i+1) = xLE(i) + dy * tand(sweep);
end
xTE = xLE + c;


clear X Y Z;
for i = 1:nStations
    statAF = geom.horztail.AF.dat{1};
    xaf = statAF(:,1);
    zaf = statAF(:,2);

    X(:,i) = xLE(i) + xaf*c(i);
    Y(:,i) = y(i)*ones(size(xaf));
    Z(:,i) = zaf*c(i);

    plot3(X,Y,Z,'k','LineWidth',1.3,'HandleVisibility','off');
    plot3(X,-Y,Z,'k','LineWidth',1.3,'HandleVisibility','off');
end

surf(X,Y,Z,'FaceColor','r','EdgeColor','none','FaceAlpha',0.5,'DisplayName','Horizontal Tail')
surf(X,-Y,Z,'FaceColor','r','EdgeColor','none','FaceAlpha',0.5,'HandleVisibility','off');


%% Vertical Tail

z = geom.verttail.y;
c = geom.verttail.c;
nStations = length(z);
xLE = zeros(1,nStations);
xLE(1) = geom.wing.nose2LE + geom.verttail.Lv;

for i = 1:nStations-1
    sweep = geom.verttail.section(i).sweep;
    dz = z(i+1) - z(i);  
    xLE(i+1) = xLE(i) + dz * tand(sweep);
end
xTE = xLE + c;


clear X Y Z;
for i = 1:nStations
    statAF = geom.verttail.AF.dat{1};
    xaf = statAF(:,1);
    yaf = statAF(:,2);

    X(:,i) = xLE(i) + xaf*c(i);
    Y(:,i) = yaf*c(i);
    Z(:,i) = z(i)*ones(size(xaf));

    plot3(X,Y,Z,'k','LineWidth',1.3,'HandleVisibility','off');
    plot3(X,-Y,Z,'k','LineWidth',1.3,'HandleVisibility','off');
end

surf(X,Y,Z,'FaceColor','m','EdgeColor','none','FaceAlpha',0.5,'DisplayName','Vertical Tail')
surf(X,-Y,Z,'FaceColor','m','EdgeColor','none','FaceAlpha',0.5,'HandleVisibility','off');



%% Tail Block
% Conn


%% Fuselage

lf = geom.fuselage.lf;
fuse_w = geom.fuselage.diam_fuselage;
xf = [0 lf lf 0];
yf = fuse_w/2 * [1 1 -1 -1];
fill(xf,yf,'k','FaceAlpha',0.2);

xlabel('x (ft)'); ylabel('y (ft)');
title('Aircraft Planform');
legend('show');


end


% b = aircraft.geom.wing.b;
% c = aircraft.geom.wing.meanchord;
% nose2LE = aircraft.geom.wing.nose2LE;
% lf = aircraft.geom.fuselage.lf;
% r_fuselage = aircraft.geom.fuselage.diam_fuselage / 2;
% c_ht = aircraft.geom.horztail.chord;
% b_ht = aircraft.geom.horztail.span;
% c_vt = aircraft.geom.verttail.chord;
% b_vt = aircraft.geom.verttail.span;
% tc_vt = aircraft.geom.verttail.tc;
% 
% % fuselage
% fuselagex = [0 lf lf 0 0];
% fusulagey = [-r_fuselage -r_fuselage r_fuselage r_fuselage -r_fuselage];
% % fuselagez = [];
% 
% 
% % Horizontal Tail
% htLE = lf - c_ht;   % horizontal tail leading edge 
% htTE = lf;
% htailx = [htLE htTE htTE htLE htLE];
% htaily = [-b_ht/2 -b_ht/2 b_ht/2 b_ht/2 -b_ht/2];
% 
% % Vertical Tail
% vtLE = htLE;
% vtTE = htLE + c_vt;
% t_vt = tc_vt * c_vt;   % thickness vertical tail
% vtailx = [vtLE vtTE vtTE vtLE vtLE];
% vtaily = [-t_vt -t_vt t_vt t_vt -t_vt];
% 
% 
% aircraftGeomPlot = figure();
% 
% % Plot Wing
% % wingAirfoil = c * readmatrix('naca2412.dat');
% LE = nose2LE;
% TE = nose2LE + c;
% hold on; grid on; axis equal;
% wingx = [LE TE TE LE LE];
% wingy = [-b/2 -b/2 b/2 b/2 -b/2];
% 
% % Plot Fusulage
% 
% plot(fuselagex,fusulagey,'k');
% plot(wingx, wingy,'r');
% plot(htailx,htaily,'b');
% plot(vtailx,vtaily,'m');
% 
% title('Preliminary Aircraft Geometry');
% xlabel('x [ft]'); ylabel('y [ft]'); zlabel('z [ft]');
% 
% aircraft.plot = aircraftGeomPlot;
