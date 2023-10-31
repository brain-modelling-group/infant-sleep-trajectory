%% Code for solving the combined Phillips-Forger model of the sleep/wake switch, sleep homeostatic process, and circadian pacemaker

% Inputs to the model are light (defined in light_func) and choice of model
% parameters (p).
% Outputs of the model are the model variables for the sleep/wake switch,
% sleep homeostatic proccss, and circadian pacemaker.

% based on code provided by AJK Phillips

% L Webb

%% Specify simulation settings

numdays = 35;

T = numdays*24; % max time (h) to simulate, output is last two weeks

x0 = [0.6,-6.7,14.6,0.35,-0.86,-0.59]'; % initial conditions (Vm,Vv,H,n,x,xc)

%% Define model parameter values
% p - Values from Skeldon et al. (2017) (adult values, not including an 
% enforced wake schedule)
%
% p_child - Example values from Webb et al. (2023) (infant values)

sph = 3600; % seconds per hour (for unit conversions)

% sleep/wake switch parameters
p{1} = sph/10; % 1/tau_v=1/tau_m
p{2} = -1.8/sph; % numv
p{3} = 1.3; % A
p{4} = -2.1/sph; % nuvm
p{5} = 1.0; % nuvh
p{6} = -3.37; % nuvc
p{7} = -10.2; % D_0
p{8} = 1/45; %1/45; % 1/chi
p{9} = 4.20/sph; % mu

% light processing parameters
p{10} = 0.16; % alpha0
p{11} = 9500; % I0
p{12} = 0.6; % p
p{13} = 0.4; % b
p{14} = 19.9; % G
p{15} = 60; % lambda
p{16} = 0.013; % beta

% circadian pacemaker parameters
tauc = 24.2; % Define intrinsic circadian period (h)
p{17} = pi/12; %1/kappa
p{18} = 0.23; %gamma
p{19} = 4/3; % coefficient for x^3 term
p{20} = (24/(0.99669*tauc))^2; % tau term
p{21} = 0.55; % k

% p_child values (day 180, Dataset 1, Figure 3 in Webb et al. (2023))
p_child = p;
p_child{6} = -3.25; % nuvc
p_child{8} = 1/exp(3.5); %1/45; % 1/chi
p_child{9} = 7.80/sph; % mu
p_child{13} = 0.9; % b


adult_out = Run_prf_2023(x0,T,p);
child_out = Run_prf_2023(x0,T,p_child);

%% sleep time series results of interest

adult_res = Get_sleep_results_2023(adult_out);
child_res = Get_sleep_results_2023(child_out);


