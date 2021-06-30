%% ------------------------------ Header ------------------------------- %%
% Filename:     VGOSWEC_data.m
% Description:  Script to view NREL VGOSWEC data in .mat file format
% Author:       J. Davis
% Created on:   6-29-21
% Last updated: 6-29-21 by J. Davis
%% ----------------------------- Settings ------------------------------ %%
loaddata = true;                     % load .mat data; only needed once
preprocessed = true;                 % run pre-processed results loop
    preprocessed_dataset = 'VGM90';  % VGM0, VGM10, VGM20, VGM45, or VGM90
postprocessed = true;                % run post-processed results loop
    postprocessed_dataset = 'VGM90'; % VGM0, VGM10, VGM20, VGM45, or VGM90
plotloop = true;                     % show plots for each loop
verbose = true;                      % display key results for each loop
results = true;                      % plot results (e.g. RAO vs period)
%% ---------------------------- Load Data ------------------------------ %%
if loaddata == 1
    load('designwaves.mat')
    load('VGM0_regularwaves.mat')
    load('VGM10_regularwaves.mat')
    load('VGM20_regularwaves.mat')
    load('VGM45_regularwaves.mat')
    load('VGM90_regularwaves.mat')
end
%% -------------------------- Pre-processed ---------------------------- %%
if preprocessed == true
    dataset = eval(preprocessed_dataset);
    setnames = fieldnames(rmfield(dataset,'Results'));
    channels = {7,9,10,11,12,13,14};
    varnames = {'phi','fx','fz','my'};
    subfields = {'position','forceX','forceZ','momentY'};
    % NOTE: uncomment the following varnames and subfields if you want to
    % view every signal. Otherwise, only use phi, fx, fz, and my.
        % varnames = {'phi','fx','fy','fz','mx','my','mz'};
        % subfields = {'position','forceX','forceY','forceZ','momentX','momentY','momentZ'};
            
    % loop over runs:
    for i = 1:length(setnames)
        % assign current run:
        currentrun = setnames{i};
        if verbose==1; disp(['%',repmat('-',1,100),'%',newline,currentrun]); end
        
        % loop over channels, subfields, and varnames:
        for j = 1:length(subfields)
            % assign current channel, subfield, and varname of the run:
            ch = ['ch',num2str(channels{j})];
            subfield = subfields{j};
            varname = varnames{j};
            
            if verbose==1; disp([newline,varname]); end
            
            % assign channel label for plotting; uses preprocessed_dataset map feature
            chlabel = dataset.(currentrun).map(ch);
            if contains(chlabel,'"')
                chlabel = strip(chlabel,'"');
            end
           
            %%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % NOTE 1: to view the figures each channel, place a debugging
            % breakpoint here:
            ;
            % NOTE 2: to stop the loop at a current period, uncomment the
            % following:
            % if contains(currentrun,'T22')
            %    plotloop = true; % and place the breakpoint here.
            % else
            %    plotloop = false;
            % end
            %%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % close open figures from previous loop:
            close all
                        
            % extract raw time and dependent variable signals:
            y_raw  = dataset.(currentrun).(ch);
            t_raw    = dataset.(currentrun).ch1;
            
            % extract trim information
            t0 = dataset.(currentrun).(subfield).trim.t0;
            tf = dataset.(currentrun).(subfield).trim.tf;
            exval_threshold = dataset.(currentrun).(subfield).trim.exval_threshold;
            mean_offset = dataset.(currentrun).(subfield).trim.mean_offset;
            
            % trimmed signals:
            t_trim = dataset.(currentrun).(subfield).trim.t_trim_prefilt;
            y_trim = dataset.(currentrun).(subfield).trim.y_trim_prefilt;
            
            % filtered signals:
            t = dataset.(currentrun).(subfield).t;
            y = dataset.(currentrun).(subfield).(varname);
            
            % extract fft information
            f_trim = dataset.(currentrun).(subfield).fft.raw.f;
            Ma_trim = dataset.(currentrun).(subfield).fft.raw.Ma;
            f = dataset.(currentrun).(subfield).fft.pre.f;
            Ma = dataset.(currentrun).(subfield).fft.pre.Ma;
            significant_periods = dataset.(currentrun).(subfield).fft.pre.significant_periods;
            significant_amps = dataset.(currentrun).(subfield).fft.pre.significant_amps;
            
            % extract filt information
            f_filt = dataset.(currentrun).(subfield).filt.f_filt;
            h_filt = dataset.(currentrun).(subfield).filt.h_filt;
            f_cutoff  = dataset.(currentrun).(subfield).filt.f_cutoff;
            h_ma_filt = abs(h_filt);
            h_ph_filt = mod(angle(h_filt)*180/pi,360)-360;
            
            % display period and amplitudes for current run:
            if verbose == 1
                disp(['f_cutoff = ',num2str(f_cutoff)])
                disp(['significant_periods = ',num2str(significant_periods)])
                disp(['significant_amps = ',num2str(significant_amps)])
            end
            
            if plotloop == 1
                % subplot grid 1: (left) raw data; (right) trimmed data
                fig1 = figure;
                fig1.Position(1) = fig1.Position(1) - fig1.Position(3);
                fig1.Position(2) = fig1.Position(2) - fig1.Position(4)/2;
                subplot(1,2,1)
                plot(t_raw,y_raw); hold on
                xline(t0,'LineWidth',1.5); xline(tf,'LineWidth',1.5)
                yline(exval_threshold + sum(mean_offset))
                yline(-exval_threshold + sum(mean_offset))
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
                xline(f_cutoff,'DisplayName','Cutoff frequency')
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
        end
    end
