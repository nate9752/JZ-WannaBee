% five minute flight 
% Basic mission data file


%% Takeoff Details

mission.takeoff.type = 'hand_launch';
mission.takeoff.h0 = 6;   % takeoff handlaunched height
mission.takeoff.vx0 = 6;   % hand launch ft/s
mission.takeoff.vy0 = 2;   % hand launch vertical speed ft/s


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


