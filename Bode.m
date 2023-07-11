x = phase1.signals.values;
x(1:14000) = [];
x
thd(x)  

%%
%num = [-K_h5*3 0];
%denum = [1 2*3 w_nom*w_nom*25];
%h = tf(num,denum)
%[gm pm wcp wcg] = margin(h)
%bode(h)