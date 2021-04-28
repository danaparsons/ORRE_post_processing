%% ------------------------------ Header ------------------------------- %%
% Filename:     ORRE_post_processing.m
% Description:  ORRE Post Processing Program input file (test)
% Authors:      D. Lukas and J. Davis
% Created on:   6-10-20
% Last updated: 8-9-20 by J. Davis
%% --------------------------- Settings -------------------------------- %%

close all % close any open figures

% Define inputs:
directory = "C:\Users\orre2\Desktop\OSWEC_inertia\";     % current directory
filename = "run1.txt";
datatype = 1;
ntaglines = 12;
nheaderlines = 1;
tagformat = '%s';
headerformat = '%s';
dataformat =  '%f';
headerdelimiter = char(9); %tab
datadelimiter = ' ';
commentstyle = '%';

data.run1 = pkg.fun.read_data(directory,"run1.txt",datatype,ntaglines,...
    nheaderlines,tagformat,headerformat,dataformat,headerdelimiter,datadelimiter,commentstyle);

data.run2 = pkg.fun.read_data(directory,"run2.txt",datatype,ntaglines,...
    nheaderlines,tagformat,headerformat,dataformat,headerdelimiter,datadelimiter,commentstyle);

data.run3 = pkg.fun.read_data(directory,"run3.txt",datatype,ntaglines,...
    nheaderlines,tagformat,headerformat,dataformat,headerdelimiter,datadelimiter,commentstyle);

dominant_periods = zeros(3,1);

for num = 1:3
    run = ['run',num2str(num)];
    phi0 = data.(run).ch2(data.(run).ch2 == min(data.(run).ch2));
    t0   = data.(run).ch1(data.(run).ch2 == phi0);
    t    = data.(run).ch1(data.(run).ch1 >= t0)-t0;
    phi_raw  = data.(run).ch2(data.(run).ch1 >= t0); phi_raw = phi_raw-mean(phi_raw(end-100:end));

    % filter
    %phi_f = bandpass(phi,[.8,1.2],(2*10^-3)^(-1));
    [phi,filter] = lowpass(phi_raw,1,(2*10^-3)^(-1),'Steepness',0.95);
plot(t,phi)
    [f1,P1,dominant_periods(num)] = pkg.fun.plt_fft(t,phi_raw); hold on
    [f2,P2] = pkg.fun.plt_fft(t,phi);

    figure
        semilogx(f1,P1,'DisplayName','Original'); hold on
        semilogx(f2,P2,'DisplayName','Filtered'); 
        legend()
        xlabel('f(Hz)')
        ylabel('P1')

    figure
        plot(t,phi_raw,'DisplayName','Original'); hold on
        plot(t,phi,'DisplayName','Filtered')
        legend()
        xlabel('t(s)')
        ylabel('phi(deg)')
end

Tn_mean = mean(dominant_periods)
Tn_stdev = std(dominant_periods)