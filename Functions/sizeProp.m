function aircraft = sizeProp(aircraft)
% aircraft = sizeprop(aircraft)
%
% This script will use methods from a very nice youTube video on how to
% size a propulsion system. I might mess around with it to implament some
% sort of optimization system, or I will just list out what I see are the
% ideal propulsion specs.
%
% Sizing a propulsion system:
%   https://www.youtube.com/watch?v=5OS6dQ4E2T8&t=431s
%
%   1. Wattage
%        Wattage = Weight * Power Performance Level
%        Power Performance Level --> 3D performance = 150
%                                    Aerobatic/High Speed = 125
%                                    Sport Flying = 110
%                                    Basic Trainer = 85
%                                    Lightly Loaded Model = 60
%
%   2. Cell count (capacity)
%        2S  30-40in wingspan, 3S  40-55in wingspan, 4S  55-68in wingspan,
%        6S  68-84in wingspan, 8S  84-96in wingspan, 10S 96-105in wingspan
%     
%      capacity will be within 2200 and 5000 mAh
%         C-rating = Max Current (Amps) / Capacity * 2    
%         *** Ensure Capacity is in Ah, not mAh ***
%
%   3. Current (Amperage)
%       Current = Wattage/NomVoltage    NomVoltage = Cells*NomVoltage
%                                                    Cells * 3.7 (for lipo) 
%       Current * 1.2 (for safety)  --> gives amperage for ESC
%
%   4. RPM and Motor Kv
%        RPM = 0.4896 * b^2 - 162.66 * b + 20786
%        Kv = RPM / NomVoltage
%        3D performance (lower Kv/RPM,), faster flying (Kv/RPM)
%
%   5. Propeller 
%        prop diam = -0.002 * RPM + 35.607 [in]  round down to neasrest whole number
%        prop pitch = prop diam / 1.57   [in] round to nearest half
%  
%        for faster speeds, reduce prop diam and increase prop pitch
%%%


weight = aircraft.weight.gross;
PPL = aircraft.engine.PPL;
b = aircraft.geom.wing.b;

Wattage = weight * PPL;   % Watts

% if structure to determine cell count
cellcount = '2S';



RPM = 0.4896*b^2 - 162.66*b+20786;   % motor RPM
propDiam = -0.002*RPM + 35.607;   % propeller diameter [in]
propPitch = propDiam/1.57;





end

