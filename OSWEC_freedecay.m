%% ------------------------------ Header ------------------------------- %%
% Filename:     OSWEC_freedecay.m
% Description:  Post-process OSWEC-type model free decay experiments
% Author:       J. Davis
% Created on:   5-13-21
% Last updated: 5-13-21 by J. Davis
%% --------------------------------------------------------------------- %%
function [data] = OSWEC_freedecay(data,fs,plotloop)
subfield = 'position';
setnames = fieldnames(data);
numruns = length(setnames); % number of fields in the dataset

% initialize vector to store results
Tn      = zeros(numruns,1); 
wn      = zeros(numruns,1); 
phi0    = zeros(numruns,1); 

for i = 1:numruns
    
    % assign current run of the dataset
    run = setnames{i};
    disp(run)
    
    % close any open figures
    close all
    
    % assign raw data
    phi_raw  = data.(run).ch6;
    t_raw    = data.(run).ch1;
    
%     figure   
%     plot(t,phi_raw)
    % interpolate the results if dropouts are present
    if sum(phi_raw==0) > 0
        dropoutratio = sum(phi_raw==0)/length(phi_raw);
%         if dropoutratio < 0.10
        disp([num2str(100*dropoutratio),'% of the data contains dropouts. Interpolating the results.'])
        phi_raw = interp1(t_raw(phi_raw ~=0),phi_raw(phi_raw~=0),t_raw);
%         else
%             error([num2str(100*dropoutratio),'% of the data contains dropouts. Discard recommended.'])
%         end
    end
    
    % remove nans
    t_raw = t_raw(~isnan(phi_raw));
    phi_raw = phi_raw(~isnan(phi_raw));
    
    if       contains(run,'pos'); phi0sign = 1;
    elseif   contains(run,'neg'); phi0sign = 2; end
    
    % remove mean
    phi_raw = phi_raw-mean(phi_raw(end-round(0.05*length(phi_raw)):end-5));
%     phi_raw = detrend(phi_raw);
    
    
    pkpromfactor = 0.75; % threshold, as a fraction of the maximum, for which peaks should be considered
    minwidth = 0.5; % width (in seconds) below which peaks are considered noise
    [t0,phi0(i)] = pks(t_raw,phi_raw,phi0sign,pkpromfactor,minwidth);
 
%     t    = data.(run).ch1(data.(run).ch1 >= t0)-t0;
%     phi_raw  = data.(run).ch6(data.(run).ch1 >= t0);
    t_slice    = t_raw(t_raw >= t0)-t0;
    phi_raw_slice  = phi_raw(t_raw >= t0);
    
    % remove mean again
%     phi_raw_slice = detrend(phi_raw_slice);

    % FFT of raw data
    pkpromfactor = 0.15; % threshold (as proportion of peak FFT value) below which additional peaks are considered insignificant
    [f_raw,P_raw,dominant_periods,~,~] = pkg.fun.plt_fft(t_slice,phi_raw_slice,fs,pkpromfactor);
    
     % implement a preliminary lowpass filter, if one has not already been specified.
    if checkfieldORprop(data,run,subfield,'filter') == 0
        
        % specifications
        type = 'butter';
        subtype = 'low';
        order = 4;
        cutoff_margin = 15; %%% consider 4 or 5
        
        % specify the cutoff frequency based on the dominant fft peaks
        f_cutoff = 1/min(dominant_periods)*cutoff_margin; % Hz
        
        % populate filter field information (done after for clarity):
        filter.type = type;
        filter.subtype = subtype;
        filter.order = order;
        filter.cutoff_margin = cutoff_margin;
        filter.f_cutoff = f_cutoff;

    else % if a filter has been specified, unpack specifications:
        type        = data.(run).(subfield).filter.type;
        subtype     = data.(run).(subfield).filter.subtype;
        order       = data.(run).(subfield).filter.order;
        f_cutoff    = data.(run).(subfield).filter.f_cutoff; 
    end
    
    % build the filter:
    f_norm =  f_cutoff/max(f_raw);
    [b,a] = feval(type,order,f_norm,subtype);  % [phi,~] = lowpass(phi_raw,passbandfreq,(2*10^-3)^(-1),'Steepness',0.95);
    [h_filt,f_filt] = freqz(b,a,f_raw,fs);
    h_ma_filt = abs(h_filt);
    h_ph_filt = mod(angle(h_filt)*180/pi,360)-360;
    
    % populate filter field information:
    filter.a = a;
    filter.b = b;
    filter.f_filt = f_filt;
    filter.h_filt = h_filt;
    
    % perform the filtering
    phi = filtfilt(b,a,phi_raw_slice); % filtfilt neccessary for zero-phase filtering
    t = t_slice;
    
    % update the initial position
    phi0(i) = phi(1);
    
    % repeat fft, now using the filtered signal
    [f,P,T,~,fft_out] = pkg.fun.plt_fft(t_slice,phi,fs,pkpromfactor);
    Tn(i) = max(T);
    disp(['T = ',num2str(Tn(i))])
 
    if plotloop == true
        
        % subplot 1: (left) raw data; (right) sliced data
        fig1 = figure;
        fig1.Position(1) = fig1.Position(1) - fig1.Position(3);
        fig1.Position(2) = fig1.Position(2) - fig1.Position(4)/2;
