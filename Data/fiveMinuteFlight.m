% five minute flight 
% Basic mission data file


%% Takeoff Details

mission.takeoff.type = 'hand_launch';
mission.takeoff.h0 = 6.5;   % takeoff handlaunched height
mission.takeoff.vx0 = 25;   % hand launch ft/s
mission.takeoff.vy0 = 5;   % hand launch vertical speed ft/s
mission.takeoff.alpha = 10;   % average AoA for takeoff (deg)


%% Climb Details

mission.climb.dth = 1;   % throttle for climb;


%% Cruise Details

mission.cruise.flag = 1;
mission.cruiseDuration = 5 * 60;   % five minutes [sec]
mission.turning.flag = 0;   % for preliminary design, won't consider turning


%% Descent Details 




%% Landing Details

mission.landing.type = 'belly';


%% Packaging


