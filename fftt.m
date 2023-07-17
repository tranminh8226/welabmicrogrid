Fs = 1/(1e-5);            % Sampling frequency                    
T = 1/Fs;             % Sampling period  
x = phase1.signals.values;
x(1:60000) = [];
L = length(x)-1;             % Length of signal
t = (0:L-1)*T;        % Time vector


Y = fft(x);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
thd(x,Fs)
%%
plot(1000*t(1:2000),x(1:2000))
%%
f = Fs*(0:(L/2))/L;
plot(f(1:100),P1(1:100),'*');
title("Single-Sided Amplitude Spectrum of X(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")
