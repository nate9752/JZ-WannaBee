function mission = calcTakeoff(aircraft,mission,atmosphere)
%
% - mission = calcTakeoff(aircraft,mission,atmosphere)
%
%   - This function will simulate Takeoff Flight of the fully designed
%   aircraft. A simple time-step integration method is used.
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

% Engine Information 
Q_used = 0;   % Capacity of battery used
Q_total = aircraft.engine.battery.capacity;


% Initial States
vx0 = mission.takeoff.vx0;
vy0 = mission.takeoff.vy0;
alphaTakeoff = mission.takeoff.alpha;
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
        t(1) = t0; gamma(1) = atand(vy0/vx0);
        dth(1) = dth0;
        alpha(1) = alphaTakeoff;
        Q_used(1) = 0;
        battery_pct(1) = 100;
    end

    
    % Need a section loading aero props
    cl(i) = interp1(alphavec,Clvec,alpha(i),'linear','extrap');
    cdi(i) = interp1(alphavec,Cdivec,alpha(i),'linear','extrap');
    cd(i) = Cdo + cdi(i);

    rho_h = interp1(atmosphere.h,atmosphere.rho,h(i),'linear','extrap');

    % Calculate Forces
    L(i) = 1/2 * rho_h * V(i)^2 * S * cl(i);
    D(i) = 1/2 * rho_h * V(i)^2 * S * cd(i);
    [T(i), Power(i), Voltage(i), Current(i)] = calcEngine(dth(i),aircraft.engine.propMap);
    Q_used(i+1) = Q_used(i) + Current(i)*dt/3600;
    battery_pct(i+1) = 100*(1 - Q_used(i+1)/Q_total);

    % Sum forces
    % if gamma(i) > 0
    %     Fx(i) = T(i)*cosd(gamma(i)) - D(i)*cosd(gamma(i)) - L(i)*sind(gamma(i));
    %     Fy(i) = L(i)*cosd(gamma(i)) - W(i) + T(i)*sind(gamma(i)) - D(i)*sind(gamma(i));
    % else
    %     Fx(i) = T(i)*cosd(gamma(i)) - D(i)*cosd(gamma(i)) + L(i)*sind(gamma(i));
    %     Fy(i) = L(i)*cosd(gamma(i)) - W(i) - T(i)*sind(gamma(i)) + D(i)*sind(gamma(i));
    % end
    Fx(i) = T(i) - D(i)*cosd(gamma(i)); % - L(i)*sind(gamma(i));
    Fy(i) = L(i)*cosd(gamma(i)) - W(i); % - D(i)*sind(gamma(i));

    % F = m*a
    ax = Fx(i) / (W(i)/32.17405);
    ay = Fy(i) / (W(i)/32.17405);

    % Update Velocities
    dVx = ax * dt; 
    dVy = ay * dt; 
    vx(i+1) = vx(i) + dVx; 
    vy(i+1) = vy(i) + dVy; 

    % Update all values
    V(i+1) = norm([vx(i+1) vy(i+1)]);
    gamma(i+1) = atand(vy(i+1) / vx(i+1));
    alpha(i+1) = alpha(i);
    h(i+1) = h(i) + vy(i+1)*dt;
    x(i+1) = x(i) + vx(i+1)*dt;
    t(i+1) = t(i) + dt;
    dth(i+1) = dth(i);
    W(i+1) = W(i);

    if h(i) > 10 || i > 500
        exitflag = 0;
    elseif h(i) < 0
        warning('Takeoff Failed, h < 0 ft');
        break;
    else
        i = i + 1;
    end

end

% Trim last updated index
vx = vx(1:end-1); vy = vy(1:end-1); V = V(1:end-1);
gamma = gamma(1:end-1); alpha = alpha(1:end-1);
h = h(1:end-1); x = x(1:end-1); t = t(1:end-1);
dth = dth(1:end-1); W = W(1:end-1);
Q_used = Q_used(1:end-1); battery_pct = battery_pct(1:end-1);



%% Takeoff Plots

figure;   % takeoff trajecotry
subplot(2,2,1);
sgtitle('Takeoff Summary');
plot(x,h,'LineWidth',1.5);
grid on; hold on;
xlabel('X Distance (ft)'); ylabel('Altitude (ft)');
title('Takeoff Trajectory');


% figure;   % force summary
subplot(2,2,2);
plot(t,T,'LineWidth',1.5,'DisplayName','Thrust');
grid on; hold on; 
plot(t,L,'LineWidth',1.5,'DisplayName','Lift');
plot(t,D,'LineWidth',1.5,'DisplayName','Drag');
plot(t,W,'LineWidth',1.5,'DisplayName','Weight');
xlabel('time (sec)'); ylabel('Force (lbs)');
title('Takeoff Force Time History');
legend('show','location','northwest');


% figure;   % angle summary
subplot(2,2,3);
plot(t,alpha,'LineWidth',1.5,'DisplayName','\alpha');
grid on; hold on; 
plot(t,gamma,'LineWidth',1.5,'DisplayName','\gamma');
xlabel('Time (sec)'); ylabel('Angle (deg)');
title('Takeoff Angle Time Hisotry');
legend('show');


% figure;   % Velocity Time History
subplot(2,2,4);
plot(t,vx,'LineWidth',1.5,'DisplayName','V_{x}');
grid on; hold on;
plot(t,vy,'LineWidth',1.5,'DisplayName','V_{y}');
plot(t,V,'LineWidth',1.5,'DisplayName','V');
xlabel('Time (sec)'); ylabel('Velocity (ft/s)');
title('Takeoff Velocity Time History');
legend('show');



%% Package Takeoff Outputs

mission.takeoff.t_hist = [t; x; h; vx; vy; V; gamma; Q_used; battery_pct]';




end