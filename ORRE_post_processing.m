% test of folder structurr (needs work!)

fs = 128;
f = 2; % hz
tf = 2*f^-1;
n = fs*tf;
t = linspace(0,tf-fs^-1,n);
x = sin(2*pi*f*t);

signal = pkg.obj.signalClass(t,x); % test constructor without period T
% signal = pkg.obj.signalClass(t,x,f^-1) % with T 

plot(signal.t,signal.x,...
    signal.t,signal.x,'o'); hold on
plot(signal.t+tf,signal.x,...
    signal.t+tf,signal.x,'o')

signal.T = pkg.fun.plt_fft(signal.t,signal.x); % test without providing fs

signal

% signal.T = pkg.fun.plt_fft(signal.t,signal.x,fs) % with fs