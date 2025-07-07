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

total = 0;

% Battery 
if strcmp(batteryName,'LiPo 2200mAh 45-60C')
    batteryWeight = 0.3831;   % pounds 
    capacity = 2200;   % mAh
    maxCRating = 60;   % C

    % https://www.amazon.com/HOOVO-Connector-Helicopter-Airplane-Quadcopter/dp/B07MQT6YJN/ref=sr_1_1_sspa?crid=2OTGD9A4NA69F&dib=eyJ2IjoiMSJ9.cEki7d9Joys7ERq-hvXJ0vBIJm620VNESgYG4V0uknUDRwr5gmUHT7Pfk8roTIKWDioHq2xPWrd44HJ6nkvDsO-nxhHZwkm1dwwY_87EVmsvZhvGXuWT2AavWGUqW9HifxW4-Vept0mRzf_SI5Xby2INMEmjubYb2lIs5Ha_F4taa_ZO2Z6P_FdKeVCI-DtHvFdycKfaoXeIz_3PwPbpWfrTTMQXpSxp55ZiJbiY3jPZr-yEGBKVWP3ndECFW7-RZYmmo4BXmSKx7Tt1eEaq-nCtEw2qjLLuMH8ZEv7mqVk.chV8TpfZ2LByczEgq10yniFwGEyJBzkW2d7dAAA3EqM&dib_tag=se&keywords=3s+2200mah+lipo+45C&qid=1751473255&sprefix=3s+2200mah+lipo+45c%2Caps%2C97&sr=8-1-spons&sp_csd=d2lkZ2V0TmFtZT1zcF9hdGY&psc=1

    total = total + batteryWeight;
end

% Motor 
if strcmp(motorName,'Cobra C-2808/16 (1780)')
    motorWeight = 0.1775;   % pounds
    KV = 1780;   % rpm/V
    motorLength = 0; 
    motorDiameter = 0;

    % https://innov8tivedesigns.com/cobra-c-2808-16-brushless-motor-kv-1780.html

    total = total + motorWeight;
end

% ESC
if strcmp(ESCName,'max 50A')
    current = 50;   % Amp
    ESCWeight = 0.08;   % pounds
    
    % https://www.amazon.com/Brushless-3-5mm-Fixed-Wing-Aircraft-Helicopter/dp/B0D39FJZGK/ref=sr_1_1_sspa?dib=eyJ2IjoiMSJ9.fEA8v595ntFqlO6mfpN4gALq5YTcKgcSZUFrTWOuZ6nsYTX9xBrSKkHVN4ivi2KfEq014dvFIOsNtF7x_JSTPb8swT4aDMpGFX6d1_R41idplBYeSc359ytqfRRTSlmyHGDw2wzcbB0cpOBOgbi6kLFE-Z3oXsdUHYuuO7VASY6UEAl7bXnftCuPzFyfmzvRmUSSQpPeyvSbsV9qkZZ90QkfEFN6l_h5uJzvM9SGfhStteyQtFnGDGdrJf1jTmZ4rKOnLs4vk_HcxLkCgaF9x_ed1iGJWqtmvW4N2hmyDXM.TMpN5ncvmekWUHLj_NeA_EjeHxK7OS8Qn-hktFP7w1s&dib_tag=se&keywords=50%2Bamp%2Besc&qid=1751474427&sr=8-1-spons&sp_csd=d2lkZ2V0TmFtZT1zcF9hdGY&th=1

    total = total + ESCWeight;
end

% Propeller 
if strcmp(propellerName,'APC Electric E 8x5')
    propDiam = 8;   % propeller diameter (inches)
    propPitch = 5;   % propeller pitch (inches)
    propellerWeight = 0.041875;   % propeller weight (lbs)

    % https://www.apcprop.com/product/8x5/?v=7516fd43adaa

    total = total + propellerWeight;
end

% Servos 


%% Packaging

% ENGINE
aircraft.engine.batteryName = batteryName;
aircraft.engine.motorName = motorName;
aircraft.engine.ESCName = ESCName;
aircraft.engine.propellerName = propellerName;
aircraft.engine.servoName = servoName;
aircraft.engine.propulsionWeight = total;

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
aircraft.engine.propeller.weight = propellerWeight;

% servos


% WEIGHTS 
aircraft.weight.sum.battery = batteryWeight;
aircraft.weight.sum.ESC = ESCWeight;
aircraft.weight.sum.motor = motorWeight;
aircraft.weight.sum.propeller = propellerWeight;



end