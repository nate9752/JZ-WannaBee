function aircraft = buildWeight(aircraft)
% aircraft = buildWeight(aircraft)
% 
%   - This function will load all available weights data and analyze the
%   conceptual MTOW of the aircraft based on the design process. I plan on
%   adding a margin to account for innacuracies in the design/build
%   process. The code will also produce a pie chart to allow for phyiscal
%   visualization of the weights for each system. 
%
%%%


weightNames = fieldnames(aircraft.weight.sum);   % collect summation names of weights

data = zeros(1,length(weightNames));
labels = cell(1,length(weightNames));
for i = 1:length(weightNames)
    data(i) = aircraft.weight.sum.(weightNames{i});
    labels{i} = strcat(weightNames{i},'=', num2str(data(i)));
end
% data = data/sum(data);

totalWeightPlot = figure;
piechart(data,labels);%,'labelStyle','namedata');
title('Total Weight Breakdown (lbs)');



%% Display Outputs

fprintf('\n\n-------Design Gross Weight-------\n');
fprintf('Propulsion Weight = %.3f lbf\n',aircraft.engine.propulsionWeight);
fprintf('Fuselage Weight = %.3f lbf\n',aircraft.weight.sum.fuselage);
fprintf('Aero Surfaces Weight = %.3f\n',aircraft.weight.sum.wing+aircraft.weight.sum.horztail+aircraft.weight.sum.verttail);
fprintf('Total Weight (assuming 20%% build increase) = %.3f\n',sum(data)*1.2);



%% Packaging 

aircraft.weight.totalPlot = totalWeightPlot;



end