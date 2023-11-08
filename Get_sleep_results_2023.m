function results = Get_sleep_results_2023(output)
% output contains 2 weeks of model time series
% output is the output from Run_prf_2023.m

% get time period being assessed
assess = output; 

assess_state = assess(10,:); % state time series
assess_time = assess(1,:) - min(assess(1,:)); % state time zeroed 
% (first timpoint should be mulitple of 24 hours, but are zeroing)

sleepon_t = assess_time(diff(assess_state)==-1); % sleep on times
sleepoff_t = assess_time(diff(assess_state)==1); % slepe off times

% number of bouts 
num_bout_avg = (size(sleepon_t,2) + size(sleepoff_t,2))/2/14; 
% /2 for average between sleepon_t and sleepoff_t size
% /14 for 2 weeks

% note sampled time goes from 0 hours to 0 hours
% to avoid bias, go from index 2 to end to have equal
assess_state_bal = assess_state(2:end);

% sleep
propsleep = sum(assess_state_bal == 0)/length(assess_state_bal); % proportion sleep
propwake = sum(assess_state_bal == 1)/length(assess_state_bal); % proportion wake

% night sleep - night time defined from 7pm to 8am
assess_time_clock = mod(assess_time,24);
assess_time_clock(assess_time_clock == 0) = 24;
assess_time_clock_bal = assess_time_clock(2:end);

propnightsleep = sum(assess_state_bal(assess_time_clock_bal < 8 | assess_time_clock_bal > 19) == 0)/length(assess_state_bal(assess_time_clock_bal < 8 | assess_time_clock_bal > 19));

% naps - number and average length
assess_time_day = ceil(((assess_time(2:end))/24));
assess_time_clock_daytime = assess_time_clock_bal(assess_time_day == 1 & assess_time_clock_bal >= 8 & assess_time_clock_bal <= 19);

naps = zeros(1,14);
nap_length = zeros(1,14);

for day = unique(assess_time_day)
    assess_state_bal_day = assess_state_bal(assess_time_day == day & assess_time_clock_bal >= 8 & assess_time_clock_bal <= 19);
    
    sleepon_day_t = assess_time_clock_daytime(diff(assess_state_bal_day)==-1);
    sleepoff_day_t = assess_time_clock_daytime(diff(assess_state_bal_day)==1);
    
    % if there is either no sleep on or sleep off in the day period
    if isempty(sleepon_day_t) || isempty(sleepoff_day_t)
        naps(day) = 0;
        nap_length(day) = 0;
    %  if first switch is sleep on and last switch is sleep off
    elseif sleepon_day_t(1) < sleepoff_day_t(1) && sleepoff_day_t(end) > sleepon_day_t(end) && length(sleepon_day_t) == length(sleepoff_day_t)
        naps(day) = length(sleepon_day_t);
        nap_length(day) = mean(sleepoff_day_t - sleepon_day_t);
    % if first switch is sleep on and last is sleep on 
    elseif sleepon_day_t(1) < sleepoff_day_t(1) && sleepoff_day_t(end) < sleepon_day_t(end)
        naps(day) = length(sleepoff_day_t);
        nap_length(day) = mean(sleepoff_day_t - sleepon_day_t(1:(end-1)));
    % if first switch is sleep off and last is sleep on
    elseif sleepon_day_t(1) > sleepoff_day_t(1) && sleepoff_day_t(end) < sleepon_day_t(end) && length(sleepon_day_t) == length(sleepoff_day_t)
        naps(day) = length(sleepon_day_t) - 1;
        nap_length(day) = mean(sleepoff_day_t(2:end) - sleepon_day_t(1:(end-1)));
    % if first switch is sleep off and last is sleep off
    elseif sleepon_day_t(1) > sleepoff_day_t(1) && sleepoff_day_t(end) > sleepon_day_t(end)
        naps(day) = length(sleepon_day_t);
        nap_length(day) = mean(sleepoff_day_t(2:end) - sleepon_day_t);
    else
        fprintf('error nap calc')
    end 

end

nap_avg = mean(naps);
nap_len_avg = mean(nap_length);
nap_len_max = max(nap_length);

% night wakings

assess_time_clock_nighttime = [assess_time_clock(assess_time_day == 1 & assess_time_clock_bal > 19) assess_time_clock_bal(assess_time_day == 1  & assess_time_clock_bal < 8)];
nghtwks = zeros(1,13);
unidays = unique(assess_time_day);