%         movegui(fig1,'west')
        subplot(1,2,1)
            plot(t_raw,phi_raw)
            xline(t0,'LineWidth',1.5);
            xlabel('t(s)')
            ylabel('phi (deg)')
            
        subplot(1,2,2)
            plot(t_slice,phi_raw_slice)
            xlabel('t(s)')
            ylabel('phi (deg)')
            
            sgtitle(replace(run,'_',' '))
            
        % subplot 2: (left) fft of raw sliced and filtered data;(right) filter response
        fig2 = figure;
        fig2.Position(2) = fig2.Position(2) - fig2.Position(4)/2;
%         movegui(fig2,'center')
        subplot(2,1,1)
            semilogx(f_raw,P_raw,'DisplayName','Original','LineWidth',2); hold on
            semilogx(f,P,'DisplayName','Filtered','LineWidth',1.25) 
            xline(f_cutoff,'DisplayName','Cutoff frequency')
            legend()
            xlabel('f(Hz)')
            ylabel(['phi (deg)'])
            legend()
            
        subplot(2,1,2)
            yyaxis left
            semilogx(f_filt,mag2db(h_ma_filt),'DisplayName','Ma','LineWidth',2); hold on
            ylabel('Magnitude (dB)')
            yyaxis right
            semilogx(f_filt,h_ph_filt,'DisplayName','Ph','LineWidth',2);
            xlabel('f(Hz)')
            ylabel('Phase (deg)')
            legend()
            xlim([min(f),max(f)])
            
            sgtitle(replace(run,'_',' '))
            
        % subplot 3: (left) sliced and filtered signal;(right) filtered signal only
        fig3 = figure;
        fig3.Position(1) = fig3.Position(1) + fig3.Position(3);
        fig3.Position(2) = fig3.Position(2) - fig3.Position(4)/2;
        subplot(1,2,1)
            title(run)
            plot(t_slice,phi_raw_slice,'DisplayName','Original'); hold on
            plot(t,phi,'DisplayName','Filtered')
            legend()
            xlabel('t(s)')
            ylabel('phi (deg)')
            ylim(round(1.5*abs(phi0(i))*[-1 1],2))
            legend()
            
        subplot(1,2,2)
            title(run)
            plot(t,phi,'DisplayName','Filtered')
            legend()
            xlabel('t(s)')
            ylabel('phi (deg)')
            ylim(round(1.5*abs(phi0(i))*[-1 1],2))
            legend()  
            sgtitle(replace(run,'_',' '))
    end

% angular frequency:
wn(i)  = 2*pi/Tn(i);

% populate fields:
data.(run).(subfield).t    = t;
data.(run).(subfield).phi  = phi;
data.(run).(subfield).t0   = t0;
data.(run).(subfield).phi0 = phi0(i);
data.(run).(subfield).Tn   = Tn(i);
data.(run).(subfield).wn   = wn(i);
data.(run).(subfield).fft      = fft_out;
data.(run).(subfield).filter   = filter;
% 
% figure(fig1)
% figure(fig2)
% figure(fig3)
end

% compute basic statistics
Tn_mean  = mean(Tn); Tn_std = std(Tn);
wn_mean = mean(wn); wn_std  = std(wn);

% visualize results
figure; hold on
scatter(phi0,wn,'o','MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','observations')
yline(wn_mean,'LineWidth',1.5,'DisplayName','mean')
inBetween = [(wn_mean+wn_std)*[1 1], fliplr((wn_mean-wn_std)*[1 1])];
fill([xlim, fliplr(xlim)], inBetween, 'k','FaceAlpha',0.1,'EdgeColor','none','DisplayName','1 stdev')
%     ylim([0.9 1.1]*wn_mean)    
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

%% --------------------------- Subfunctions ---------------------------- %%

function bool = checkfieldORprop(structORobj,run,subfield,fieldORprop)
   bool = false;
   try
       if isfield(structORobj.(run).(subfield),fieldORprop)
           bool = true;
       elseif isprop(structORobj.(subfield).(run),fieldORprop)
           bool = true;
       end
   catch
   end
end

function [t0,phi0] = pks(t,phi_raw,phi0sign,pkpromfactor,minwidth)
    
    t0   = [];
    phi0 = [];
    
    if phi0sign == 1 % positive
        pkprom = pkpromfactor*abs(min(phi_raw));
        c = [1 -1];
    elseif phi0sign == 2 % negative
        pkprom = pkpromfactor*max(phi_raw);
        c = [-1 1];
    end
    
    % find peaks
    [side1pks, side1locs,w1] = findpeaks(c(1)*phi_raw,t,'MinPeakProminence',pkprom,'Annotate','extents');
    [side2pks, side2locs,w2] = findpeaks(c(2)*phi_raw,t,'MinPeakProminence',pkprom,'Annotate','extents');
    
    % drop peaks which are too narrow and considered noise
    side1pks = side1pks(w1 > minwidth); side1locs = side1locs(w1 > minwidth);
    side2pks = side2pks(w2 > minwidth); side2locs = side2locs(w2 > minwidth);
    
    % locate second peak based on side 2; it is the maximum of the flipped signal
    secondpkloc = max(side2locs(side2pks==max(side2pks)));
    % reduce the number of possible first peaks by dropping those which occur after the second peak
    firstpklocs = side1locs(side1locs < secondpkloc);
    % find the location of the first peak; in the event that a peak occurs before the
    % initial drop (due to positioning) the peak location is the one closest to the second.    
    firstpkloc = firstpklocs(end);
    % first peak value; multiply by the factor c, which is based on whether or not
    % phi0 is pos or neg.
    firstpk = c(1)*side1pks(side1locs==firstpkloc);
    
    % assign values
    t0 = firstpkloc;
    phi0 = firstpk;
    
    clear side1pks side1locs side2pks side2locs secondpkloc firstpklocs firstpkloc firstpk
end
