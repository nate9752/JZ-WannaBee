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
mission.climb.gamma = 15;   % climb angle [deg]
mission.climb.alpha = 5;
mission.climb.climbFactor = 1.3;   % V_climb = {x} * V_stall
mission.climb.tau = 0.5;   % for blending TO --> Climb and Climb --> Cruise
mission.climb.h_transition = 25;   % feet below cruise alt before blending


%% Cruise Details

mission.cruise.flag = 1;
mission.cruiseDuration = 5 * 60;   % five minutes [sec]
mission.turning.flag = 0;   % for preliminary design, won't consider turning
mission.cruise.h = 200;   % cruise altitude [ft]


%% Descent Details 




%% Landing Details

mission.landing.type = 'belly';


%% Packaging


