%% ------------------------------ Header ------------------------------- %%
% Filename:     OSWEC_regularwaves_pre.m
% Description:  Pre-process OSWEC-type model regular wave experiments
% Author:       J. Davis
% Created on:   5-17-21
% Last updated: 6-25-21 by J. Davis
%% --------------------------------------------------------------------- %%
function [data] = OSWEC_regularwaves_pre(data,dataopts,t0,tf,fs,plotloop,verbose)
% extract setnames, channels, variable names, and subfields:
setnames = fieldnames(data);
channels = dataopts.channels;
varnames = dataopts.varnames;
subfields = dataopts.subfields;

% extract number of runs and channels in the dataset:
numruns = length(setnames); 
numchs = length(channels);

% initialize results matrix
Results = zeros(numruns,4,numchs);

for i = 1:numruns % loop over dataset runs
    % assign current run of the dataset
    currentrun = setnames{i};
    if verbose==1; disp(['%',repmat('-',1,100),'%',newline,currentrun]); end
    
    for j = 1:numchs % loop over run channels
        % assign current channel of the run
        ch = ['ch',num2str(channels{j})];
        

%         if contains(currentrun,'T13')
%             plotloop = true;
%         else
%             plotloop = false;
%         end
        
        % close any open figures
        close all;
        
        % assign user-defined variable name corresponding to the channel
        varname = varnames{j};
        if verbose==1; disp(varname); end
        
        % assign channel label for plotting; uses dataset map feature
        chlabel = data.(currentrun).map(ch);
        if contains(chlabel,'"')
            chlabel = strip(chlabel,'"');
        end
        % assign user-defined subfield
        subfield = subfields{j};
        
        % initialize subfield:
        data.(currentrun).(subfield) = struct();
        
        % extract data:
        y_raw  = data.(currentrun).(ch);
        t_raw    = data.(currentrun).ch1;
        
        % trim data:
        t_trim = t_raw(t_raw >= t0 & t_raw <= tf)-t0;
        y_trim = y_raw(t_raw >= t0 & t_raw <= tf);
        
        % interpolate the results if zero-valued dropouts are present:
        zeroval_dropoutratio = sum(y_trim==0)/length(y_trim);
        if sum(y_trim==0) > 0
            if zeroval_dropoutratio < 0.30
                disp([num2str(100*zeroval_dropoutratio),'% of the data stored as the variable ',varname,' in the ',subfield,' subfield contains zero-valued dropouts. Interpolating the results.'])
                y_trim = interp1(t_trim(y_trim ~=0),y_trim(y_trim~=0),t_trim);  
            else
                error([num2str(100*zeroval_dropoutratio),'% of the data stored as the variable ',varname,' in the ',subfield,' subfield contains dropouts. Discard recommended.'])
            end
        end
        
        % remove NaNs from interpolation:
        t_trim = t_trim(~isnan(y_trim));
        y_trim = y_trim(~isnan(y_trim));
                
        % store and remove mean:
        means(1) = mean(y_trim); % y_trim =  detrend(y_trim); % y_trim-mean(y_trim(end-round(0.05*length(y_trim)):end-5));\
        y_trim = y_trim - means(1);
        
        % interpolate the results if excessive value dropouts are present:
        exval_threshold =  dataopts.exval_factor*sqrt(2)*rms(y_trim);
        exval_dropoutratio = sum(abs(y_trim) > exval_threshold)/length(y_raw);
        while sum(abs(y_trim) > exval_threshold) > 0
            exval_dropoutratio = sum(abs(y_trim) > exval_threshold)/length(y_raw);
            disp([num2str(100*exval_dropoutratio),'% of the data stored as the variable ',varname,' in the ',subfield,' subfield contains excessive value dropouts. Interpolating the results.'])
            y_trim = interp1(t_trim(y_trim < exval_threshold & y_trim > -exval_threshold),y_trim(y_trim < exval_threshold & y_trim > -exval_threshold),t_trim);
            exval_threshold =  dataopts.exval_factor*sqrt(2)*rms(y_trim);
        end
        
        % remove NaNs from interpolation again:
        t_trim = t_trim(~isnan(y_trim));
        y_trim = y_trim(~isnan(y_trim));
        
        % remove mean now that dropouts have been interpolated:
        means(2) = mean(y_trim);
        y_trim = y_trim - means(2);
        
        % 0.15 for pos; 0.25 for loads
        pkpromfactor = 0.25; % threshold (as proportion of peak FFT value) below which additional peaks are considered insignificant
        [f_trim,Ma_trim,~,~,~,~,~,fft_raw] = pkg.fun.plt_fft(t_trim,y_trim,fs,pkpromfactor);
        dominant_period = fft_raw.dominant_period;
        
        % FILTERING
        % if a subfield-specific filter has been specified, unpack specifications:
        if checkfieldORprop(dataopts,'filters') == 1
            filt = dataopts.filters{j};
            
            % if a cutoff margin is specified, calculate the cutoff frequency based on the dominant fft peak
            if isfield(filt,'cutoff_margin')
                filt.f_cutoff = 1/dominant_period*filt.cutoff_margin; % Hz % filt.f_cutoff = 1/min(dominant_periods)*filt.cutoff_margin;
                
                % if a cutoff frequency is specified, calculate the cutoff margin based on the dominant fft peak
            elseif isfield(filt,'f_cutoff')
                filt.cutoff_margin = filt.f_cutoff*dominant_period;
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
            filt.f_cutoff = 1/dominant_period*filt.cutoff_margin; % Hz
        end
        
        % build the filter:
        f_norm =  filt.f_cutoff/max(f_trim);
        [b,a] = feval(filt.type,filt.order,f_norm,filt.subtype);  % [phi,~] = lowpass(phi_raw,passbandfreq,(2*10^-3)^(-1),'Steepness',0.95);
        [h_filt,f_filt] = freqz(b,a,f_trim,fs);
        h_ma_filt = abs(h_filt);
        h_ph_filt = mod(angle(h_filt)*180/pi,360)-360;
        
        % populate filter field information:
        filt.a = a;
        filt.b = b;
        filt.f_filt = f_filt;
        filt.h_filt = h_filt;
        
        % perform the filtering
        y = filtfilt(b,a,y_trim); % filtfilt neccessary for zero-phase filtering
        t = t_trim;
        means(3) = mean(y);
        y = y - means(3);
        
        % repeat fft, now using the filtered signal
        [f,Ma,~,~,~,~,~,fft_pre] = pkg.fun.plt_fft(t,y,fs,pkpromfactor);
        
        % store period, amplitude, cutoff frequency, and number of significant periods for summary table
        Results(i,1:4,j) = [round(fft_pre.dominant_period,2),round(fft_pre.dominant_amp,2),round(filt.f_cutoff,2),length(fft_pre.significant_periods)];
        
        % display to commmand window
        if verbose==1
            disp(['T = ',num2str(fft_pre.dominant_period)])
            disp(['A = ',num2str(fft_pre.dominant_amp)])
        end
        
        % figures
        if plotloop == true
            % subplot grid 1: (left) raw data; (right) trimmed data
            fig1 = figure;
            fig1.Position(1) = fig1.Position(1) - fig1.Position(3);
            fig1.Position(2) = fig1.Position(2) - fig1.Position(4)/2;
            subplot(1,2,1)
            plot(t_raw,y_raw); hold on
            xline(t0,'LineWidth',1.5); xline(tf,'LineWidth',1.5)
            yline(exval_threshold + sum(means))
            yline(-exval_threshold + sum(means))
            xlabel('t(s)')
            ylabel(chlabel)
            
            subplot(1,2,2)
            plot(t_trim,y_trim); hold on
            xlim([min(t_trim) max(t_trim)])
            ylim(exval_threshold.*[-1 1])
            xlabel('t(s)')
            ylabel(chlabel)
            
            sgtitle(replace(currentrun,'_',' '))
            
            % subplot grid 2: (left) fft of raw trimmed and filtered data;(right) filter response
            fig2 = figure;
            fig2.Position(2) = fig2.Position(2) - fig2.Position(4)/2;
            subplot(2,1,1)
            semilogx(f_trim,Ma_trim,'DisplayName','Original','LineWidth',2); hold on
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
            
            % subplot grid 3: (left) trimmed and filtered signal;(right) filtered signal only
            fig3 = figure;
            fig3.Position(1) = fig3.Position(1) + fig3.Position(3);
            fig3.Position(2) = fig3.Position(2) - fig3.Position(4)/2;
            subplot(1,2,1)
            title(currentrun)
            plot(t_trim,y_trim,'DisplayName','Original'); hold on
            plot(t,y,'DisplayName','Filtered')
            legend()
            xlabel('t(s)')
            ylabel(chlabel)
            ylim(round(1.5*abs(max(y_trim))*[-1 1],2))
            legend()
            
            subplot(1,2,2)
            title(currentrun)
            plot(t,y,'DisplayName','Filtered')
            legend()
            xlabel('t(s)')
            ylabel(chlabel)
            ylim(round(1.5*abs(max(y_trim))*[-1 1],2))
            legend()
            sgtitle(replace(currentrun,'_',' '))
        end
        
        % populate dataset fields
        data.(currentrun).(subfield).t        = t;
        data.(currentrun).(subfield).(varname)= y;
        data.(currentrun).(subfield).trim.t_trim_prefilt = t_trim;
        data.(currentrun).(subfield).trim.y_trim_prefilt = y_trim;
        data.(currentrun).(subfield).trim.t0 = t0;
        data.(currentrun).(subfield).trim.tf = tf;
        data.(currentrun).(subfield).trim.mean_offset = sum(means);
        data.(currentrun).(subfield).trim.zeroval_dropoutratio = zeroval_dropoutratio;
        data.(currentrun).(subfield).trim.exval_dropoutratio = exval_dropoutratio;
        data.(currentrun).(subfield).trim.exval_threshold = exval_threshold;
        data.(currentrun).(subfield).fft.raw  = fft_raw;
        data.(currentrun).(subfield).fft.pre  = fft_pre;
        data.(currentrun).(subfield).filt     = filt;
        
    end
end

% display summary for each variable:
Summary = cell(1,numchs);
for j=1:numchs
    Summary{1,j} = array2table(Results(:,:,j));
    Summary{1,j}.Properties.VariableNames = {'dominant period','dominant amp','f_cutoff','num sig periods'};
    Summary{1,j}.Properties.RowNames = setnames;
    disp(['%',repmat('-',1,100),'%',newline,'SUMMARY OF RESULTS FOR VARIABLE <',varnames{j},'>:'])
    if verbose==1; disp(Summary{1,j}); end
end

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