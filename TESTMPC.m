clear all; clc

plantTF = tf({1,1,1},{[1 .5 1],[1 1],[.7 .5 1]}); % define and display tf object

plantCSS = ss(plantTF);         % transfer function to continuous state space
Ts = 0.2;                       % specify a sample time of 0.2 seconds
plantDSS = c2d(plantCSS,Ts);     % convert to discrete-time state space, using ZOH

plantDSS = setmpcsignals(plantDSS,'MV',1,'MD',2,'UD',3); % specify signal types

mpcobj = mpc(plantDSS,Ts,10,3);

mpcobj.MV = struct('Min',0,'Max',1,'RateMin',-10,'RateMax',10);

getindist(mpcobj);

getoutdist(mpcobj);

mpcobj.Model.Disturbance = tf(sqrt(1000),[1 0]);

DC = cloffset(mpcobj);
fprintf('DC gain from output disturbance to output = %5.8f (=%g) \n',DC,DC);

Tstop = 30;                               % simulation time
Nf = round(Tstop/Ts);                     % number of simulation steps
r = 1*ones(Nf,1);                           % output reference signal
v = [zeros(Nf/3,1);ones(2*Nf/3,1)];       % measured input disturbance signal

sim(mpcobj,Nf,r,v)      % simulate plant and controller in closed loop

SimOptions = mpcsimopt;  

d = [zeros(2*Nf/3,1);-0.5*ones(Nf/3,1)];      % step disturbance
SimOptions.UnmeasuredDisturbance = d;         % unmeasured input disturbance

SimOptions.OutputNoise=.001*(rand(Nf,1)-.5);  % output measurement noise
SimOptions.InputNoise=.05*(rand(Nf,1)-.5);    % noise on manipulated variables

[y,t,u,xp] = sim(mpcobj,Nf,r,v,SimOptions);

figure                                  % create new figure

subplot(2,1,1)                          % create upper subplot
plot(0:Nf-1,y,0:Nf-1,r)                 % plot plant output and reference
title('Output')                         % add title so upper subplot
ylabel('MO1')                           % add a label to the upper y axis
grid                                    % add a grid to upper subplot

subplot(2,1,2)                          % create lower subplot
plot(0:Nf-1,u)                          % plot manipulated variable
title('Input');                         % add title so lower subplot
xlabel('Simulation Steps')              % add a label to the lower x axis
ylabel('MV1')                           % add a label to the lower y axis
grid                                    % add a grid to lower subplot


