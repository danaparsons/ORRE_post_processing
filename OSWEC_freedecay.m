%% ------------------------------ Header ------------------------------- %%
% Filename:     OSWEC_freedecay.m
% Description:  Post-process OSWEC-type model free decay experiments
% Author:       J. Davis
% Created on:   5-13-21
% Last updated: 5-13-21 by J. Davis
%% --------------------------------------------------------------------- %%
function [data] = OSWEC_freedecay(data,dataopts,plotloop)
subfield = 'position';
setnames = fieldnames(data);
numruns = length(setnames); % number of fields in the dataset

% initialize vector to store results
Tn_fft      = zeros(numruns,1); 
wn_fft      = zeros(numruns,1); 
Tn_pks      = zeros(numruns,1); 
wn_pks      = zeros(numruns,1); 
phi0    = zeros(numruns,1); 
zeta_logdec    = zeros(numruns,1); 
xk = cell(numruns,1);
y_ax = cell(numruns,1);

for i = 1:numruns
    
    % assign current run of the dataset
    run = setnames{i};
    disp(run)
    
    
%     if contains(run,'PHIpos5_2')
%        plotloop = true
%     else
%        plotloop = false
%     end
    
    
    % close any open figures
    close all
    
    % assign raw data
    phi_raw  = data.(run).(['ch',num2str(dataopts.phi_ch)]);
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
    
    % identify initial position 
    [t0,phi0(i),~,~] = fdecay_peaks(t_raw,phi_raw,phi0sign,dataopts.phi0_pkpromfactor,dataopts.minwidth);
    
    if isfield(dataopts,'max_duration')
        tmax = dataopts.max_duration;
    else
        tmax = t_raw(end);
    end
    
    % slice data
    t_slice    = t_raw(t_raw >= t0 & t_raw <= t0+tmax)-t0;
    phi_raw_slice  = phi_raw(t_raw >= t0 & t_raw <= t0+tmax);
    
    % remove mean again
