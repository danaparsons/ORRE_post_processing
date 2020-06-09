% test of folder structurr (needs work!)

fs = 128
f = 2 % hz
tf = 2*f^-1
n = fs*tf
t = linspace(0,tf-fs^-1,n)


x = sin(2*pi*f*t)

plot(t,x,...
    t,x,'o'); hold on
plot(t+tf,x,...
    t+tf,x,'o')

[T] = pkg.fun.plt_fft(t,x)

[T2] = pkg.fun.plt_fft(t,x,fs)