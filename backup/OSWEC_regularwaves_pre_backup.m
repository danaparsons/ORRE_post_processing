%% ------------------------------ Header ------------------------------- %%
% Filename:     OSWEC_regularwaves_pre.m
% Description:  Pre-process OSWEC-type model regular wave experiments
% Author:       J. Davis
% Created on:   5-17-21
% Last updated: 5-18-21 by J. Davis
%% --------------------------------------------------------------------- %%
function [data] = OSWEC_regularwaves_pre(data,t0,tf,fs,plotloop)

setnames = fieldnames(data);
numruns = length(setnames); % number of fields in the dataset

for i = 1:numruns

    run = setnames{i};
    
    disp(run)
    
    % extract data
    phi_raw  = data.(run).ch13;
    t_raw    = data.(run).ch1;
    
    % slice data
    t_slice = t_raw(t_raw >= t0)-t0;
    t_slice = t_slice(t_slice<=tf-t0);
    phi_slice = phi_raw(t_raw >= t0);
    phi_slice =  phi_slice(t_slice <= tf-t0);
    phi_slice = phi_slice-mean(phi_slice(end-round(0.05*length(phi_slice)):end-5));
    
    % 0.15 for pos
    pkpromfactor = 0.25; % threshold (as proportion of peak FFT value) below which additional peaks are considered insignificant
    [f_slice,P_slice,dominant_periods,~,~] = pkg.fun.plt_fft(t_slice,phi_slice,fs,pkpromfactor);
    
    % implement a preliminary lowpass filter, if one has not already been specified.
    if checkfieldORprop(data.(run),'filter') == 0
        
        % specifications
        type = 'butter';
        subtype = 'low';
        order = 4;
        cutoff_margin = 1.85;
        
        % specify the cutoff frequency based on the dominant fft peaks
        f_cutoff = 1/min(dominant_periods)*cutoff_margin; % Hz
        
        % populate filter field information (done after for clarity):
        filter.type = type;
        filter.subtype = subtype;
        filter.order = order;
        filter.f_cutoff = f_cutoff;

    else % if a filter has been specified, unpack specifications:
        type        = data.(run).pos.filter.type;
        subtype     = data.(run).pos.filter.subtype;
        order       = data.(run).pos.filter.order;
        f_cutoff    = data.(run).pos.filter.f_cutoff; 
    end
    
    % build the filter:
    f_norm =  f_cutoff/max(f_slice);
    [b,a] = feval(type,order,f_norm,subtype);  % [phi,~] = lowpass(phi_raw,passbandfreq,(2*10^-3)^(-1),'Steepness',0.95);
    [h_filt,f_filt] = freqz(b,a,f_slice,fs);
    h_ma_filt = abs(h_filt);
    h_ph_filt = mod(angle(h_filt)*180/pi,360)-360;
    
    % populate filter field information:
    filter.a = a;
    filter.b = b;
    filter.f_filt = f_filt;
    filter.h_filt = h_filt;
    
    % perform the filtering
    phi = filtfilt(b,a,phi_slice); % filtfilt neccessary for zero-phase filtering
    t = t_slice;
    
    % reproduce fft using filtered signal
    [f,P,T,~,fft_out] = pkg.fun.plt_fft(t,phi,fs,pkpromfactor);
    T(i) = max(T);
    disp(T(i))
    
    % figures
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
    
    % populate dataset fields
    data.(run).pos.t        = t;
    data.(run).pos.phi      = phi;
    data.(run).pos.t0       = t0;
    data.(run).pos.tf       = tf;
    data.(run).pos.fft      = fft_out;
    data.(run).pos.filter   = filter;
end
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

function bool = checkfieldORprop(structORobj,fieldORprop)
   bool = false;
   if isfield(structORobj,fieldORprop)
       bool = true;
   elseif isprop(structORobj,fieldORprop)
       bool = true;
   end

end