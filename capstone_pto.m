%% ------------------------------ Header ------------------------------- %%
% Filename:     ORRE_post_processing.m
% Description:  ORRE Post Processing Program input file (test)
% Authors:      D. Lukas and J. Davis
% Created on:   6-10-20
% Last updated: 8-9-20 by J. Davis
%% ------------------------------------ -------------------------------- %%

close all % close any open figures

% Define inputs:
directory = "data\capstone_pto\";     % current directory
filename = "capstone_pto_angularpos.txt";
datatype = 1;
ntaglines = 11;
nheaderlines = 1;
tagformat = '%s';
headerformat = '%s';
dataformat =  '%f';
headerdelimiter = char(9); %tab
datadelimiter = ' ';
commentstyle = '%';

% Read in data if it is not already in the workspace
data = pkg.fun.read_data(directory,filename,datatype,ntaglines,...
       nheaderlines,tagformat,headerformat,dataformat,headerdelimiter,datadelimiter,commentstyle);

    
t   = data.ch1;
phi = data.ch2;

figure
    plot(t,phi)
    legend()
    xlabel('t(s)')
    ylabel('phi(deg)')

tstart = 300;
phi = phi(t>=tstart);
t   = t(t>=tstart) - tstart;

[f,P] = pkg.fun.fft(t,phi);
figure
    semilogx(f,P); 
    xlabel('f(Hz)')
    ylabel('Amp (deg)')

passbandfreq = 0.5; % Hz
[phi_f] = lowpass(phi,passbandfreq,(2*10^-3)^(-1),'Steepness',0.95);
          lowpass(phi,passbandfreq,(2*10^-3)^(-1),'Steepness',0.95); % run again to view output plot
          
figure
    plot(t,phi_f)
    legend()
    xlabel('t(s)')
    ylabel('phi(deg)')

Tn_mean  = mean(Tn);
Tn_stdev = std(Tn);

Iyy_mean = mean(Iyy);
Iyy_std  = std(Iyy);

IyySW   = 0.6583; % kg-m^2

figure
bar(1,Iyy_mean,'DisplayName','Swing Test'); hold on
    er = errorbar(1,Iyy_mean,Iyy_std,Iyy_std,'DisplayName','Swing Test STDEV');
    er.Color = [0 0 0];                            
    er.LineStyle = 'none';
bar(2,IyySW,'DisplayName','SW')
ylabel('Iyy (kg-m^2)')
%xticks('exp','SW')
legend()
