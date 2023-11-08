function out = Run_prf_2023(x0,T,p)
    %% Solve the differential equations
    % x0 is initial conditions
    % T is maximum time to solve for in hours
    % p is model parameters

    % Solve from initial conditions pre-specified (x0)
    [~,Y] = ode23s(@phillips_forger_model_2023,[0,4*7*24],x0',odeset,p); % This uses 4 weeks to remove transients
    Y=Y'; % Transpose of Y
    disp('Finished transient')
    
    % Remove transient and solve again
    x0 = Y(:,end);
    sol = ode23s(@phillips_forger_model_2023,[0,T],x0',odeset,p);
    disp('Finished simulation')
    
    % extracting last two weeks, from t0 to T
    t0 = T-(2*7*24); %
    t = [t0:0.01:T];Y = deval(sol,t);
    
    Vm = Y(1,:); % Voltage of MA population
    Vv = Y(2,:); % Voltage of VLPO population
    H = Y(3,:); % Homeostatic variable
    n = Y(4,:); % Photoreceptors
    x = Y(5,:); % Pacemaker variable 1
    xc = Y(6,:); % Pacemaker variable 2
    C = 0.5*(1+0.80*xc-0.47*x); % Circadian drive
    Dv = p{5}*H + p{6}*C + p{7}; % Overall drive to VLPO

    state = Vm>Vv; % Define sleep/wake state (1=wake, 0=sleep)
    
    out = [t; Vm; Vv; H; n; x; xc; C; Dv; state]; % output matrix


end 