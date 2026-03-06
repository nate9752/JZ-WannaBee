function aircraft = plotWeightIntersect(aircraft)
% plot Weight Intersect
%   This code will combine databases from AIAA,, AAE451, and my personal
%   built RC aircraft to create a plot of W-We and Wpl+Wbatt vs. Gross
%   weight. This is an attempt to get an accurate prediction of aircraft
%   weight given only mission specific parameters. 
%
%   Using this code gives a very close prediction based off the DBF
%   aircraft for senior design with 29 payload cubes (10.6 real vs. 10.688
%   DBF).
%  
%

%% Unpackage 

WB_W = aircraft.weight.WB_W;
payload = aircraft.weight.payload;



%% Import Historical Data

data = readtable('RCAircraftHistoricWeightData.xlsx','VariableNamingRule','preserve');

index = data{:,'Gross Weight [lbf]'} > 20;   % finds outliers in gross weight
data(index,:) = [];
index = data{:,'Gross Weight [lbf]'} < 4;   % finds outliers in gross weight
data(index,:) = [];
index = data{:,'Gross Weight [lbf]'} - data{:,'Empty Weight [lbf]'} < 0.5;   % finds planes with no battery or playload
data(index,:) = [];

w = data{:,'Gross Weight [lbf]'};   % gross aircraft weight 
we = data{:,'Empty Weight [lbf]'};   % empty weight 



%% Sizing Plot - (W-We) and (Wb+Wpl) vs. W 

% Plot Historic Weight Data
figure;
plot(w,w-we,'*b','DisplayName','Historic W-We');
grid on; hold on; 

% Plot Curve Fit For Historic Data
p1 = polyfit(w,w-we,1);
fun1 = polyval(p1,w);
plot(w,fun1,'r','DisplayName','AIAA Polyfit','LineWidth',2);

% Plot Calculated w_battery + w_payload
WB_plus_PL = WB_W * w + payload;
plot(w,WB_plus_PL,'m','DisplayName','WB+Wpayload','LineWidth',2);


xlabel('Gross Weight [lbf]'); ylabel('W-We and Wb+Wpl [lbf]');
label = strcat('Historic Data--',string(aircraft.name),'--Weight Sizing');
title(label,'Interpreter','none');
subtitle(strcat('payload =',num2str(payload),'lbf'));


% Find Intersect 
intersect = (payload - p1(2)) / (p1(1) - WB_W);
fprintf('\n-------AIAA Estimations-------\n');
fprintf('Gross Weight Intersection: %.3f lbf\n',intersect);
fprintf('Add 10%% Error Bound: %.3f lbf\n\n',intersect * 1.1);



yint = WB_W*intersect + payload;
plot(intersect,yint,'ro','LineWidth',1.2,'DisplayName','Design Intersection');


legend('show','location','Northwest');



%% Packaging

% aircraft
aircraft.weight.gross = intersect*1.1;


% Engine - equation from Gudmundsson chapter 3
r = .75;   % 75% maximum rated power
P_BHP = 1/r * aircraft.aero.V_cruise/(550*aircraft.engine.eta_p) * ...
              aircraft.weight.gross/aircraft.aero.LDmax;

P_KW = 1/r * aircraft.aero.V_cruise*(0.3048)/(1000*aircraft.engine.eta_p) * ...
              aircraft.weight.gross*(4.44822)/aircraft.aero.LDmax;   % conversion to SI
aircraft.engine.P_BHP = P_BHP;
aircraft.engine.P_KW = P_KW;


end

