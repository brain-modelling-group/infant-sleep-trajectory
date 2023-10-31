function dy = phillips_forger_model_2023(t,y,p)
% Define differential equations for combined sleep-circadian model.
% Equations from Skeldon et al. (2017)
% Based on code from AJK Phillips

% Variables: y(1) = Vm, y(2) = Vv, y(3) = H, y(4) = n, y(5) = x, y(6) = xc

% define circadian input to VLPO
C = 0.5*(1+0.80*y(6)-0.47*y(5));

I = light_func(t).*(y(1)>y(2)); % define light level (filtering by sleep/wake state)
% light function min/max and other parameters assigned in light_func.m function

alpha = p{10}*(I/p{11}).^p{12}; % define alpha (retinal activation rate)
B = (1-p{13}*y(5)).*(1-p{13}*y(6))*p{14}*alpha*(1-y(4)); % define B (retinal drive to pacemaker)

% Define the differential equations:
dy = [p{1}*(-y(1) + p{2}*sigmoid(y(2)) + p{3});
      p{1}*(-y(2) + p{4}*sigmoid(y(1)) + p{5}*y(3) + p{6}*C + p{7});
      p{8}*(-y(3) + p{9}*sigmoid(y(1)));
      p{15}*(alpha*(1-y(4))-p{16}*y(4));
      p{17}*(p{18}*(y(5)-p{19}*y(5).^3)-y(6)*(p{20}+p{21}*B));
      p{17}*(y(5)+B)];
% sigmoid.m function assigns the values of the three parameters in sigmoid
% function: Qmax, theta, and sigma
end