function aircraft = loadEngine(inputs,aircraft)
% aircraft = loadEngine(inputs, aircraft)
%
%   - This function will load the basics of our propulsion system for our 
%   aircraft. For now I imagine a large if-elseif structure will suffice,
%   but this may change in the future if we get a large amount of
%   propulsion equiptment in our database. 
%
%%%

batteryName = inputs.batteryInput;
motorName = inputs.motorInput;
ESCName = inputs.ESCInput;
propellerName = inputs.propellerInput;
servoName = inputs.servoInput;


%% Selection Structure

% Battery 
if strcmp(batteryName,'LiPo 2200mAh 45-60C')
    batteryWeight = 0.3831;   % pounds 
    capacity = 2200;   % mAh
    maxCRating = 60;   % C
end

% Motor 
if strcmp(motorName,'Cobra C-2808/16 (1780)')
    motorWeight = 0.1775;   % pounds
    KV = 1780;   % rpm/V
    motorLength = 0; 
    motorDiameter = 0; 
end

% ESC
if strcmp(ESCName,'max 50A')
    current = 50;   % Amp
    ESCWeight = 0.1433;   % pounds
end

% Propeller 
if strcmp(propellerName,'APC Electric E 8x5')
    propellerWeight = 0;   % pounds
    propDiam = 8;   % propeller diameter (inches)
    propPitch = 5;   % propeller pitch (inches)
end

% Servos 


%% Packaging

% ENGINE
aircraft.engine.batteryName = batteryName;
aircraft.engine.motorName = motorName;
aircraft.engine.ESCName = ESCName;
aircraft.engine.propellerName = propellerName;
aircraft.engine.servoName = servoName;

% battery
aircraft.engine.battery.weight = batteryWeight;
aircraft.engine.battery.capacity = capacity;
aircraft.engine.battery.maxCRating = maxCRating;

% motor 
aircraft.engine.motor.weight = motorWeight;
aircraft.engine.motor.KV = KV;
aircraft.engine.motor.length = motorLength;
aircraft.engine.motor.diameter = motorDiameter;

% ESC 
aircraft.engine.ESC.current = current;
aircraft.engine.ESC.weight = ESCWeight;

% propeller
aircraft.engine.propeller.weight = propellerWeight;
aircraft.engine.propeller.diameter = propDiam;
aircraft.engine.propeller.pitch = propPitch;

% servos


% WEIGHTS 
aircraft.weight.sum.battery = batteryWeight;
aircraft.weight.sum.ESC = ESCWeight;
aircraft.weight.sum.motor = motorWeight;
aircraft.weight.sum.propeller = propellerWeight;



end