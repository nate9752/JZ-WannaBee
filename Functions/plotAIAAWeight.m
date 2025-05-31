function [aircraft,weight] = plotAIAAWeight(WB_W,payload,aircraft,weight)
% plotAIAAweightPlot
%   This function will take in the value of WB/W and use it to find the
%   design intersection between historic DBF data on a WB+Wpl vs. Gross
%   weight plot. 

data = readmatrix('RCAircraftHistoricWeightData.xlsx');

% Data sorting / chopping
index = isnan(data(:,7));   % removes NaN entries
data(index,:) = [];
index = (data(:,7) > 30);   % finds outliers
data(index,:) = [];
index = (data(:,7) < 10);   % finds lowliers 
data(index,:) = [];
data = sortrows(data,7);   % sorts in ascending order of W
index = data(:,6) == 2;   % uses only mission 2
data = data(index,:);

w = data(:,7);   % gross aircraft weight 
we = data(:,9);   % empty weight 


%% Sizing Plot - (W-We) and (Wb+Wpl) vs. W 

figure;
plot(w,w-we,'*b','DisplayName','AIAA W-We');
grid on; hold on; 
xlabel('Gross Weight [lbf]'); ylabel('W-We and Wb+Wpl [lbf]');
label = strcat('Historic AIAA Data--',string(aircraft.name),'--Weight Sizing');
% title('Historic AIAA Data -',string(aircraft.name),'Weight Sizing',strcat('payload = ','',num2str(payload),' lbf'));
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




