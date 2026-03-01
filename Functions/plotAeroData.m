function  plotAeroData(aircraft)
% plotAeroData(aircraft)
%
% - This function will produce some simple plots of the Aero Data outputted
% from OpenVSP.
%
%%%

Cl = aircraft.aero.VSP.Cl;
Cdi = aircraft.aero.VSP.Cdi;
alpha = aircraft.aero.VSP.alpha;
Cdo = aircraft.aero.Cdo;

Cd = Cdo + Cdi;

figure;   % Cl alpha curve
subplot(1,2,1);
sgtitle('Data from OpenVSP');
plot(alpha,Cl,'*-b','LineWidth',1.25);
grid on; hold on;
xlabel('Alpha (deg)'); ylabel('Coefficient of Lift');
title('C_{l} vs. \alpha');

subplot(1,2,2);
plot(Cd,Cl,'*-r','LineWidth',1.25);
grid on; hold on;
xlabel('C_{d}'); ylabel('C_{l}');
title('Drag Polar');





end

