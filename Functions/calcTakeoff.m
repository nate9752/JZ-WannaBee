function mission = calcTakeoff(aircraft,mission,atmosphere)
%
%
%
%

%% Initialize

% Aircraft Information
W = aircraft.weight.gross;
S = aircraft.geom.wing.Sref;
takeoff_type = mission.takeoff.type;
propMap = aircraft.engine.propMap;

% Aero Information
Clvec = aircraft.aero.VSP.Cl;
Cdivec = aircraft.aero.VSP.Cdi;
alphavec = aircraft.aero.VSP.alpha;
Cdo = aircraft.aero.Cdo;


% Initial States
vx0 = mission.takeoff.vx0;
vy0 = mission.takeoff.vy0;
h0 = mission.takeoff.h0;
x0 = 0;
gamma0 = 0;
t0 = 0;
dth0 = 1;




dt = 0.01;
exitflag = 1;
i = 1;

while exitflag
    
    if i == 1
        vx(1) = vx0; vy(1) = vy0; V(1) = norm([vx0 vy0]);
        x(1) = x0; h(1) = h0;
        t(1) = t0; gamma(1) = gamma0;
        dth(1) = dth0;
    end

    

    % Need a section loading aero props
    cl(i) = interp1(alphavec,Clvec,gamma(i),'linear','extrap');
    cdi(i) = interp1(alphavec,Cdivec,gamma(i),'linear','extrap');
    cd(i) = Cdo + cdi(i);

    rho_h = interp1(atmosphere.h,atmosphere.rho,h(i),'linear','extrap');

    % Calculate Forces
    L(i) = 1/2 * rho_h * V(i)^2 * S * cl(i);
    D(i) = 1/2 * rho_h * V(i)^2 * S * cd(i);
    [T(i), Power(i), Voltage(i), Current(i)] = calcEngine(dth(i),aircraft.engine.propMap);

    % Sum forces
    Fx = T(i)*cosd(gamma(i)) - D(i)*cosd(gamma(i)) - L(i)*sin(gamma(i));   %  <-- logic for negative alpha
    Fy = L(i)*cosd(gamma(i)) - W + T(i)*sind(gamma(i)) - D(i)*sind(gamma(i));

    % F = m*a
    ax = Fx / (W/32.17405);
    ay = Fy / (W/32.17405);

    % Update Velocities
    dVx = ax * dt;
    dVy = ay * dt;
    vx(i+1) = vx(i) + dVx;
    vy(i+1) = vy(i) + dVy;

    % Update all values
    V(i+1) = norm([vx(i+1) vy(i+1)]);
    alpha(i+1) = atand(vy(i+1) / vx(i+1));
    gamma(i+1) = alpha(i+1);
    h(i+1) = h(i) + vy(i)*dt;
    x(i+1) = x(i) + vx(i)*dt;
    t(i+1) = t(i) + dt;
    dth(i+1) = dth(i);

    if h(i) > 10 || i > 100
        exitflag = 0;
    else
        i = i + 1;
    end

end

% Trim last updated index
vx = vx(1:end-1);
vy = vy(1:end-1);
V = V(1:end-1);
alpha = alpha(1:end-1);
gamma = gamma(1:end-1);
h = h(1:end-1);
x = x(1:end-1);
t = t(1:end-1);
dth = dth(1:end-1);



%% Takeoff Plots

figure;   % takeoff trajecotry
plot(x,h,'LineWidth',1.5);
grid on; hold on;
xlabel('X Distance (ft)'); ylabel('Altitude (ft)');
title('Takeoff Trajectory');


figure;   % force summary
plot(t,T,'LineWidth',1.5,'DisplayName','Thrust');
grid on; hold on; 
plot(t,L,'LineWidth',1.5,'DisplayName','Lift');
plot(t,D,'LineWidth',1.5,'DisplayName','Drag');
xlabel('time (sec)'); ylabel('Force (lbs)');
title('Takeoff Force Time History');



%% Package Takeoff Outputs




end