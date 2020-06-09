function [dominant_period] = plt_fft(t,y,fs)
%PLT_FFT Summary of this function goes here
%   Detailed explanation goes here


Y = fft(y);
L = length(y);

if nargin < 3 || isempty(fs)
    Fs = mean(diff(t))^-1;
else
    Fs = fs;
end 

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
fft_fig = figure;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

[pk_fft, loc_fft]= findpeaks(P1,f);
dominant_period = loc_fft(pk_fft == max(pk_fft))^-1;
end

