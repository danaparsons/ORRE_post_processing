%% ------------------------------ Header ------------------------------- %%
% Filename:     OSWEC_regularwaves_pre.m
% Description:  Pre-process OSWEC-type model regular wave experiments
% Author:       J. Davis
% Created on:   5-17-21
% Last updated: 5-18-21 by J. Davis
%% --------------------------------------------------------------------- %%
function [data] = OSWEC_regularwaves_pre(data,dataopts,t0,tf,fs,plotloop)
% extract setnames, channels, variable names, and subfields:
setnames = fieldnames(data);
channels = dataopts.channels;
varnames = dataopts.varnames;
subfields = dataopts.subfields;

% extract number of runs and channels in the dataset:
numruns = length(setnames); 
numchs = length(channels);

for i = 1:numruns % loop over dataset runs
    % assign current run of the dataset
    currentrun = setnames{i};
    disp(['%',repmat('-',1,50),'%',newline,currentrun])
    
 
    % close any open figures
    close all
    
    for j = 1:numchs % loop over run channels
    % assign current channel of the run
    ch = ['ch',num2str(channels{j})];
    
%     if contains(currentrun,'T22')
%         plotloop = true
%     end
    
    % assign user-defined variable name corresponding to the channel
    varname = varnames{j};
    disp(varname)
    
    % assign channel label for plotting; uses dataset map feature
    chlabel = data.(currentrun).map(ch);
        if contains(chlabel,'"')
            chlabel = strip(chlabel,'"');
        end
    % assign user-defined subfield
    subfield = subfields{j};
    
    % initialize subfield:
    data.(currentrun).(subfield) = struct();
    
    % extract data
    y_raw  = data.(currentrun).(ch);
    t_raw    = data.(currentrun).ch1;

    % interpolate the results if dropouts are present
    if sum(y_raw==0) > 0
        dropoutratio = sum(y_raw==0)/length(y_raw);
        if dropoutratio < 0.15
        disp([num2str(100*dropoutratio),'% of the data stored as the variable ',varname,' in the ',subfield,' subfield contains dropouts. Interpolating the results.'])
        y_raw = interp1(t_raw(y_raw ~=0),y_raw(y_raw~=0),t_raw);
        else
            error([num2str(100*dropoutratio),'% of the data stored as the variable ',varname,' in the ',subfield,' subfield contains dropouts. Discard recommended.'])
        end
    end
    
    % slice data
    t_slice = t_raw(t_raw >= t0 & t_raw <= tf)-t0;
    y_slice = y_raw(t_raw >= t0 & t_raw <= tf);
    y_slice =  detrend(y_slice);
    % y_slice = y_slice-mean(y_slice(end-round(0.05*length(y_slice)):end-5));
    
    % 0.15 for pos; 0.25 for loads
    pkpromfactor = 0.35; % threshold (as proportion of peak FFT value) below which additional peaks are considered insignificant
    [f_slice,Ma_slice,~,~,~,~,~,fft_raw] = pkg.fun.plt_fft(t_slice,y_slice,fs,pkpromfactor);
    oscillating_period = fft_raw.oscillating_period;
    
    % FILTERING
    % if a subfield-specific filter has been specified, unpack specifications:
    if checkfieldORprop(dataopts,'filters') == 1 
        filt = dataopts.filters{j};
        
        % if a cutoff margin is specified, calculate the cutoff frequency based on the dominant fft peak
        if isfield(filt,'cutoff_margin')
            filt.f_cutoff = 1/oscillating_period*filt.cutoff_margin; % Hz % filt.f_cutoff = 1/min(dominant_periods)*filt.cutoff_margin;
            
       % if a cutoff frequency is specified, calculate the cutoff margin based on the dominant fft peak
        elseif isfield(filt,'f_cutoff')
            filt.cutoff_margin = filt.f_cutoff*oscillating_period;
        end
        
    % if a run-specific filter has been specified, unpack specifications:
    elseif checkfieldORprop(data.(currentrun).(subfield),'filt') == 1 
        filt = data.(currentrun).(subfield).filt;
        
    % if no filter is specified, implement a preliminary lowpass filter:
    else
        % specifications
        filt.type = 'butter';
        filt.subtype = 'low';
        filt.order = 4;
        filt.cutoff_margin = 3; 
        
        % specify the cutoff frequency based on the dominant fft peaks
        filt.f_cutoff = 1/oscillating_period*filt.cutoff_margin; % Hz
    end
    
    % build the filter:
    f_norm =  filt.f_cutoff/max(f_slice);
    [b,a] = feval(filt.type,filt.order,f_norm,filt.subtype);  % [phi,~] = lowpass(phi_raw,passbandfreq,(2*10^-3)^(-1),'Steepness',0.95);
    [h_filt,f_filt] = freqz(b,a,f_slice,fs);
    h_ma_filt = abs(h_filt);
    h_ph_filt = mod(angle(h_filt)*180/pi,360)-360;
    
    % populate filter field information:
    filt.a = a;
    filt.b = b;
    filt.f_filt = f_filt;
    filt.h_filt = h_filt;
    
    % perform the filtering
    y = filtfilt(b,a,y_slice); % filtfilt neccessary for zero-phase filtering
    t = t_slice;

    % repeat fft, now using the filtered signal    
    [f,Ma,~,~,~,~,~,fft_pre] = pkg.fun.plt_fft(t,y,fs,pkpromfactor);
    
    % store period and amplitude for summary table
    T_list(i,j) = fft_pre.oscillating_period;
    A_list(i,j) = fft_pre.peak_amp;
    
    % display to commmand window
    disp(['T = ',num2str(fft_pre.oscillating_period)])
    disp(['A = ',num2str(fft_pre.peak_amp)])
    
    % figures
    if plotloop == true
        % subplot 1: (left) raw data; (right) sliced data
        fig1 = figure;
        fig1.Position(1) = fig1.Position(1) - fig1.Position(3);
        fig1.Position(2) = fig1.Position(2) - fig1.Position(4)/2;
        subplot(1,2,1)
            plot(t_raw,y_raw)
            xline(t0,'LineWidth',1.5); xline(tf,'LineWidth',1.5)
            xlabel('t(s)')
            ylabel(chlabel)
            
        subplot(1,2,2)
            plot(t_slice,y_slice)
            xlabel('t(s)')
            ylabel(chlabel)
            
            sgtitle(replace(currentrun,'_',' '))
        
        % subplot 2: (left) fft of raw sliced and filtered data;(right) filter response
        fig2 = figure;
        fig2.Position(2) = fig2.Position(2) - fig2.Position(4)/2;
        subplot(2,1,1)
            semilogx(f_slice,Ma_slice,'DisplayName','Original','LineWidth',2); hold on
            semilogx(f,Ma,'DisplayName','Filtered','LineWidth',1.25) 
            xline(filt.f_cutoff,'DisplayName','Cutoff frequency')
            legend()
            xlabel('f(Hz)')
            ylabel(['Ma ',chlabel])
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
            
            sgtitle(replace(currentrun,'_',' '))
            
        % subplot 3: (left) sliced and filtered signal;(right) filtered signal only
        fig3 = figure;
        fig3.Position(1) = fig3.Position(1) + fig3.Position(3);
        fig3.Position(2) = fig3.Position(2) - fig3.Position(4)/2;
        subplot(1,2,1)
            title(currentrun)
            plot(t_slice,y_slice,'DisplayName','Original'); hold on
            plot(t,y,'DisplayName','Filtered')
            legend()
            xlabel('t(s)')
            ylabel(chlabel)
            ylim(round(1.5*abs(max(y_slice))*[-1 1],2))
            legend()
            
        subplot(1,2,2)
            title(currentrun)
            plot(t,y,'DisplayName','Filtered')
            legend()
            xlabel('t(s)')
            ylabel(chlabel)
            ylim(round(1.5*abs(max(y_slice))*[-1 1],2))
            legend()  
            sgtitle(replace(currentrun,'_',' '))
    end
    
    % populate dataset fields
    data.(currentrun).(subfield).t        = t;
    data.(currentrun).(subfield).(varname)= y;
    data.(currentrun).(subfield).slice.t0 = t0;
    data.(currentrun).(subfield).slice.tf = tf;
    data.(currentrun).(subfield).fft.raw  = fft_raw;
    data.(currentrun).(subfield).fft.pre  = fft_pre;
    data.(currentrun).(subfield).filt     = filt;
    
    end
end

A_table = array2table(A_list);
A_table.Properties.VariableNames = strcat(varnames,{'_'},{'A'});
A_table.Properties.RowNames = setnames;

T_table = array2table(T_list);
T_table.Properties.VariableNames = strcat(varnames,{'_'},{'T'});
T_table.Properties.RowNames = setnames;

disp(A_table)
disp(T_table)


end

%% --------------------------- Subfunctions ---------------------------- %%

function bool = checkfieldORprop(structORobj,fieldORprop)
   bool = false;
   try
       if isfield(structORobj,fieldORprop)
           bool = true;
       elseif isprop(structORobj,fieldORprop)
           bool = true;
       end
   catch
   end
end