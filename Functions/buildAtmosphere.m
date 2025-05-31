function atmosphere = buildAtmosphere
% [atmosphere] = buildAtmosphere() 
%   This code will create a structure for the atmosphere assuming we cruise
%   at a constant 200ft during our flight tests. 

atmosphere = struct();

h = linspace(0,200,1000);   % atmosphere

gamma = 1.4;   % ratio of specific heats air
Tsl = 518.67;   % temperature sea level R
rhosl = 0.002378;   % density sea level slug/ft^3
Psl = 14.7;   % sea level pressure psi
mu = 1.802*10^-5 * 0.02089;   % dynamic viscosity slug/ft-s

g = 32.17;   % acceleration due to gravity ft/s^2
R = 53.5;   % gas constant air ft*lbf / (lb*R)
L = 6.5 * 1.8 / 3280.84;   % temperature lapse rate R/ft

T = Tsl - h * L;
theta = T / Tsl;   % temperature ratio T / Tsl
delta = theta .^ (g/(L*R));   % pressure ratio 
sig = theta .^ ((g-L*R) / (L*R));   % density ratio

P = delta * Psl;
rho = sig * rhosl;

a = sqrt(gamma*1716.46*T)';   % speed of sound, new R cause units ft*lbf/(slug*R)

atmosphere.mu = mu;
atmosphere.gamma = gamma;
atmosphere.gravity = g;
atmosphere.R = R;
atmosphere.h = h';
atmosphere.T = T';
atmosphere.P = P';
atmosphere.rho = rho';
atmosphere.a = a;

end