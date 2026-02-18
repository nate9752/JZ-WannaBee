function [T,Power,Voltage,Current] = calcEngine(dth,propMap)
% [T, energyProp] = calcEngine(dth,propMap)
%
% - This function will utilize the desired propulsion system and the eCalc
% Propulsion map to find the thrust and various energy factors for a given
% throttle. 
%
%%%

%% Catch Throttle Limit Failures

if dth > 1.2 
    dth = 1;
    warning('Warning: Throttle Exceeds 120%');
elseif dth < 0
    dth = 0;
    warning('Warning: Throttle Falls Below 0%');
end



%% Interpolate propMap

% Load propMap values
dthvec = propMap.Throttle ./ 100;
Tvec = propMap.Thrust;
Pvec = propMap.Power;
Voltvec = propMap.Voltage;
Currvec = propMap.Current;

% Interpolate over propMap based on dth
T = interp1(dthvec,Tvec,dth,'linear','extrap');
Power = interp1(dthvec,Pvec,dth,'linear','extrap');
Voltage = interp1(dthvec,Voltvec,dth,'linear','extrap');
Current = interp1(dthvec,Currvec,dth,'linear','extrap');



end