end
%% -------------------------- Post-processed --------------------------- %%
if postprocessed == true
    dataset = eval(postprocessed_dataset);
    setnames = fieldnames(rmfield(dataset,'Results'));
    subfields = {'position','forceX','forceZ','momentY'};
    varnames = {'phi','fx','fz','my'};
    
    % loop over runs:
    for i = 1:length(setnames)
        currentrun = setnames{i};
        if verbose==1; disp(['%',repmat('-',1,100),'%',newline,currentrun]); end
        
        % loop over subfields and varnames:
        for j = 1:length(subfields)
            subfield = subfields{j};
            varname = varnames{j};
            if verbose==1; disp([newline,varname]); end
            
            %%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % NOTE 1: to view the figures each channel, place a debugging
            % breakpoint here:
            ;
            % NOTE 2: to stop the loop at a current period, uncomment the
            % following:
            % if contains(currentrun,'T22')
            %    plotloop = true; % and place the breakpoint here.
            % else
            %    plotloop = false;
            % end
            %%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % close open figures from previous loop:
            close all
                     
            % extract time and dependent variable signals:
            t = dataset.(currentrun).(subfield).t;
            y = dataset.(currentrun).(subfield).(varname);
            
            % extract dependent variable period and amplitudes:
            T = dataset.(currentrun).(subfield).T;
            A_fft = dataset.(currentrun).(subfield).A_fft;
            A_pks = dataset.(currentrun).(subfield).A_pks;
            
            % extract fft information used to determine amplitude and period:
            f = dataset.(currentrun).(subfield).fft.post.f;
            Ma = dataset.(currentrun).(subfield).fft.post.Ma;
            t0_fft = dataset.(currentrun).(subfield).fft.post.t0;
            tf_fft = dataset.(currentrun).(subfield).fft.post.tf;
            ncycles = dataset.(currentrun).(subfield).fft.post.ncycles;
            
            % extract integer-cycle time and dependent variable signals used in fft:
            t_slice = t(t >= t0_fft & t <= tf_fft);
            y_slice = y(t >= t0_fft & t <= tf_fft);
            
            % display period and amplitudes for current run:
            if verbose == 1
                disp(['T = ',num2str(T)])
                disp(['A_fft = ',num2str(A_fft)])
                disp(['A_pks = ',num2str(A_fft)])
            end
            
            if plotloop == 1
                % plot 1: complete signal
                fig1 = figure;
                fig1.Position(1) = fig1.Position(1) - fig1.Position(3);
                fig1.Position(2) = fig1.Position(2) - fig1.Position(4)/2;
                plot(t,y,'DisplayName','Original','LineWidth',1.25)
                legend()
                xlabel('t(s)')
                ylabel(varname)
                legend()
                xlim([min(t_slice),max(t_slice)])
                sgtitle(replace(currentrun,'_',' '))
                
                % plot 2: sliced signal used to obtain the integer-cycle fft
                fig2 = figure;
                fig2.Position(2) = fig2.Position(2) - fig2.Position(4)/2;
                plot(t,y,'DisplayName','Original','LineWidth',1.25); hold on
                plot(t_slice,y_slice,'DisplayName','Sliced','LineWidth',1.25)
                yline(A_fft,'b','DisplayName','FFT Amp')
                yline(-A_fft,'b','HandleVisibility','off')
                yline(A_pks,'r','DisplayName','Mean +/- Peak Amps')
                yline(-A_pks,'r','HandleVisibility','off')
                legend()
                xlabel('t(s)')
                ylabel(varname)
                legend('Location','southoutside','Orientation','horizontal')
                xlim([min(t),max(t)])
                xl = xlim; yl = ylim;
                text(0.75*xl(2),0.9*yl(1),['ncycles = ',num2str(ncycles)])
                sgtitle(replace(currentrun,'_',' '))
                
                % plot 3: integer-cycle fft used to obtain the amplitude and period
                fig3 = figure;
                fig3.Position(1) = fig3.Position(1) + fig3.Position(3);
                fig3.Position(2) = fig3.Position(2) - fig3.Position(4)/2;
                semilogx(f,Ma,'DisplayName','Sliced','LineWidth',1.25)
                legend()
                xlabel('f(Hz)')
                ylabel(['Ma ',varname])
                legend()
                sgtitle(replace(currentrun,'_',' '))
            end
        end
    end
