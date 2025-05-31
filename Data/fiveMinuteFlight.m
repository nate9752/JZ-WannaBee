% five minute flight 
% Basic mission data file
% No real desired mission parameters, only time


%% Mission Details

mission.cruise.flag = 1;
cruiseDuration = 5 * 60;   % five minutes [sec]

mission.turning.flag = 0;   % for preliminary design, won't consider turning

%% Packaging

mission.cruiseDuration = cruiseDuration;

