function [aircraft,weight] = plotWeightIntersect(WB_W,payload,aircraft,weight)
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

data = readmatrix('RCAircraftHistoricData.xlsx');

index = data(:,2) > 20;   % finds outliers
data(index,:) = [];
index = data(:,2) - data(:,4) > 12;
data(index,:) = [];

w = data(:,2);   % gross aircraft weight 
we = data(:,4);   % empty weight 


%% Sizing Plot - (W-We) and (Wb+Wpl) vs. W 

figure;
plot(w,w-we,'*b','DisplayName','Historic W-We');
grid on; hold on; 
xlabel('Gross Weight [lbf]'); ylabel('W-We and Wb+Wpl [lbf]');
label = strcat('Historic Data--',string(aircraft.name),'--Weight Sizing');
title(label);
subtitle(strcat('payload =',num2str(payload),'lbf'));

p1 = polyfit(w,w-we,1);   % curve fit for W-We vs. W
fun1 = polyval(p1,w);
plot(w,fun1,'r','DisplayName','AIAA Polyfit','LineWidth',2);

WB_plus_PL = WB_W * w + payload;
plot(w,WB_plus_PL,'m','DisplayName','WB+Wpayload','LineWidth',2);

legend('show','location','Northwest');
 
% Find Intersect 
intersect = (payload - p1(2)) / (p1(1) - WB_W);
fprintf('-------AIAA Estimations-------\n');
fprintf('Gross Weight Intersection: %.3f lbf\n',intersect)
fprintf('Add 10%% Error Bound: %.3f lbf\n\n',intersect * 1.1);


%% Packaging

% Weight
weight.gross = intersect*1.1;

% aircraft
aircraft.gross = intersect*1.1;



end