end
%% ----------------------------- Results ------------------------------- %%
if results == 1
    % wave number:
    k = wave_disp(2*pi./designwaves.Results.eta_wp2.T_mean,1,9.81,0.001);
    
    % normalizations:
    phi_norm = 1;
    RAO_norm = 2*pi/180./(k.*designwaves.Results.eta_wp2.A_pks_mean);
    fx_norm = 1;
    fz_norm = 1;
    my_norm = 1;
   
   % design wave amplitude vs period:
   figure
   errorbar(designwaves.Results.eta_wp2.T_mean,designwaves.Results.eta_wp2.A_pks_mean,designwaves.Results.eta_wp2.A_pks_std,...
       '.','CapSize',0); hold on
   ylabel('wave amplitude (m)')
   xlabel('period (s)')
   
   % pitch displacement vs period:
   figure; hold on
   errorbar(VGM0.Results.phi.T_mean,VGM0.Results.phi.A_fft_mean.*phi_norm,VGM0.Results.phi.A_fft_std.*phi_norm,':o',...
       'DisplayName','VGM0')
   errorbar(VGM10.Results.phi.T_mean,VGM10.Results.phi.A_fft_mean.*phi_norm,VGM10.Results.phi.A_fft_std.*phi_norm,':o',...
       'DisplayName','VGM10')
   errorbar(VGM20.Results.phi.T_mean,VGM20.Results.phi.A_fft_mean.*phi_norm,VGM20.Results.phi.A_fft_std.*phi_norm,':o',...
       'DisplayName','VGM20')
   errorbar(VGM45.Results.phi.T_mean,VGM45.Results.phi.A_fft_mean.*phi_norm,VGM45.Results.phi.A_fft_std.*phi_norm,':o',...
       'DisplayName','VGM45')
   errorbar(VGM90.Results.phi.T_mean,VGM90.Results.phi.A_fft_mean.*phi_norm,VGM90.Results.phi.A_fft_std.*phi_norm,':o',...
       'DisplayName','VGM90')
   legend('Location','northwest')
   ylabel('\phi (deg)')
   xlabel('period (s)')
   
   % RAO vs period:
   figure; hold on
   errorbar(VGM0.Results.phi.T_mean,VGM0.Results.phi.A_fft_mean.*RAO_norm,VGM0.Results.phi.A_fft_std.*RAO_norm,':o',...
       'DisplayName','VGM0')
   errorbar(VGM10.Results.phi.T_mean,VGM10.Results.phi.A_fft_mean.*RAO_norm,VGM10.Results.phi.A_fft_std.*RAO_norm,':o',...
       'DisplayName','VGM10')
   errorbar(VGM20.Results.phi.T_mean,VGM20.Results.phi.A_fft_mean.*RAO_norm,VGM20.Results.phi.A_fft_std.*RAO_norm,':o',...
       'DisplayName','VGM20')
   errorbar(VGM45.Results.phi.T_mean,VGM45.Results.phi.A_fft_mean.*RAO_norm,VGM45.Results.phi.A_fft_std.*RAO_norm,':o',...
       'DisplayName','VGM45')
   errorbar(VGM90.Results.phi.T_mean,VGM90.Results.phi.A_fft_mean.*RAO_norm,VGM90.Results.phi.A_fft_std.*RAO_norm,':o',...
       'DisplayName','VGM90')
   legend('Location','northwest')
   ylabel('\phi/(kA)')
   xlabel('period  (s)')
   
   % Fx vs period:
   figure; hold on
   errorbar(VGM0.Results.fx.T_mean,VGM0.Results.fx.A_fft_mean.*fx_norm,VGM0.Results.fx.A_fft_std.*fx_norm,':o',...
       'DisplayName','VGM0')
   errorbar(VGM10.Results.fx.T_mean,VGM10.Results.fx.A_fft_mean.*fx_norm,VGM10.Results.fx.A_fft_std.*fx_norm,':o',...
       'DisplayName','VGM10')
   errorbar(VGM20.Results.fx.T_mean,VGM20.Results.fx.A_fft_mean.*fx_norm,VGM20.Results.fx.A_fft_std.*fx_norm,':o',...
       'DisplayName','VGM20')
   errorbar(VGM45.Results.fx.T_mean,VGM45.Results.fx.A_fft_mean.*fx_norm,VGM45.Results.fx.A_fft_std.*fx_norm,':o',...
       'DisplayName','VGM45')
   errorbar(VGM90.Results.fx.T_mean,VGM90.Results.fx.A_fft_mean.*fx_norm,VGM90.Results.fx.A_fft_std.*fx_norm,':o',...
       'DisplayName','VGM90')
   legend('Location','northwest')
   ylabel('Fx (N)')
   xlabel('period (s)')
   
   %%% example with amplitude from pks instead of fft:
