function aircraft = plotConstraintAnalysis(aircraft,atmosphere)
%makeConstraintAnalysis(aircraft)
%   This function will make a constraint diagram with stall, maneuvering,
%   power, and climbing constraints impossed. 
%   
%    - Changes from senior design:
%    - In senior design, I used P/W on the y axis, now from reading
%    literature I realize this should be Thrust/Weight ratio, and I can
%    then hopeully converted required T/W to power required throughout a
%    given mission, which I can then use to size my propulsion system. 

WS = linspace(0,2.5,100)';

% Unpackaging
V_stall = aircraft.aero.V_stall;   % stall speed ft/s
Clmax = aircraft.aero.Clmax;   % maximum coefficient of lift
Cdo = aircraft.aero.Cdo;   % [0.02 0.025 0.027 0.03]
LDmax = aircraft.aero.LD;   % [10 12 14 15]

eta_p = aircraft.engine.eta_p;
V_cruise = aircraft.aero.V_cruise;
V_climb = aircraft.aero.V_climb;
gamma = aircraft.aero.gamma;
e = aircraft.aero.e;


AR = 5;   % preliminary estimate
k = 1/(pi*AR*e);
Cdmin = 0.025;


% Stall Constraint - verified
constraint_stall = 1/2 * atmosphere.rho(1) * V_stall^2 * Clmax;


% Power Constraint 
% constraint_power = WS * 0.75 * 550 * eta_p ./ ...
%          (1/2 * atmosphere.rho(1) * 1.1*(Cdo) * V_cruise^3);


% Climbing Constraint
% constraint_climb = 550 * eta_p ./...
%                (V_climb * (1./(0.866.*LDmax) + sind(gamma)));
constraint_climb = sind(gamma) + sqrt(4*k*Cdmin);   % TW version of constraint


% Maneuvering Constraint
n = 3;   % 3 g turns
q = 1/2 * atmosphere.rho(end) * (V_cruise * 0.8)^2;   % 80% velocity on turn 
% constraint_maneuvering = 550 * eta_p ./...
%        (q * V_cruise * 0.8 * (Cdo./WS + k*(n/q)^2 * WS));
constraint_maneuvering = q * (Cdmin./WS + k*(n/q)^2 .* WS);   % TW version of constraint


% Cruise Contraint
constraint_cruise = q*Cdmin./WS + k/q.*WS;


% Power Constraint 
figure; 
% plot(WS,constraint_power,'color','m','DisplayName','Power Constraint',...
%                        'linewidth',2);
% label = strcat('Cdo = ',num2str(Cdo));
% text(WS(end)*0.65,constraint_power(length(WS)*0.65),label,'color','m');
hold on; grid on; 
xlabel('W/S Wing Loading [lbf/ft^2]');
% ylabel('W/P Power Loading [lbf/hp]');
ylabel('T/W Thrust to Weight');
title('Contraint Analysis');   %: ',string(aircraft.name)); 


% Maneuvering Constraint
plot(WS,constraint_maneuvering,'k','DisplayName','Maneuvering Constraint',...
                       'linewidth',2);
label = strjoin({'Cdo = ',num2str(Cdo)},' ');
text(WS(end)*0.4,constraint_maneuvering(length(WS)*0.25),label,'VerticalAlignment','top');


% Stall Constraint
colors = [0 0 1; 1 0 0; 0 1 0; 1 0.5 0];
cl_labels = strjoin({'Clmax = ',num2str(Clmax)},' ');
for i = 1:length(constraint_stall)
    xline(constraint_stall(i),'displayName','Stall Constraint',...
                   'color',colors(i,:),'LineWidth',2,'Label',cl_labels);
end

% Cruise Constraint - doesn't work too well
plot(WS,constraint_cruise,'r','displayname','Cruise Constraint','linewidth',2);
label = strjoin({'V_{cruise} = ',num2str(V_cruise)},' ');
text(WS(end)*0.2,constraint_cruise(length(WS)*0.25),label,'VerticalAlignment','top');

% Climb Constraint
colors = [0.6350 0.0780 0.1840; 1 0 0; 0 1 0; 1 0.5 0];
label = strcat('L/D max = ',num2str(LDmax));
for i = 1:length(constraint_climb)
    yline(constraint_climb(i),'displayName','Climb Constraint',...
                 'color',colors(1,:),'LineWidth',2,'label',label);
end


% Design Point 
WS_design = constraint_stall(1) * 0.975;
[~,idx] = min(abs(WS-constraint_stall(1)));
if constraint_climb(1) > constraint_maneuvering(idx)
    WP_design = constraint_maneuvering(idx)*0.975;
else
    WP_design = constraint_climb * 0.95;
end
plot(WS_design,WP_design,'*','DisplayName','Design Point','linewidth',1);

legend('show','location','northwest');

fprintf('\n-------Constraint Diagram-------\n');
fprintf('Design Wing Loading W/S = %.3f\n',WS_design);
% fprintf('Design Power Loading W/P = %.3f\n\n',WP_design);
fprintf('Design Thrust to Weight T/W = %.3f\n\n',WP_design);



%% Quick Geom Calcs and Packaging

% aircraft
aircraft.geom.wing.WS_design = WS_design;
aircraft.engine.WP_design = WP_design;
aircraft.geom.wing.Sref = aircraft.weight.gross / (WS_design);

% Geom (with AR based on desired wingspan)
Sref = aircraft.geom.wing.Sref;
if aircraft.geom.wing.b^2 / aircraft.geom.wing.Sref < 5
    b = sqrt(5*Sref);
    c = Sref / b;

    aircraft.geom.wing.b = b;
    aircraft.geom.wing.meanchord = c;
    aircraft.geom.wing.AR = aircraft.geom.wing.b^2 / Sref;

else % if aspect ratio falls between 5-7, use standard wingspan from aircraft data file
    aircraft.geom.wing.meanchord = Sref / aircraft.geom.wing.b;
    aircraft.geom.wing.AR = aircraft.geom.wing.b^2 / Sref;
end




end