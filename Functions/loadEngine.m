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



%% Packaging

aircraft.engine.battery = batteryName;
aircraft.engine.motor = motorName;
aircraft.engine.ESC = ESCName;
aircraft.engine.propeller = propellerName;
aircraft.engine.servo = servoName;


end