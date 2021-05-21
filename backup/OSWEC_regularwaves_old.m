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
    
    phi_raw  = data.(run).ch7;
    t_raw    = data.(run).ch1;
   
    
%     if       contains(run,'pos'); phi0sign = 1;
%     elseif   contains(run,'neg'); phi0sign = 2; end
%     phi0sign = 1
%     [t0,phi0(i)] = pks(t,phi_raw,phi0sign);

    t0 = 10;
    tf = 40;
    fs = 500;
    
    t_slice = data.(run).ch1(data.(run).ch1 >= t0)-t0;
    t_slice = t_slice(t_slice<=tf-t0);
    phi_slice = data.(run).ch7(data.(run).ch1 >= t0);
    phi_slice =  phi_slice(t_slice <= tf-t0);
    phi_slice = phi_slice-mean(phi_slice(end-round(0.05*length(phi_slice)):end-5));
    
    [f_slice,P_slice,dominant_periods] = pkg.fun.plt_fft(t_slice,phi_slice,fs);
    
    % implement a preliminary lowpass filter, if one has not already been specified.
    if ~isfield(data.(run),'filter') || ~isprop(data.(run),'filter')
        
        % specifications
        filter = 'butter';
        type = 'low';
        order = 4;
        cutoff_margin = 1.85;
        
        % specify the cutoff frequency based on the dominant fft peaks
        f_cutoff = 1/min(dominant_periods)*cutoff_margin; % Hz
        
        % populate filter field information (done after for clarity):
        data.(run).filter.filter = filter;
        data.(run).filter.type = type;
        data.(run).filter.order = order;
        data.(run).filter.f_cutoff = f_cutoff;

    else % if a filter has been specified, unpack specifications:
        filter      = data.(run).filter.filter;
        type        = data.(run).filter.type;
        order       = data.(run).filter.order;
        f_cutoff    = data.(run).filter.f_cutoff; 
    end
    
    % build the filter:
    f_norm =  f_cutoff/max(f_slice);
    [b,a] = feval(filter,order,f_norm,type);  % [phi,~] = lowpass(phi_raw,passbandfreq,(2*10^-3)^(-1),'Steepness',0.95);
    
    % populate filter field information:
    data.(run).filter.a = a;
    data.(run).filter.b = b;
    %%%%%%%%%%%%%%%
    
    phi = filtfilt(b,a,phi_slice); % filtfilt neccessary for zero-phase filtering
    t = t_slice;
    
    [f,P,T,~,data.(run)] = pkg.fun.plt_fft(t,phi,fs,data.(run));
    T(i) = max(T);
    disp(T(i))
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % IMPLEMENT PROPER MEAN SUBTRACTION 
    % CHOP DATA AT A FINITE NUMBER OF CYCLES FOR FINAL FFT
    % REPEAT FOR REMAINING SIGNALS!
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if plotloop == true
        
        figure
        subplot(1,2,1)
            plot(t_raw,phi_raw)
            xline(t0,'LineWidth',1.5); xline(tf,'LineWidth',1.5)
            xlabel('t(s)')
            ylabel('phi(deg)')
            
        subplot(1,2,2)
            plot(t_slice,phi_slice)
            xlabel('t(s)')
            ylabel('phi(deg)')
            
            sgtitle(replace(run,'_',' '))
            
        figure
        
        subplot(2,1,1)
            semilogx(f_slice,P_slice,'DisplayName','Original','LineWidth',2); hold on
            semilogx(f,P,'DisplayName','Filtered','LineWidth',1.25) 
            xline(f_cutoff,'DisplayName','Cutoff frequency')
            legend()
            xlabel('f(Hz)')
            ylabel('P1 (deg)')
            legend()
            
        subplot(2,1,2)
            [h_filt,f_filt] = freqz(b,a,f,fs);
            yyaxis left
            semilogx(f_filt,mag2db(abs(h_filt)),'DisplayName','Ma','LineWidth',2); hold on
            ylabel('Magnitude (dB)')
            yyaxis right
            semilogx(f_filt,mod(angle(h_filt)*180/pi,360)-360,'DisplayName','Ph','LineWidth',2);
            xlabel('f(Hz)')
            ylabel('Phase (deg)')
            legend()
            xlim([min(f),max(f)])
            
            sgtitle(replace(run,'_',' '))
            
        figure

        subplot(1,2,1)
            title(run)
            plot(t_slice,phi_slice,'DisplayName','Original'); hold on
            plot(t,phi,'DisplayName','Filtered')
            legend()
            xlabel('t(s)')
            ylabel('phi(deg)')
            ylim(round(1.5*max(phi)*[-1 1],1))
            legend()
            
        subplot(1,2,2)
            title(run)
            plot(t,phi,'DisplayName','Filtered')
            legend()
            xlabel('t(s)')
            ylabel('phi(deg)')
            ylim(round(1.5*max(phi)*[-1 1],1))
            legend()  
            sgtitle(replace(run,'_',' '))
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
