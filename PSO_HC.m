
c1 = 1.2;
c2 = 0.12;
iterations = 10;
inertia = 0.9;
correction_factor = 1.0;
swarms = 10;

swarm = zeros(swarms,13);
step = 1;
for i = 1:swarms
    swarm(step, 1) = 100; %kp
    swarm(step,2) = 50; %ki
    swarm(step,3 ) = 50; %wc
    swarm(step,4) = 30;
    swarm(step,13) =  10e+20;
    step = step + 1; 
end
history = zeros(iterations,1);
swarm(:,9:12) = 3.5;
X_best = [0.3;150;1;1/15];
for iter = 1:iterations
    for i = 1:swarms
        swarm(i, 1) = swarm(i, 1) + swarm(i, 9);  %update u position
        swarm(i, 2) = swarm(i, 2) + swarm(i, 10) ;    %update v position
        swarm(i, 3) = swarm(i, 3) + swarm(i, 11) ;
        swarm(i, 4) = swarm(i, 4) + swarm(i, 12) ;
        K_h5 = swarm(i,1);
        K_h7 = swarm(i,2);
        K_h9 = swarm(i,3);
        K_h11 = swarm(i,4);
        out = sim('Simulation_5thJune.slx',0.3);
        x = phase1.signals.values;
        x(1:26000) = [];
        y = phase2.signals.values;
        y(1:26000) = [];
        z = phase3.signals.values;
        z(1:26000) = [];
        THD1 = thd(x);
        t = phase1.time;
        t(1:26000) = [];
        xref = 220*sqrt(2)*sin(2*pi*50*t);
        yref = 220*sqrt(2)*sin(2*pi*50*t - 120);
        zref = 220*sqrt(2)*sin(2*pi*50*t + 120);
        %f = figure;
        %hold on
        %plot(out.phase1.time,x);
        %plot(out.phase1.time,xref);
        value = 100*sum((x-xref).^2+ (y-yref).^2+(z-zref).^2);
        %value = 100*(abs(thd(x)+abs(thd(y))+abs(thd(z))));
        if value < swarm(i,13)
            swarm(i,5) = swarm(i,1); 
            swarm(i,6) = swarm(i,2);
            swarm(i,7) = swarm(i,3); 
            swarm(i,8) = swarm(i,4);
            swarm(i,13) = value;
        end
    end
    [temp,gbest] = min(swarm(:,13));
    history(iter,1) = swarm(gbest,13)
    swarm(gbest, 5)
    swarm(gbest, 6)
    swarm(gbest, 7)
    swarm(gbest, 8)
    for i = 1 : swarms
        swarm(i, 9) = inertia*swarm(i, 9) + c1*rand*(swarm(i, 5)...
            - swarm(i, 1)) + c2*rand*(swarm(gbest, 5) - swarm(i, 1));   
        swarm(i, 10) = inertia*swarm(i, 10) + c1*rand*(swarm(i, 6)...
            - swarm(i, 2)) + c2*rand*(swarm(gbest, 6) - swarm(i, 2)); 
        swarm(i, 11) = inertia*swarm(i, 11) + c1*rand*(swarm(i, 7)...
            - swarm(i, 3)) + c2*rand*(swarm(gbest, 7) - swarm(i, 3));
        swarm(i, 12) = inertia*swarm(i, 12) + c1*rand*(swarm(i, 8)...
            - swarm(i, 4)) + c2*rand*(swarm(gbest, 8) - swarm(i, 4));
    end
    %%Ploting
end
