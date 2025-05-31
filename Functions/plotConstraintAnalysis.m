function [aircraft,geom] = plotConstraintAnalysis(aircraft,engine,aero,atmosphere,geom)
%makeConstraintAnalysis(aircraft)
%   This function will make a constraint diagram with stall, maneuvering,
%   power, and climbing constraints impossed. 

WS = linspace(0,2.5,100)';

% Unpackaging
V_stall = aircraft.V_stall;   % stall speed ft/s
Clmax = 1.5;   % [1.3 1.4 1.5]
Cdo = aero.Cdo;   % [0.02 0.025 0.027 0.03]
LDmax = aircraft.LD;   % [10 12 14 15]

eta_p = engine.eta_p;
V_cruise = aircraft.V_cruise;
V_climb = aircraft.V_climb;
gamma = aircraft.gamma;
e = aircraft.e;


% Stall Constraint 
constraint_stall = 1/2 * atmosphere.rho(1) * V_stall^2 * Clmax;

% Power Constraint 
constraint_power = WS * 0.75 * 550 * eta_p ./ ...
         (1/2 * atmosphere.rho(1) * 1.1*(Cdo) * V_cruise^3);

% Climbing Constraint
constraint_climb = 550 * eta_p ./...
               (V_climb * (1./(0.866.*LDmax) + sind(gamma)));

% Maneuvering Constraint
AR = 5;   % preliminary estimate
k = 1/(pi*AR*e);
n = 3;   % 3 g turns
q = 1/2 * atmosphere.rho(end) * (V_cruise * 0.8)^2;   % 80% velocity on turn 
constraint_maneuvering = 550 * eta_p ./...
       (q * V_cruise * 0.8 * (Cdo./WS + k*(n/q)^2 * WS));


% Power Constraint 
figure; 
plot(WS,constraint_power,'color','m','DisplayName','Power Constraint',...
                       'linewidth',2);
label = strcat('Cdo = ',num2str(Cdo));
text(WS(end)*0.65,constraint_power(length(WS)*0.65),label,'color','m');
hold on; grid on; 
xlabel('W/S Wing Loading [lbf/ft^2]');
ylabel('W/P Power Loading [lbf/hp]');
title('Contraint Analysis');%: ',string(aircraft.name)); 


% Maneuvering Constraint
plot(WS,constraint_maneuvering,'k','DisplayName','Maneuvering Constraint',...
                       'linewidth',2);
label = strcat('Cdo = ',num2str(Cdo));
text(WS(end)*0.4,constraint_maneuvering(length(WS)*0.25),label,'VerticalAlignment','top');


% Stall Constraint
colors = [0 0 1; 1 0 0; 0 1 0; 1 0.5 0];
cl_labels = strcat('Clmax = ',num2str(Clmax));
for i = 1:length(constraint_stall)
    xline(constraint_stall(i),'displayName','Stall Constraint',...
                   'color',colors(i,:),'LineWidth',2,'Label',cl_labels);
end


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
    WP_design = constraint_climb * 0.975;
end
plot(WS_design,WP_design,'*','DisplayName','Design Point','linewidth',1);

legend('show','location','northwest');

fprintf('-------Constraint Diagram-------\n');
fprintf('Design Wing Loading W/S = %.3f\n',WS_design);
fprintf('Design Power Loading W/P = %.3f\n\n',WP_design);



%% Quick Geom Calcs and Packaging

% aircraft
aircraft.WS_design = WS_design;
aircraft.WP_design = WP_design;
aircraft.S = aircraft.gross / WS_design;

% Geom (with AR check 5-7)
if aircraft.b^2 / aircraft.S < 5
    b = sqrt(5*aircraft.S);
    c = aircraft.S / b;

    aircraft.b = b;
    aircraft.wingchord = c;
    geom.wing.Sref = aircraft.gross/WS_design;
    geom.wing.meanchord = c;
    geom.wing.AR = aircraft.b^2 / geom.wing.Sref;
    aircraft.wingAR = aircraft.b^2 / geom.wing.Sref;

else 
    geom.wing.Sref = aircraft.gross/WS_design;
    geom.wing.meanchord = geom.wing.Sref / aircraft.b;
    geom.wing.AR = aircraft.b^2 / geom.wing.Sref;
    aircraft.wingAR = aircraft.b^2 / geom.wing.Sref;
end


end