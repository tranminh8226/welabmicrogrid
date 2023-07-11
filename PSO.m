
c1 = 1.2/10;
c2 = 0.12/10;
iterations = 30;
inertia = 0.9;
correction_factor = 1.0;
swarms = 10;

swarm = zeros(swarms,10);
step = 1;
for i = 1:swarms
    swarm(step, 1) = 1; %kp
    swarm(step,2) = 150; %ki
    swarm(step,3 ) = 2; %wc
    swarm(step,10) =  10e+30;
    step = step + 1; 
end
history = zeros(iterations,1);
swarm(:,7) = 0.05;
swarm(:,8) = 0.5;
swarm(:,9) = 0.05;
X_best = [0.3;150;1];
for iter = 1:iterations
    for i = 1:swarms
        swarm(i, 1) = swarm(i, 1) + swarm(i, 7);  %update u position
        swarm(i, 2) = swarm(i, 2) + swarm(i, 8) ;    %update v position
        swarm(i, 3) = swarm(i, 3) + swarm(i, 9) ;
        Kp_pr = swarm(i,1);
        ki_pr = swarm(i,2);
        wc_pr = swarm(i,3);
        out = sim('Simulation_18thJune.slx',0.5);
        x = phase1.signals.values;
        x(1:20000) = [];
        y = phase2.signals.values;
        y(1:20000) = [];
        z = phase3.signals.values;
        z(1:20000) = [];
        THD1 = thd(x);
        t = phase1.time;
        t(1:20000) = [];
        xref = 220*sqrt(2)*sin(2*pi*50*t);
        yref = 220*sqrt(2)*sin(2*pi*50*t - 120);
        zref = 220*sqrt(2)*sin(2*pi*50*t + 120);
        %f = figure;
        %hold on
        %plot(out.phase1.time,x);
        %plot(out.phase1.time,xref);
        value = 100*sum((x-xref).^2+ (y-yref).^2+(z-zref).^2)
        %value = 100*(abs(thd(x)+abs(thd(y))+abs(thd(z))));
        if value < swarm(i,10)
            swarm(i,4) = swarm(i,1); 
            swarm(i,5) = swarm(i,2);
            swarm(i,6) = swarm(i,3); 
            swarm(i,10) = value;
        end
    end
    [temp,gbest] = min(swarm(:,10));
    history(iter,1) = swarm(gbest,10)
    swarm(gbest, 4)
    swarm(gbest, 5)
    swarm(gbest, 6)
    for i = 1 : swarms
        swarm(i, 7) = inertia*swarm(i, 7) + c1*rand*(swarm(i, 4)...
            - swarm(i, 1)) + c2*rand*(swarm(gbest, 5) - swarm(i, 1));   
        swarm(i, 8) = inertia*swarm(i, 9) + c1*rand*(swarm(i, 5)...
            - swarm(i, 2)) + c2*rand*(swarm(gbest, 6) - swarm(i, 2)); 
        swarm(i, 9) = inertia*swarm(i, 9) + c1*rand*(swarm(i, 7)...
            - swarm(i, 3)) + c2*rand*(swarm(gbest, 7) - swarm(6, 3));
    end
    %%Ploting
end
