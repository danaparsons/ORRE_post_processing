%% ------------------------------ Header ------------------------------- %%
% Filename:     OSWEC_regularwaves_post.m
% Description:  Post-process OSWEC-type model regular wave experiments
% Author:       J. Davis
% Created on:   5-18-21
% Last updated: 5-18-21 by J. Davis
%% --------------------------------------------------------------------- %%
function [data] = OSWEC_regularwaves_pre0(data,channels,varnames,subfields,t0,tf,fs,plotloop)

setnames = fieldnames(data);
numruns = length(setnames); % number of fields in the dataset
numchs = length(channels);

for i = 1:numruns
    % assign current run of the dataset
    run = setnames{i};
    disp(run)
    
    for j = 1:numchs
        
    ch = ['ch',num2str(channels{j})];
    varname = varnames{j};
    chlabel = data.(run).map(ch);
        if contains(chlabel,'"')
            chlabel = strip(chlabel,'"');
        end
    subfield = subfields{j};
    
    disp(varname)
    
    % extract data
    y_raw  = data.(run).(ch);
    t_raw    = data.(run).ch1;
    
    % slice data
    t_slice = t_raw(t_raw >= t0)-t0;
    t_slice = t_slice(t_slice<=tf-t0);
    y_slice = y_raw(t_raw >= t0);
    y_slice =  y_slice(t_slice <= tf-t0);
    y_slice = y_slice-mean(y_slice(end-round(0.05*length(y_slice)):end-5));
    
    % 0.15 for pos
    pkpromfactor = 0.25; % threshold (as proportion of peak FFT value) below which additional peaks are considered insignificant
    [f_slice,P_slice,dominant_periods,~,~] = pkg.fun.plt_fft(t_slice,y_slice,fs,pkpromfactor);
    
    % implement a preliminary lowpass filter, if one has not already been specified.
    if checkfieldORprop(data,run,subfield,'filter') == 0
        
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
        type        = data.(run).(subfield).filter.type;
        subtype     = data.(run).(subfield).filter.subtype;
        order       = data.(run).(subfield).filter.order;
        f_cutoff    = data.(run).(subfield).filter.f_cutoff; 
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
    y = filtfilt(b,a,y_slice); % filtfilt neccessary for zero-phase filtering
    t = t_slice;
    
    % reproduce fft using filtered signal
    [f,P,T,~,fft_out] = pkg.fun.plt_fft(t,y,fs,pkpromfactor);
    T(i) = max(T);
    disp(T(i))
    
    % figures
    if plotloop == true
        
        figure
        subplot(1,2,1)
            plot(t_raw,y_raw)
            xline(t0,'LineWidth',1.5); xline(tf,'LineWidth',1.5)
            xlabel('t(s)')
            ylabel(chlabel)
            
        subplot(1,2,2)
            plot(t_slice,y_slice)
            xlabel('t(s)')
            ylabel(chlabel)
            
            sgtitle(replace(run,'_',' '))
            
        figure
        
        subplot(2,1,1)
            semilogx(f_slice,P_slice,'DisplayName','Original','LineWidth',2); hold on
            semilogx(f,P,'DisplayName','Filtered','LineWidth',1.25) 
            xline(f_cutoff,'DisplayName','Cutoff frequency')
            legend()
            xlabel('f(Hz)')
            ylabel(['P1 ',chlabel])
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
            plot(t_slice,y_slice,'DisplayName','Original'); hold on
            plot(t,y,'DisplayName','Filtered')
            legend()
            xlabel('t(s)')
            ylabel(chlabel)
            ylim(round(1.5*max(y)*[-1 1],1))
            legend()
            
        subplot(1,2,2)
            title(run)
            plot(t,y,'DisplayName','Filtered')
            legend()
            xlabel('t(s)')
            ylabel(chlabel)
            ylim(round(1.5*max(y)*[-1 1],1))
            legend()  
            sgtitle(replace(run,'_',' '))
    end
    
    % populate dataset fields
    data.(run).(subfield).t        = t;
    data.(run).(subfield).(varname)= y;
    data.(run).(subfield).slice.t0 = t0;
    data.(run).(subfield).slice.tf = tf;
    data.(run).(subfield).fft      = fft_out;
    data.(run).(subfield).filter   = filter;
    
    end
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