%    figure; hold on
%    errorbar(VGM0.Results.fx.T_mean,VGM0.Results.fx.A_pks_mean.*fx_norm,VGM0.Results.fx.A_pks_std.*fx_norm,':o',...
%        'DisplayName','VGM0')
%    errorbar(VGM10.Results.fx.T_mean,VGM10.Results.fx.A_pks_mean.*fx_norm,VGM10.Results.fx.A_pks_std.*fx_norm,':o',...
%        'DisplayName','VGM10')
%    errorbar(VGM20.Results.fx.T_mean,VGM20.Results.fx.A_pks_mean.*fx_norm,VGM20.Results.fx.A_pks_std.*fx_norm,':o',...
%        'DisplayName','VGM20')
%    errorbar(VGM45.Results.fx.T_mean,VGM45.Results.fx.A_pks_mean.*fx_norm,VGM45.Results.fx.A_pks_std.*fx_norm,':o',...
%        'DisplayName','VGM45')
%    errorbar(VGM90.Results.fx.T_mean,VGM90.Results.fx.A_pks_mean.*fx_norm,VGM90.Results.fx.A_pks_std.*fx_norm,':o',...
%        'DisplayName','VGM90')
%    legend('Location','northwest')
%    ylabel('Fx (N)')
%    xlabel('period (s)')
   
   % Fz vs period:
   figure; hold on
   errorbar(VGM0.Results.fz.T_mean,VGM0.Results.fz.A_fft_mean.*fz_norm,VGM0.Results.fz.A_fft_std.*fz_norm,':o',...
       'DisplayName','VGM0')
   errorbar(VGM10.Results.fz.T_mean,VGM10.Results.fz.A_fft_mean.*fz_norm,VGM10.Results.fz.A_fft_std.*fz_norm,':o',...
       'DisplayName','VGM10')
   errorbar(VGM20.Results.fz.T_mean,VGM20.Results.fz.A_fft_mean.*fz_norm,VGM20.Results.fz.A_fft_std.*fz_norm,':o',...
       'DisplayName','VGM20')
   errorbar(VGM45.Results.fz.T_mean,VGM45.Results.fz.A_fft_mean.*fz_norm,VGM45.Results.fz.A_fft_std.*fz_norm,':o',...
       'DisplayName','VGM45')
   errorbar(VGM90.Results.fz.T_mean,VGM90.Results.fz.A_fft_mean.*fz_norm,VGM90.Results.fz.A_fft_std.*fz_norm,':o',...
       'DisplayName','VGM90')
   legend('Location','northwest')
   ylabel('Fz (N)')
   xlabel('period (s)')
   
   % My vs period:
   figure; hold on
   errorbar(VGM0.Results.my.T_mean,VGM0.Results.my.A_fft_mean.*my_norm,VGM0.Results.my.A_fft_std.*my_norm,':o',...
       'DisplayName','VGM0')
   errorbar(VGM10.Results.my.T_mean,VGM10.Results.my.A_fft_mean.*my_norm,VGM10.Results.my.A_fft_std.*my_norm,':o',...
       'DisplayName','VGM10')
   errorbar(VGM20.Results.my.T_mean,VGM20.Results.my.A_fft_mean.*my_norm,VGM20.Results.my.A_fft_std.*my_norm,':o',...
       'DisplayName','VGM20')
   errorbar(VGM45.Results.my.T_mean,VGM45.Results.my.A_fft_mean.*my_norm,VGM45.Results.my.A_fft_std.*my_norm,':o',...
       'DisplayName','VGM45')
   errorbar(VGM90.Results.my.T_mean,VGM90.Results.my.A_fft_mean.*my_norm,VGM90.Results.my.A_fft_std.*my_norm,':o',...
       'DisplayName','VGM90')
   legend('Location','northwest')
   ylabel('My (N-m)')
   xlabel('period (s)')
   
   % Sample comparison of pitch amplitude approxiated from pks and fft:
   figure
   errorbar(VGM90.Results.phi.T_mean,VGM90.Results.phi.A_pks_mean,VGM90.Results.phi.A_pks_std,'o',...
       'DisplayName','VGM90 pks'); hold on
   errorbar(VGM90.Results.phi.T_mean,VGM90.Results.phi.A_fft_mean,VGM90.Results.phi.A_fft_std,'o',...
       'DisplayName','VGM90 fft');
   legend('Location','northwest')
   ylabel('\phi (deg)')
   xlabel('period (s)')
end
%% --------------------------- Subfunctions ---------------------------- %%

function [k] = wave_disp(w,h,g,allowable_error)
k_n = w.^2/g; % make a first guess of k using deep water approximation
err = ones(size(w)); % initialize error

% iterate until max element-wise error is reduced to allowable error:
while max(err) > allowable_error
    w_n = sqrt(g*k_n.*tanh(k_n*h));  % compute new w
    k_n = w.^2./(g*tanh(k_n*h));     % compute new k
    err = abs(w_n - w)./w;           % compute error
end
k = k_n; % assign output as final k

end
