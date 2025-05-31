function inputs = loadInputs(aircraft_input, battery_input, ESC_input, motor_input,...
                    propeller_input, servo_input,mission_input)
% loadInputs(aircraft_input, battery_input, ESC_input, motor_input, ...
%            propeller_input, servo_input, mission_input)
%
%   - This function will take all variable inputs and load them into a
%   single structure named inputs. This structure will be used in future
%   function calls. Should help with organization. 

inputs = struct();

inputs.aircraftInput = aircraft_input;
inputs.batteryInput = battery_input;
inputs.ESCInput = ESC_input;
inputs.motorInput = motor_input;
inputs.propellerInput = propeller_input;
inputs.servoInput = servo_input;
inputs.missionInput = mission_input;


end