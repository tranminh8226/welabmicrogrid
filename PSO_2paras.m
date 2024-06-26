
c1 = 1.2;
c2 = 0.12;
iterations = 40;
inertia = 0.9;
correction_factor = 1.0;
swarms = 10;
swarm = zeros(swarms,7);
step = 1;
for i = 1:swarms
    swarm(step, 1) = 1.35e-3/2; %L_f
    swarm(step,2) = 100e-6; %C_f
    swarm(step,7) =  10e+11;
    step = step + 1; 
end
history = zeros(iterations,1);
swarm(:,5) = 1.35e-3*0.1;
swarm(:,6) = 50e-6*0.1;
X_best = [1.35e-3;50e-6];
for iter = 1:iterations
    for i = 1:swarms
        swarm(i, 1) = swarm(i, 1) + swarm(i, 5);  %update u position
        swarm(i, 2) = swarm(i, 2) + swarm(i, 6) ;    %update v position
        L_f = swarm(i,1);
        C_f = swarm(i,2);
        out = sim('Simulation_18thJune',0.1);
        x = phase1.signals.values;
        x(1:4000) = [];
        y = phase2.signals.values;
        y(1:4000) = [];
        z = phase3.signals.values;
        z(1:4000) = [];
        THD1 = thd(x);
        t = phase1.time;
        t(1:4000) = [];
        xref = 220*sqrt(2)*sin(2*pi*50*t);
        yref = 220*sqrt(2)*sin(2*pi*50*t - 120);
        zref = 220*sqrt(2)*sin(2*pi*50*t + 120);
        %f = figure;
        %hold on
        %plot(out.phase1.time,x);
        %plot(out.phase1.time,xref);
        value = 100*sum((x-xref).^2+ (y-yref).^2+(z-zref).^2);
        %value = 100*(abs(thd(x)+abs(thd(y))+abs(thd(z))));
        if value < swarm(i,7)
            swarm(i,3) = swarm(i,1); 
            swarm(i,4) = swarm(i,2);
            swarm(i,7) = value;
        end
    end
    [temp,gbest] = min(swarm(:,7));
    history(iter,1) = swarm(gbest,7)
    swarm(gbest, 3)
    swarm(gbest, 4)
    for i = 1 : swarms
        swarm(i, 5) = inertia*swarm(i, 5) + c1*rand*(swarm(i, 3)...
            - swarm(i, 1)) + c2*rand*(swarm(gbest, 3) - swarm(i, 1));   
        swarm(i, 6) = inertia*swarm(i, 6) + c1*rand*(swarm(i, 4)...
            - swarm(i, 2)) + c2*rand*(swarm(gbest, 4) - swarm(i, 2)); 
    end
    %%Ploting
end
