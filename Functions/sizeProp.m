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
%       Current = Wattage/NomVoltage    NomVoltage = Cells * NomVoltage per cell
%                                                    Cells * 3.7 (for lipo) 
%       Current * 1.2 (for safety)  --> gives amperage for ESC
%
%   4. RPM and Motor Kv
%        RPM = 0.4896 * b^2 - 162.66 * b + 20786
%        Kv = RPM / NomVoltage
%        3D performance (lower Kv/RPM,), faster flying (higher Kv/RPM)
%
%   5. Propeller 
%        prop diam = -0.002 * RPM + 35.607 [in]  round down to neasrest whole number
%        prop pitch = prop diam / 1.57   [in] round to nearest half
%  
%        for faster speeds, reduce prop diam and increase prop pitch
%%%


weight = aircraft.weight.gross;
PPL = aircraft.engine.PPL;
b = aircraft.geom.wing.b * 12;

wattage = weight * PPL;   % Watts

% determine cell count based on wingspan
if b > 30 && b <= 40
    cellcount = "2S";
elseif b > 40 && b <= 55
    cellcount = "3S";
elseif b > 55 && b <= 68
    cellcount = "4S";
elseif b > 68 && b <= 84
    cellcount = "6S";
elseif b > 84 && b <= 96
    cellcount = "8S";
elseif b > 96 && b <= 105
    cellcount = "10";
elseif b > 105
    cellcount = "12S";
end

nomVoltPerCell = 3.7;   % nominal Voltage per cell for lipo batteries
cells = str2double(strrep(cellcount,'S',''));
nomVoltage = cells * nomVoltPerCell;
current  = (wattage / nomVoltage) * 1.5 ;   % 1.2 for factor of safety
current = ceil(current/5) * 5;   % round current to next highest multiple of 5

capacity = linspace(500,6000,10^3);
Crating = current./(capacity./1000) * 2;

% Plot C-rating vs. Capacity to select Capacity 
% C-rating indicates maximum discharge rate, 30C is reccomended for RC planes
figure;
plot(capacity,Crating);
xlabel('Capacity [mAh]'); ylabel('C-rating [C]');
title('Propulsion Sizing - C-rating vs. Capacity');
label = strjoin({cellcount{1},'battery,',num2str(current),'[A] ESC,'},' ');
subtitle(label);
grid on; hold on; 

[~,idx] = min(abs(Crating-60));
capacity = capacity(idx);   % capacity at index of C-rating = 30C
capacity = ceil(capacity/100)*100;   % rounds to next highest multiple of 100
Crating = ceil(Crating(idx)/5)*5;

b_RPM = ceil(b/10)*10;   % rounds wingspan to higher multiple of 5
RPM = 0.4896*b_RPM^2 - 162.66*b_RPM+20786;   % motor RPM
Kv = RPM / nomVoltage;
propDiam = -0.002*RPM + 35.607;   % propeller diameter [in]
propDiam = floor(propDiam);   % round down to nearest whole number
propPitch = propDiam/1.57;   % propeller pitch [in]
propPitch = ceil(propPitch*2)/2;   % round up to nearest half



%% Display Outputs
fprintf('\n------Propulsion Sizing------\n');
fprintf(strjoin({cellcount{1},'LiPo Battery,',num2str(capacity),'[mAh]'},' '));
fprintf('\nMotor RPM = %.0f, Kv = %.0f\n',RPM,Kv);
fprintf('Propeller Diameter = %.1f [in], Propeller Pitch = %.1f [in]\n',propDiam,propPitch)
fprintf('Max Discharge (C-rating) = %.0f C, Current = %.0f [A]\n',Crating,current);


%% Packaging 

aircraft.engine.wattage = wattage;
aircraft.engine.cellcount = cellcount;
aircraft.engine.current = current;
aircraft.engine.capacity = capacity;
aircraft.engine.Crating = Crating;
aircraft.engine.RPM = RPM;
aircraft.engine.Kv = Kv;
aircraft.engine.propDiam = propDiam;
aircraft.engine.propPitch = propPitch;


end

