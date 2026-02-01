function aircraft = loadPropMap(inputs, aircraft)
% aircraft = loadPropMap 
%
%   - This function will load a specific propulsion map for a selected
%   finalized propulsion system. Map is generated using propCalc, a website
%   that uses historical data to estimate propulsive performance for RC
%   aircraft. 
%%%

batteryName = inputs.batteryInput;
motorName = inputs.motorInput;
ESCName = inputs.ESCInput;
propellerName = inputs.propellerInput;
servoName = inputs.servoInput;


%% Selection Structure

if strcmp(batteryName,'LiPo 2200mAh 45-60C') && strcmp(motorName,'Cobra C-2808/16 (1780)') ... 
      && strcmp(ESCName,'max 50A') && strcmp(propellerName,'APC Electric E 8x5')

    propMap = readtable('propMap.xlsx','Sheet','RCTB_V1','VariableNamingRule','preserve');

    propSpeed = propMap{:,'Propeller'};   % prop speed (rpm)
    propThrottle = propMap{:,'Throttle'};   % prop throttle (%)
    propCurrent = propMap{:,'Current (DC)'};   % prop current (A)
    propVoltage = propMap{:,'Voltage (DC)'};   % prop voltage (V)
    propPower = propMap{:,'el. Power'};   % prop Power (W)
    propThrust = propMap{:,'            Thrust'} / 453.59237;   % prop thrust (lbs)

end



%% Packaging

aircraft.engine.propMap.Map = propMap;
aircraft.engine.propMap.PropSpeed = propSpeed;
aircraft.engine.propMap.Throttle = propThrottle;
aircraft.engine.propMap.Current = propCurrent;
aircraft.engine.propMap.Voltage = propVoltage;
aircraft.engine.propMap.Power = propPower;
aircraft.engine.propMap.Thrust = propThrust;


end