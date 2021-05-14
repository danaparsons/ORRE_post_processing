%% ------------------------------ Header ------------------------------- %%
% Filename:     OSWEC_freedecay.m
% Description:  Post-process OSWEC-type model free decay experiments
% Author:       J. Davis
% Created on:   5-13-21
% Last updated: 5-13-21 by J. Davis
%% --------------------------------------------------------------------- %%
function out = OSWEC_freedecay(data)

setnames = fieldnames(data);
numruns = length(setnames); % number of fields in the dataset

% moment of inertia calc loop
g = 9.81;           % (m/s^2)
d = 0.18;           %  from hang test (m)
M = 6.446+7.044;    % body + ballast (kg)


Tn  = zeros(numruns,1); % initialize vector to store dominant periods
wn  = zeros(numruns,1); 
Iyy = zeros(numruns,1);

plotloop = true;

for i = 1:numruns
    run = setnames{i};
    
    
    phi_raw  = data.(run).ch6;
    t    = data.(run).ch1;
    
    figure
    plot(t,phi_raw)
    
    if       contains(run,'pos'); phi0sign = 1;
    elseif   contains(run,'neg'); phi0sign = 2; end
    
    [t0,phi0] = pks(t,phi_raw,phi0sign);
 
    t    = data.(run).ch1(data.(run).ch1 >= t0)-t0;
    phi_raw  = data.(run).ch6(data.(run).ch1 >= t0);
    phi_raw = phi_raw-mean(phi_raw(end-round(0.05*length(phi_raw)):end-5));
    
    figure
    plot(t,phi_raw)
    
    % lowpass filter
    [f_raw,P_raw] = pkg.fun.plt_fft(t,phi_raw);
    passbandfreq = 5; % Hz
    [phi,filter] = lowpass(phi_raw,passbandfreq,(2*10^-3)^(-1),'Steepness',0.95);
    [f,P,Tn(i)] = pkg.fun.plt_fft(t,phi);
    
    if plotloop == true
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
    end

wn(i)  = 2*pi/Tn(i);
end

% compute basic statistics
Tn_mean  = mean(Tn); Tn_std = std(Tn);
Iyy_mean = mean(Iyy); Iyy_std  = std(Iyy);

% visualize results
figure; hold on
scatter(1:numruns,Iyy,'o','MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','observations')
    yline(Iyy_mean,'LineWidth',1.5,'DisplayName','mean')
    ylim([0.9 1.1]*Iyy_mean)
    xlim([1 numruns])
    % plot 1 stddev from mean
    inBetween = [(Iyy_mean+Iyy_std)*[1 1], fliplr((Iyy_mean-Iyy_std)*[1 1])];
    fill([[1 numruns], fliplr([1 numruns])], inBetween, 'k','FaceAlpha',0.1,'EdgeColor','none','DisplayName','1 stdev')
    xlabel('Observation')
    ylabel('I_{yy} (kg-m^2)')
    legend()
    
    
figure
histogram(Iyy,round(numruns/2))
xlabel('I_{yy} (kg-m^2)')
ylabel('Count')

out.Iyy_mean    = Iyy_mean;
out.Iyy_std     = Iyy_std;
out.Tn_mean     = Tn_mean;
out.Tn_std      = Tn_std;
end


function [t0,phi0] = pks(t,phi_raw,phi0sign)
    
    if phi0sign == 1 % positive
        pkprom = 0.15*abs(min(phi_raw));
        c = [1 -1];
    elseif phi0sign == 2 % negative
        pkprom = 0.15*max(phi_raw);
        c = [-1 1];
    end
    
    [side1pks, side1locs] = findpeaks(c(1)*phi_raw,t,'MinPeakProminence',pkprom,'Annotate','extents');
    [side2pks, side2locs] = findpeaks(c(2)*phi_raw,t,'MinPeakProminence',pkprom,'Annotate','extents');
    
    secondpkloc = max(side2locs(side2pks==max(side2pks)));
    firstpklocs = side1locs(side1locs < secondpkloc);
    firstpkloc = firstpklocs(end);
    firstpk = c(1)*side1pks(side1locs==firstpkloc);
    
    t0 = firstpkloc;
    phi0 = firstpk;
end
