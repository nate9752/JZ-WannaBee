function mission = calcTakeoff(aircraft,mission,atmosphere)
%
%
%
%

%% Initialize

W = aircraft.weight.sum;
S = aircraft.geom.wing.Sref;

takeoff_type = mission.takeoff.type;
propMap = aircraft.engine.propMap;

vx0 = mission.takeoff.vx0;
vy0 = mission.takeoff.vy0;

h0 = mission.takeoff.h0;
x0 = 0;

gamma0 = 0;
t0 = 0;




dt = 0.01;
exitflag = 1;
i = 1;

while exitflag
    
    if i == 1
        vx(1) = vx0; vy(1) = vy0; V(1) = norm([vx0 vy0]);
        x(1) = x0; h(1) = h0;
        t(1) = t0; gamma(1) = gamma0;
    end

    

    % Need a section loading aero props
    % cl(i) = interp(cl,alphavec,gamma(i));
    % cd(i) = interp(cl,alphavec,gamma(i));
    % 
    % rho_h = interp1(atmosphere.rho,atmosphere.h,h(i));
    %
    % % Calculate Forces
    % L = 1/2 * rho_h * V(i)^2 * S * cl(i);
    % D = 1/2 * rho_h * V(i)^2 * S * cd(i)
    % [T(i), energyProps(i)] = calcEngine(throttle,aircraft.engine.propMap);
    % 
    % % Sum forces
    % Fx = T*cosd(gamma(i)) - D*cosd(gamma(i)); - L*sin(gamma(i)) <-- logic for negative alpha
    % Fy = L*cosd(gamma(i)) - W + T*sind(gamma(i)) - D*sind(gamma(i));
    %
    % % F = m*a
    % ax = Fx / (W/32.17405);
    % ay = Fy / (W/32.17405);
    % 
    % % Update Velocities
    % dVx = ax * dt;
    % dVy = ay * dt;
    % vx(i+1) = vx(i) + dVx;
    % vy(i+1) = vy(i) + dVy;
    %
    % % Update all values
    % V(i+1) = norm([vx(i+1) vy(i+1]);
    % alpha(i+1) = atand(vy(i+1) / vx(i+1));
    % h(i+1) = h(i) + vy(i)*dt;
    % x(i+1) = x(i) + vx(i)*dt;
    % t(i+1) = t(i) + dt;

    if h(i) > 10
        exitflag = 0;
    else
        i = i + 1;
    end

end


end