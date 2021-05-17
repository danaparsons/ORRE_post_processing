%% ------------------------------ Header ------------------------------- %%
% Filename:     OSWEC_regularwaves.m
% Description:  Post-process OSWEC-type model regular wave experiments
% Author:       J. Davis
% Created on:   5-17-21
% Last updated: 5-17-21 by J. Davis
%% --------------------------------------------------------------------- %%
function [data] = OSWEC_regularwaves(data,plotloop)

setnames = fieldnames(data);
numruns = length(setnames); % number of fields in the dataset

% initialize vector to store results
% Tn      = zeros(numruns,1); 
% wn      = zeros(numruns,1); 
% phi0    = zeros(numruns,1); 

for i = 1:numruns
    
    run = setnames{i};
    
    disp(run)
    
    phi_raw  = data.(run).ch6;
    t    = data.(run).ch1;
    
%     if       contains(run,'pos'); phi0sign = 1;
%     elseif   contains(run,'neg'); phi0sign = 2; end
%     phi0sign = 1
%     [t0,phi0(i)] = pks(t,phi_raw,phi0sign);
    t0 = 0
    t    = data.(run).ch1(data.(run).ch1 >= t0)-t0;
    phi_raw  = data.(run).ch6(data.(run).ch1 >= t0);
    phi_raw = phi_raw-mean(phi_raw(end-round(0.05*length(phi_raw)):end-5));
    
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
    
% wn(i)  = 2*pi/Tn(i);
% 
%     data.(run).t    = t;
%     data.(run).phi  = phi;
%     data.(run).t0   = t0;
%     data.(run).phi0 = phi0(i);
%     data.(run).f    = f.';
%     data.(run).P    = P;
%     data.(run).Tn   = Tn(i);
%     data.(run).wn   = wn(i);
end

% compute basic statistics
% Tn_mean  = mean(Tn); Tn_std = std(Tn);
% wn_mean = mean(wn); wn_std  = std(wn);

% visualize results
% figure; hold on
% scatter(1:numruns,wn,'o','MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','observations')
% yline(wn_mean,'LineWidth',1.5,'DisplayName','mean')
%     % plot 1 stddev from mean
%     inBetween = [(wn_mean+wn_std)*[1 1], fliplr((wn_mean-wn_std)*[1 1])];
%     fill([[1 numruns], fliplr([1 numruns])], inBetween, 'k','FaceAlpha',0.1,'EdgeColor','none','DisplayName','1 stdev')
%     ylim([0.9 1.1]*wn_mean)
%     xlim([1 numruns])
%     xlabel('Observation')
%     ylabel('w_{n} (rad/s)')
%     legend()

figure; hold on
scatter(phi0,wn,'o','MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','observations')
yline(wn_mean,'LineWidth',1.5,'DisplayName','mean')
inBetween = [(wn_mean+wn_std)*[1 1], fliplr((wn_mean-wn_std)*[1 1])];
fill([xlim, fliplr(xlim)], inBetween, 'k','FaceAlpha',0.1,'EdgeColor','none','DisplayName','1 stdev')
    ylim([0.9 1.1]*wn_mean)    
    xlabel('\phi_{0} (deg)')
    ylabel('w_{n} (rad/s)')
    legend()
    
figure
histogram(wn,round(numruns/2),'FaceColor','k','FaceAlpha',0.1)
xlabel('w_{n} (rad/s)')
ylabel('Count')

% initialize results structure
data.results = [];

% populate
data.results.wn_mean     = wn_mean;
data.results.wn_std      = wn_std;
data.results.Tn_mean     = Tn_mean;
data.results.Tn_std      = Tn_std;
data.results.tabulated   = table(phi0,wn,Tn);
end


function [t0,phi0] = pks(t,phi_raw,phi0sign)
    
    t0   = [];
    phi0 = [];
    
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
    
    clear side1pks side1locs side2pks side2locs secondpkloc firstpklocs firstpkloc firstpk
end
