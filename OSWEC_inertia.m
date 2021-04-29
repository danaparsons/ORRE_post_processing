%% ------------------------------ Header ------------------------------- %%
% Filename:     ORRE_post_processing.m
% Description:  ORRE Post Processing Program input file (test)
% Authors:      D. Lukas and J. Davis
% Created on:   6-10-20
% Last updated: 8-9-20 by J. Davis
%% ------------------------------------ -------------------------------- %%

close all % close any open figures

% Define inputs:
directory = "data\OSWEC_inertia\";     % current directory
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

% Read in data if it is not already in the workspace
if ~exist('data','var')
    data.run1 = pkg.fun.read_data(directory,"run1.txt",datatype,ntaglines,...
        nheaderlines,tagformat,headerformat,dataformat,headerdelimiter,datadelimiter,commentstyle);

    data.run2 = pkg.fun.read_data(directory,"run2.txt",datatype,ntaglines,...
        nheaderlines,tagformat,headerformat,dataformat,headerdelimiter,datadelimiter,commentstyle);

    data.run3 = pkg.fun.read_data(directory,"run3.txt",datatype,ntaglines,...
        nheaderlines,tagformat,headerformat,dataformat,headerdelimiter,datadelimiter,commentstyle);
end


%%%%% moment of inertia calc

g = 9.81;
d = 0.2659; % from SW, no ballast
M = 6.3037; % from SW, no ballast

Tn  = zeros(3,1); % initialize vector to store dominant periods
wn  = zeros(3,1); 
Iyy = zeros(3,1);

for num = 1:3
    run = ['run',num2str(num)];
    phi0 = data.(run).ch2(data.(run).ch2 == min(data.(run).ch2));
    t0   = data.(run).ch1(data.(run).ch2 == phi0);
    t    = data.(run).ch1(data.(run).ch1 >= t0)-t0;
    phi_raw  = data.(run).ch2(data.(run).ch1 >= t0); phi_raw = phi_raw-mean(phi_raw(end-100:end));

    % filter
    [f_raw,P_raw] = pkg.fun.fft(t,phi_raw);
    %data.run1.addprop('fft')
    %data.run1.fft.fs = (2*10^(-3))^(-1);
    %pkg.fun.fft(1,2,data.run1);
    %phi_f = bandpass(phi,[.8,1.2],(2*10^-3)^(-1));
    passbandfreq = 2; % Hz
    [phi,filter] = lowpass(phi_raw,passbandfreq,(2*10^-3)^(-1),'Steepness',0.95);
    [f,P,Tn(num)] = pkg.fun.fft(t,phi);
    
    figure
        semilogx(f_raw,P_raw,'DisplayName','Original'); hold on
        semilogx(f,P,'DisplayName','Filtered'); 
        xline(passbandfreq,'DisplayName','Passband frequency')
        legend()
        xlabel('f(Hz)')
        ylabel('P1')

    figure
        plot(t,phi_raw,'DisplayName','Original'); hold on
        plot(t,phi,'DisplayName','Filtered')
        legend()
        xlabel('t(s)')
        ylabel('phi(deg)')
        
wn(num)  = 2*pi/Tn(num);
Iyy(num) = M*g*d/wn(num)^2; % kg-m^2        

end

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