%     phi_raw_slice = detrend(phi_raw_slice);

    % FFT of raw data
    [f_raw,P_raw,~,~,~,~,~,fft_raw] = pkg.fun.plt_fft(t_slice,phi_raw_slice,dataopts.fs,dataopts.fft_pkpromfactor);
    
    if isfield(dataopts,'min_period') && fft_raw.dominant_period < dataopts.min_period
        dominant_period = max(fft_raw.significant_periods(fft_raw.significant_periods > dataopts.min_period));
    elseif isfield(dataopts,'max_period') && fft_raw.dominant_period > dataopts.max_period
        dominant_period = max(fft_raw.significant_periods(fft_raw.significant_periods < dataopts.max_period));
    else
        dominant_period = fft_raw.dominant_period;
    end
    
     % implement a preliminary lowpass filter, if one has not already been specified.
    if checkfieldORprop(data,run,subfield,'filter') == 0
        
        % specifications
        type = 'butter';
        subtype = 'low';
        order = 4;
        cutoff_margin = 5; %%% consider 4 or 5
        
        % specify the cutoff frequency based on the dominant fft peaks
        f_cutoff = 1/dominant_period*cutoff_margin; % Hz
        
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
    [h_filt,f_filt] = freqz(b,a,f_raw,dataopts.fs);
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
%     if dataots.usesecondpk == 1; t0_fft = pklocs(2);
%     else t0_fft = t0;
%     end
    
    [f,P,~,~,~,~,~,fft_out] = pkg.fun.plt_fft(t_slice,phi,dataopts.fs,dataopts.fft_pkpromfactor);
    Tn_fft(i) = dominant_period;
    disp(['Tn_fft = ',num2str(Tn_fft(i))])
    
   % quad damping identification:

   % identify pks   
    pks_pkprom = dataopts.pks_pkpromfactor*max(phi_raw*pi/180);

    [side1pks, side1locs] = findpeaks(phi*pi/180,t,'MinPeakProminence',pks_pkprom,'MinPeakHeight',0.1*max(phi_raw*pi/180),'Annotate','extents');
    [side2pks, side2locs] = findpeaks(-phi*pi/180,t,'MinPeakProminence',pks_pkprom,'MinPeakHeight',0.1*max(phi_raw*pi/180),'Annotate','extents');

    Tside1 = diff(side1locs);
    Tside2 = diff(side2locs);
    Tn_pks(i) = mean([Tside1;Tside2]);
    disp(['Tn_pks = ',num2str(Tn_pks(i))])
    
    phi_km1 = side1pks(1:end-2);
    phi_kp1 = side1pks(3:end);
    
    phi_km1_side2 = side2pks(1:end-2);
    phi_kp1_side2 = side2pks(3:end);

    
    y_ax_side1 =  1/(2*pi)*log(phi_km1./phi_kp1);
    xk_side1 = side1pks(2:end-1);
    
    y_ax_side2 =  1/(2*pi)*log(phi_km1_side2./phi_kp1_side2);
    xk_side2 = side2pks(2:end-1);
    
    y_ax_presort = [y_ax_side1;y_ax_side2];
    [xk{i}, idx] = sort([xk_side1;xk_side2]);
    y_ax{i} = y_ax_presort(idx);
    [p,S] = polyfit(xk{i},y_ax{i},1);
    zeta_quaddamp = p(2);
    m_quaddamp = p(1);
    Rsq_quaddamp = 1 - (S.normr/norm(y_ax{i} - mean(y_ax{i})))^2;
    
    zeta_side1 = logdec(side1pks,1);
    zeta_side2 = logdec(side2pks,1);
    zeta_logdec(i) = mean([zeta_side1;zeta_side2]);
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
            plot(t,phi,'DisplayName','Filtered'); hold on
            plot(side1locs,side1pks*180/pi,'o','DisplayName','Side 1 Peaks')
            plot(side2locs,-side2pks*180/pi,'o','DisplayName','Side 2 Peaks')
            legend()
            xlabel('t(s)')
            ylabel('phi (deg)')
            ylim(round(1.5*abs(phi0(i))*[-1 1],2))
            legend()  
            sgtitle(replace(run,'_',' '))
            
            figure
                x0=4; y0=4;
                width=4.0;
                height=4.0;
                set(gcf,'units','inches','position',[x0,y0,width,height])
                plot([0 ceil(max(xk{i}))],p(2)+[0 ceil(max(xk{i}))]*p(1),'Color',[200 200 200]./255,'LineWidth',1.5); hold on
                scatter(xk{i},y_ax{i},25,'o',...
                    'MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.9,'MarkerFaceColor','k','MarkerEdgeColor','k')
                set(gca,'FontSize',12)
                xlabel('$\phi_k$','Interpreter','Latex','FontSize',18)
                ylabel('$\frac{1}{2\pi} \ln \frac{\phi_{k-1}}{\phi_{k+1}}$','Interpreter','Latex','FontSize',18)
                %     set(gca,'TickLabelInterpreter','latex')
                %     ylim([round(1.5*min(y_ax_combined),2) round(1.5*max(y_ax_combined),2)])
                %     xlim([0 round(1.5*max([max(xk_combined) max(y_ax_combined)]),2)])
                ylim([round(0.7*min(y_ax{i}),1) round(1.2*max(y_ax{i}),1)])
                xlim([0 round(1.2*max(xk{i}),3)])
                xl = xlim; yl = ylim;
                text(0.7*xl(2),1.25*yl(1),...
                    ['$\zeta \,\,\;= ',num2str(round(zeta_quaddamp,3)),'$',...
                    char(10),'$m \; = ',num2str(round(m_quaddamp,3)),'$',...
                    char(10),'$R^2 = ',num2str(round(Rsq_quaddamp,3)),'$'],...
                    'Interpreter','Latex','FontSize',12)
                pbaspect([1 1 1])
    end
    
    % angular frequency:
    wn_fft(i)  = 2*pi/Tn_fft(i);
    wn_pks(i)  = 2*pi/Tn_pks(i);
    
    % populate fields:
    data.(run).(subfield).t    = t;
    data.(run).(subfield).phi  = phi;
    data.(run).(subfield).t0   = t0;
    data.(run).(subfield).phi0 = phi0(i);
    data.(run).(subfield).Tn_fft   = Tn_fft(i);
    data.(run).(subfield).Tn_pks   = Tn_pks(i);
    data.(run).(subfield).wn_fft   = wn_fft(i);
    data.(run).(subfield).wn_pks   = wn_pks(i);
    data.(run).(subfield).logdec.zeta_side1 = zeta_side1;
    data.(run).(subfield).logdec.zeta_side2 = zeta_side2;
    data.(run).(subfield).logdec.zeta  = zeta_logdec(i);
    data.(run).(subfield).quaddamp.xk = xk{i};
    data.(run).(subfield).quaddamp.y_ax = y_ax{i};
    data.(run).(subfield).quaddamp.zeta = zeta_quaddamp;
    data.(run).(subfield).quaddamp.m    = m_quaddamp;
    data.(run).(subfield).quaddamp.Rsq = Rsq_quaddamp;
    data.(run).(subfield).fft      = fft_out;
    data.(run).(subfield).filter   = filter;

end

xk_combined = vertcat(xk{:});
y_ax_combined = vertcat(y_ax{:});
[xk_combined,idx] = sort(xk_combined);
y_ax_combined = y_ax_combined(idx);

[p,S] = polyfit(xk_combined,y_ax_combined,1);
Rsq_quaddamp = 1 - (S.normr/norm(y_ax_combined - mean(y_ax_combined)))^2;
zeta_quaddamp    = p(2);
m_quaddamp       = p(1);

% plot quadratic damping ID fit:
markercolor = 'k';
markeralpha = 0.65;

figure
x0=4; y0=4;
width=4.0;
height=4.0;
set(gcf,'units','inches','position',[x0,y0,width,height])
plot([0 ceil(max(xk_combined))],p(2)+[0 ceil(max(xk_combined))]*p(1),'Color',[200 200 200]./255,'LineWidth',1.5); hold on
scatter(xk_combined,y_ax_combined,25,'o',...
    'MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor,'MarkerEdgeColor',markercolor)
set(gca,'FontSize',12)
xlabel('$\phi_k$','Interpreter','Latex','FontSize',18)
ylabel('$\frac{1}{2\pi} \ln \frac{\phi_{k-1}}{\phi_{k+1}}$','Interpreter','Latex','FontSize',18)
%     set(gca,'TickLabelInterpreter','latex')
%     ylim([round(1.5*min(y_ax_combined),2) round(1.5*max(y_ax_combined),2)])
%     xlim([0 round(1.5*max([max(xk_combined) max(y_ax_combined)]),2)])
ylim([round(0.7*min(y_ax_combined),1) round(1.2*max(y_ax_combined),1)])
xlim([0 round(1.2*max(xk_combined),3)])
xl = xlim; yl = ylim;
text(0.7*xl(2),1.25*yl(1),...
    ['$\zeta \,\,\;= ',num2str(round(zeta_quaddamp,3)),'$',...
    char(10),'$m \; = ',num2str(round(m_quaddamp,3)),'$',...
    char(10),'$R^2 = ',num2str(round(Rsq_quaddamp,3)),'$'],...
    'Interpreter','Latex','FontSize',12)
pbaspect([1 1 1])

% compute basic statistics
Tn_fft_mean  = mean(Tn_fft); Tn_fft_std = std(Tn_fft);
wn_fft_mean = mean(wn_fft); wn_fft_std  = std(wn_fft);
Tn_pks_mean  = mean(Tn_pks); Tn_pks_std = std(Tn_pks);
wn_pks_mean = mean(wn_pks); wn_pks_std  = std(wn_pks);
zeta_logdec_mean = mean(zeta_logdec); zeta_logdec_std = std(zeta_logdec);

% visualize results
figure; hold on
scatter(phi0,wn_fft,'o','MarkerFaceColor','r','MarkerEdgeColor','r','DisplayName','observations, fft')
yline(wn_fft_mean,'r','LineWidth',1.5,'DisplayName','mean, fft')
inBetween = [(wn_fft_mean+wn_fft_std)*[1 1], fliplr((wn_fft_mean-wn_fft_std)*[1 1])];
fill([xlim, fliplr(xlim)], inBetween, 'r','FaceAlpha',0.1,'EdgeColor','none','DisplayName','1 stdev, fft')

scatter(phi0,wn_pks,'o','MarkerFaceColor','b','MarkerEdgeColor','b','DisplayName','observations, pks')
yline(wn_pks_mean,'b','LineWidth',1.5,'DisplayName','mean, pks')
inBetween = [(wn_pks_mean+wn_pks_std)*[1 1], fliplr((wn_pks_mean-wn_pks_std)*[1 1])];
fill([xlim, fliplr(xlim)], inBetween, 'b','FaceAlpha',0.1,'EdgeColor','none','DisplayName','1 stdev, pks')
%     ylim([0.9 1.1]*wn_mean)
xlabel('\phi_{0} (deg)')
ylabel('w_{n} (rad/s)')
legend('Location','Best')

tabulated = table(phi0,wn_fft,wn_pks,Tn_fft,Tn_pks,zeta_logdec);
tabulated.Properties.RowNames = setnames;

% initialize results structure
data.results = [];

% populate
data.results.Tn_fft    = Tn_fft;
data.results.wn_fft    = wn_fft;
data.results.Tn_pks    = Tn_pks;
data.results.wn_pks    = wn_pks;
data.results.zeta_logdec    = zeta_logdec;
data.results.wn_fft_mean     = wn_fft_mean;
data.results.wn_fft_std      = wn_fft_std;
data.results.Tn_fft_mean     = Tn_fft_mean;
data.results.Tn_fft_std      = Tn_fft_std;
data.results.wn_pks_mean     = wn_pks_mean;
data.results.wn_pks_std      = wn_pks_std;
data.results.Tn_pks_mean     = Tn_pks_mean;
data.results.Tn_pks_std      = Tn_pks_std;
data.results.zeta_logdec_mean = zeta_logdec_mean;
data.results.zeta_logdec_std = zeta_logdec_std;
data.results.Rsq_quaddamp = Rsq_quaddamp; 
data.results.zeta_quaddamp  = zeta_quaddamp; 
data.results.m_quaddamp = m_quaddamp; 
data.results.xk_combined = xk_combined;
data.results.y_ax_combined = y_ax_combined;
data.results.tabulated   = tabulated;

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

function [t0,phi0,pks,pklocs] = fdecay_peaks(t,phi_raw,phi0sign,pkpromfactor,minwidth)
    
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
    
    % store and sort pks by location
    [pklocs,idx] = sort([side1pks; side2pks]);
    pks = [side1locs; side2locs];
    pks = pks(idx);
    
    clear side1pks side1locs side2pks side2locs secondpkloc firstpklocs firstpkloc firstpk
end

function [damping_ratio] = logdec(pks,n)

x0 = pks(1:end-n);
xn = pks(1+n:end);

delta = 1/n * log(x0./xn);

damping_ratio = sqrt(1+(2*pi./delta).^2).^(-1);

end

