function mission = calcClimb(aircraft,mission,atmosphere)
%
% mission = calcClimb(aircraft,mission,atmosphere)
%
%   - This function will simulate climb of an RC aircraft using a time step
%   integration method. 
%
%
%%%

V_climb = mission.climb.climbFactor * aircraft.aero.V_stall;   % desired climb speed
V_cruise = aircraft.aero.V_cruise;
tau = mission.climb.tau;   % seconds to blend takeoff to climb
h_transition = mission.climb.h_transition;

% Aircraft Information
W = aircraft.weight.gross;
S = aircraft.geom.wing.Sref;

% Aero Information
Clvec = aircraft.aero.VSP.Cl;
Cdivec = aircraft.aero.VSP.Cdi;
alphavec = aircraft.aero.VSP.alpha;
Cdo = aircraft.aero.Cdo;

% Engine Information 
Q_used_sc = mission.takeoff.t_hist(end,8);   % sc = start of climb
Q_total = aircraft.engine.battery.capacity;

% From Takeoff
%       t_hist = [t; x; h; vx; vy; V; gamma; Q_used; battery_pct]
vx0 = mission.takeoff.t_hist(end,4);
vy0 = mission.takeoff.t_hist(end,5);
alphaClimb = mission.climb.alpha;
h0 = mission.takeoff.t_hist(end,3);
x0 = mission.takeoff.t_hist(end,2);
gamma0 = mission.takeoff.t_hist(end,7);
t0 = mission.takeoff.t_hist(end,1);
dth0 = 1;


dt = 0.1;
exitflag = 1;
i = 1;


%% Integration Loop

while exitflag
    
    if i == 1
        vx(1) = vx0; vy(1) = vy0; V(1) = norm([vx0 vy0]);
        x(1) = x0; h(1) = h0;
        t(1) = t0; gamma(1) = gamma0;
        dth(1) = dth0;
        alpha(1) = alphaClimb;
        Q_used(1) = Q_used_sc;
        battery_pct(1) = mission.takeoff.t_hist(end,9);
    end

    % Blend for Cruise Conditions
    blend = min(max((h(i) - (mission.cruise.h - h_transition)) / h_transition,0),1);

    rho_h = interp1(atmosphere.h,atmosphere.rho,h(i),'linear','extrap');

    % Determine Cl required for climbing flight
    cl(i) = 2*W(i)*cosd(gamma(i))/(rho_h*V(i)^2*S);
    alpha(i) = interp1(Clvec,alphavec,cl(i),'linear','extrap');

    cdi(i) = interp1(alphavec,Cdivec,alpha(i),'linear','extrap');
    cd(i) = Cdo + cdi(i);


    % Calculate Forces and Battery Properties
    L(i) = 1/2 * rho_h * V(i)^2 * S * cl(i);
    D(i) = 1/2 * rho_h * V(i)^2 * S * cd(i);

    [T(i), Power(i), Voltage(i), Current(i)] = calcEngine(dth(i),aircraft.engine.propMap);
    Q_used(i+1) = Q_used(i) + Current(i)*dt/3600;
    battery_pct(i+1) = 100*(1 - Q_used(i+1)/Q_total);

    dth_target = (1-blend)*dth0 + blend*(D(i)/T(i));
    dth(i+1) = dth(i) + (dth_target - dth(i))*dt/2;

    % Calculate Rate of Climb
    tau_RC = 0.5;
    RC = (T(i)-D(i))*V(i)/W(i);
    RC_target = (1-blend)*RC;
    dvy = (RC_target - vy(i)) / tau_RC;
    vy(i+1) = vy(i) + dvy*dt;
    vx(i+1) = sqrt(V(i)^2 - vy(i)^2);

    % Blend Velocity of Takeoff into Climb and Climb into Cruise
    V_target = (1-blend)*V_climb + blend*V_cruise;
    dV = (V_target - V(i)) / tau;
    V(i+1) = V(i) + dV*dt;

    % Update all values
    gamma(i+1) = atand(vy(i+1)/vx(i+1));
    h(i+1) = h(i) + vy(i)*dt;
    x(i+1) = x(i) + vx(i)*dt;
    t(i+1) = t(i) + dt;
    W(i+1) = W(i);

    % Determine if Climb is finished
    if h(i) >= mission.cruise.h || i > 5000
        exitflag = 0;
    elseif h(i) < 0
        warning('Takeoff Climb, h < 0 ft');
        break;
    else
        i = i + 1;
    end

end

% Trim last updated index
gamma = gamma(1:end-1);  V = V(1:end-1);
vx = vx(1:end-1); vy = vy(1:end-1);
h = h(1:end-1); x = x(1:end-1); t = t(1:end-1);
dth = dth(1:end-1); W = W(1:end-1);
Q_used = Q_used(1:end-1); battery_pct = battery_pct(1:end-1);



%% Plotting

figure;   % takeoff trajecotry
subplot(2,2,1);
sgtitle('Climb Summary');
plot(x,h,'LineWidth',1.5);
grid on; hold on;
xlabel('X Distance (ft)'); ylabel('Altitude (ft)');
title('Climb Trajectory');


% figure;   % force summary
subplot(2,2,2);
plot(t,T,'LineWidth',1.5,'DisplayName','Thrust');
grid on; hold on; 
plot(t,L,'LineWidth',1.5,'DisplayName','Lift');
plot(t,D,'LineWidth',1.5,'DisplayName','Drag');
plot(t,W,'LineWidth',1.5,'DisplayName','Weight');
xlabel('time (sec)'); ylabel('Force (lbs)');
title('Climb Force Time History');
legend('show','location','southwest');


% figure;   % angle summary
subplot(2,2,3);
plot(t,alpha,'LineWidth',1.5,'DisplayName','\alpha');
grid on; hold on; 
plot(t,gamma,'LineWidth',1.5,'DisplayName','\gamma');
xlabel('Time (sec)'); ylabel('Angle (deg)');
title('Climb Angle Time Hisotry');
legend('show','location','northwest');


% figure;   % Velocity Time History
subplot(2,2,4);
plot(t,vx,'LineWidth',1.5,'DisplayName','V_{x}');
grid on; hold on;
plot(t,vy,'LineWidth',1.5,'DisplayName','RC');
plot(t,V,'LineWidth',1.5,'DisplayName','V');
xlabel('Time (sec)'); ylabel('Velocity (ft/s)');
title('Climb Velocity Time History');
legend('show','location','southeast');


%% Package Takeoff Outputs

mission.climb.t_hist = [t; x; h; vx; vy; V; gamma; Q_used; battery_pct]';



end

