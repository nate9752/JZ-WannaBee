function aircraft = readVSPdata(aircraft)
% readVSPdata
%
% - this function will read prepopulated vsp data files and extract their
% information to the aircraft structure. The goal is to not have to run VSP
% every time the code is ran, only when a new geometry is created.
%
%%%

data = readtable('RCTB_V1.polar.txt','VariableNamingRule','preserve');


Cl = data{:,'CLtot'};
alpha = data{:,'AoA'};
Cdi = data{:,'CDi'};


% Package VSP Data
aircraft.aero.VSP.Cl = Cl;
aircraft.aero.VSP.alpha = alpha;
aircraft.aero.VSP.Cdi = Cdi;


% Plot Aero Data
plotAeroData(aircraft);

end