for day = unidays(1:end-1)
    assess_state_bal_nght = assess_state_bal((assess_time_day == day & assess_time_clock_bal > 19) | (assess_time_day == (day + 1) & assess_time_clock_bal < 8 ));
    
    sleepon_nght_t = assess_time_clock_nighttime(diff(assess_state_bal_nght)==-1);
    sleepoff_nght_t = assess_time_clock_nighttime(diff(assess_state_bal_nght)==1);
    
    % add 24 to morning times for better math
    sleepon_nght_t(sleepon_nght_t<19) = sleepon_nght_t(sleepon_nght_t<19) + 24;
    sleepoff_nght_t(sleepoff_nght_t<19) = sleepoff_nght_t(sleepoff_nght_t<19) + 24;
    
    % if there is either no sleep on or sleep off in the night period
    if isempty(sleepon_nght_t) || isempty(sleepoff_nght_t)
        nghtwks(day) = 0;
    %  if first switch is sleep on and last switch is sleep off
    elseif sleepon_nght_t(1) < sleepoff_nght_t(1) && sleepoff_nght_t(end) > sleepon_nght_t(end) && length(sleepon_nght_t) == length(sleepoff_nght_t)
        nghtwks(day) = length(sleepon_nght_t) - 1;
    % if first switch is sleep on and last is sleep on 
    elseif sleepon_nght_t(1) < sleepoff_nght_t(1) && sleepoff_nght_t(end) < sleepon_nght_t(end)
        nghtwks(day) = length(sleepoff_nght_t);
    % if first switch is sleep off and last is sleep on
    elseif sleepon_nght_t(1) > sleepoff_nght_t(1) && sleepoff_nght_t(end) < sleepon_nght_t(end) && length(sleepon_nght_t) == length(sleepoff_nght_t)
        nghtwks(day) = length(sleepoff_nght_t);
    % if first switch is sleep off and last is sleep off
    elseif sleepon_nght_t(1) > sleepoff_nght_t(1) && sleepoff_nght_t(end) > sleepon_nght_t(end)
        nghtwks(day) = length(sleepon_nght_t);
    else
        fprintf('error night wake calc')
    end 
end

night_wake_avg = mean(nghtwks);

% average bout length

% if there is either no sleep on or sleep off 

if isempty(sleepon_t) || isempty(sleepoff_t)
    bout_avg_len = 0;
    bout_avg_max = 0;
% if only one of each and sleep off is first
elseif length(sleepon_t) == 1 && length(sleepoff_t) == 1 && sleepon_t(1) > sleepoff_t(1)
    bout_avg_len = 0;
    bout_avg_max = 0;
% if first switch is sleep on and last switch is sleep off
elseif sleepon_t(1) < sleepoff_t(1) && sleepoff_t(end) > sleepon_t(end)
    bout_avg_len = mean(sleepoff_t - sleepon_t);
    bout_avg_max = max(sleepoff_t - sleepon_t);
% if first swtich is sleep on and last switch is sleep on
elseif sleepon_t(1) < sleepoff_t(1) && sleepoff_t(end) < sleepon_t(end)
    bout_avg_len = mean(sleepoff_t - sleepon_t(1:(end-1)));
    bout_avg_max = max(sleepoff_t - sleepon_t(1:(end-1)));
% if first switch is sleep off and last switch is sleep on
elseif sleepon_t(1) > sleepoff_t(1) && sleepoff_t(end) < sleepon_t(end)
    bout_avg_len = mean(sleepoff_t(2:end) - sleepon_t(1:(end-1)));
    bout_avg_max = max(sleepoff_t(2:end) - sleepon_t(1:(end-1)));
% if first switch is sleep off and last switch is sleep off
elseif sleepon_t(1) > sleepoff_t(1) && sleepoff_t(end) > sleepon_t(end)
    bout_avg_len = mean(sleepoff_t(2:end) - sleepon_t);
    bout_avg_max = max(sleepoff_t(2:end) - sleepon_t);
end

%% homeostatic drive dynamics

% Hmin
Hmin = min(assess(4,:));
% Hmax
Hmax = max(assess(4,:));
% Hmean
Hmean = mean(assess(4,:));

% Last seven days for probs
time_clock = assess_time_clock_bal(assess_time_day > (max(assess_time_day) - 7));
time_day = assess_time_day(assess_time_day > (max(assess_time_day) - 7));

time_series_state = assess_state_bal(assess_time_day > (max(assess_time_day) - 7));

% make half hour bins of clock time
time_half_hour = ordinal(time_clock, {},...
    [], [0.0001:0.5:24.0001]);
% assign half hour windows based on output
HH = findgroups(time_half_hour);
% get prob of being awake per half hour bin, averaged across 7 days
wake_probs = splitapply(@mean,time_series_state,HH);
% get probability of being asleep
sleep_probs = 1 - wake_probs;


% pacemaker period
assess_xc_bal = assess(7,2:end); % xc
assess_x_bal = assess(6,2:end); % x
phi = unwrap(atan2(assess_xc_bal,assess_x_bal)); % phi
slope = (phi(end) - phi(1))/(max(assess_time) - min(assess_time));
tau_obs = 2*pi/slope; % tau_obs

    
    
    

%% all results 

results = cell(1,16);
results{1,1} = propsleep*24;      % average amount of sleep per day (hours)
results{1,2} = num_bout_avg;      % average number of bouts per day
results{1,3} = propnightsleep*13; % average amount of nighttime sleep (hours)
results{1,4} = nap_avg;           % average number of naps per day
results{1,5} = night_wake_avg;    % average number of nighttime wakings
results{1,6} = nap_len_avg;       % average nap length
results{1,7} = nap_len_max;       % maximum nap length
results{1,8} = bout_avg_len;      % average sleep bout length
results{1,9} = bout_avg_max;      % maximum sleep bout length

results{1,10} = sleepon_t;        % times of sleep onset
results{1,11} = sleepoff_t;       % times of wake onset

results{1,12} = Hmin;             % minimum of homeostatic drive
results{1,13} = Hmax;             % maximum of homeostatic drive
results{1,14} = Hmean;            % mean average homeostatic drive

results{1,15} = sleep_probs;      % sleep probabilities

results{1,16} = tau_obs;          % pacemaker period

end 