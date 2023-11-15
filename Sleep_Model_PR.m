%% Code for solving the Phillips-Robinson model of the sleep/wake switch, sleep homeostatic process, and circadian pacemaker

% Inputs to the model are light (defined in light_func) and choice of model
% parameters (p). The circadian pacemaker used is a modifed forced van der
% Pol oscillator (Forger 1999). 
% Outputs of the model are the model variables for the sleep/wake switch,
% sleep homeostatic proccss, and circadian pacemaker.

% based on code provided by AJK Phillips

% L Webb
% 2023

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


adult_out = Run_pr_2023(x0,T,p);
child_out = Run_pr_2023(x0,T,p_child);

%% sleep time series results of interest

adult_res = Get_sleep_results_2023(adult_out);
child_res = Get_sleep_results_2023(child_out);

%% Illustrative plot of time series snapshot

figure
subplot(2,1,1);
plot(adult_out(1,adult_out(1,:) < (min(adult_out(1,:)) + 48)) - min(adult_out(1,:)), adult_out(10,adult_out(1,:) < (min(adult_out(1,:)) + 48)));
xlabel("Time");xticks([0:6:48]);xticklabels(["12am" "6am" "12pm" "6pm" "12am" "6am" "12pm" "6pm" "12am"]);
ylabel("Arousal State"); ylim([-0.1 1.1]); yticks([0 1]); yticklabels(["Sleep" "Wake"]);
title("Adult illustrative case")
subplot(2,1,2);
plot(child_out(1,child_out(1,:) < (min(child_out(1,:)) + 48)) - min(child_out(1,:)), child_out(10,child_out(1,:) < (min(child_out(1,:)) + 48)));
xlabel("Time");xticks([0:6:48]);xticklabels(["12am" "6am" "12pm" "6pm" "12am" "6am" "12pm" "6pm" "12am"]);
ylabel("Arousal State"); ylim([-0.1 1.1]); yticks([0 1]); yticklabels(["Sleep" "Wake"]);
title("Infant illustrative case")

