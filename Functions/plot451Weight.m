function [aircraft,weight] = plot451Weight(WB_W,payload,aircraft,weight)
% historic451WeightData 
%   This function will take in the value of WB/W and use it to find the
%   design intersection between historic DBF data on a WB+Wpl vs. Gross
%   weight plot. 

% Import data 

data = [9.4   1.3;...
        9.5   1.5;...
        10.2  2.25;...
        15.4  2.9;...
        19.2  2.7];   % col 1 is gross weight, col 2 is W-We;

w = data(:,1);   % gross aircraft weight 
w_we = data(:,2);   % gross aircraft weight - empty weight  


%% Sizing Plot - We/W vs. W

figure;
plot(w,w_we,'*b','DisplayName','AIAA W-We');
grid on; hold on; 
xlabel('Gross Weight [lbf]'); ylabel('W-We and Wb+Wpl [lbf]');
% label = strcat('Historic 451 Data--',string(aircraft.name),'--Weight Sizing');
label = strcat('Historic 451 Data--Weight Sizing');
title(label);
subtitle(strcat('payload =',num2str(payload),'lbf'));

p1 = polyfit(w,w_we,1);   % curve fit for W-We vs. W
fun1 = polyval(p1,w);
plot(w,fun1,'r','DisplayName','451 Polyfit','LineWidth',2);

WB_plus_PL = WB_W * w + payload;
plot(w,WB_plus_PL,'m','DisplayName','WB+Wpayload','LineWidth',2);

legend('show','location','Northwest');


% Find Intersect 
intersect = (payload - p1(2)) / (p1(1) - WB_W);
fprintf('\n-------451 Estimation-------\n');
fprintf('Gross Weight Intersection: %.3f lbf\n',intersect)
fprintf('Add 10%% Error Bound: %.3f lbf\n\n',intersect * 1.1);


%% Packaging

% Weight
weight.gross = intersect*1.1;

% aircraft
aircraft.gross = intersect*1.1;


end