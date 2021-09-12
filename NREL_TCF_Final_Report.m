%% ------------------------------ Header ------------------------------- %%
% Filename:     JDavis_MSThesis.m
% Description:  NREL TCF Final Report figures from OSWEC and VGOSWEC data
% Author:       J. Davis
% Created on:   7-9-21
% Last updated: 7-9-21 by J. Davis
%% ------------------------------ Inputs ------------------------------- %%
markercolor_c = [135, 0, 0]./255;
markercolor_cws = [6, 62, 117]./255;
markercolor_VGM90 = '#F00';
markercolor_VGM45 ='#F80';
markercolor_VGM20 ='#0B0';
markercolor_VGM10 ='#00F';
markercolor_VGM0 ='k';
markeralpha = 0.65;
%% ----------------------------- System ID ----------------------------- %%
load('data/NREL_OSWEC/_processed/freedecay_column.mat')
% load('data/NREL_OSWEC/_processed/freedecay_column_w_springs.mat')
load('data/NREL_VGOSWEC/_processed/freedecay_VGM0')
load('data/NREL_VGOSWEC/_processed/freedecay_VGM10')
load('data/NREL_VGOSWEC/_processed/freedecay_VGM20')
load('data/NREL_VGOSWEC/_processed/freedecay_VGM45')
load('data/NREL_VGOSWEC/_processed/freedecay_VGM90')

displayname_c = 'no external springs';
displayname_cws = 'external springs';
pitchresponse_label = 'Pitch $\phi(t)$ (deg)';
time_label = 'Time $t$ (s)';
% Fit plots:

% column
figure
    x0=4; y0=4;
    width=4.0;
    height=4.0;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    plot([0 ceil(max(freedecay_c.results.xk_combined))],...
        freedecay_c.results.zeta_quaddamp +[0 ceil(max(freedecay_c.results.xk_combined))]*freedecay_c.results.m_quaddamp,...
        'Color',[200 200 200]./255,'LineWidth',1.5); hold on
    scatter(freedecay_c.results.xk_combined,freedecay_c.results.y_ax_combined,25,'o',...
        'MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_c,'MarkerEdgeColor',markercolor_c)
    set(gca,'FontSize',12)
        xlabel('$\phi_k$','Interpreter','Latex','FontSize',18)
        ylabel('$\frac{1}{2\pi} \ln \frac{\phi_{k-1}}{\phi_{k+1}}$','Interpreter','Latex','FontSize',18)
        %     set(gca,'TickLabelInterpreter','latex')
        ylim([round(0.7*min(freedecay_c.results.y_ax_combined),1) round(1.2*max(freedecay_c.results.y_ax_combined),1)])
        % xlim([0 round(1.2*max(freedecay_c.results.xk_combined),3)])
        xlim([0 0.12])
        xticks(0:0.02:.12)
        xl = xlim; yl = ylim;
        text(0.7*xl(2),1.25*yl(1),...
            ['$\zeta \,\,\;= ',num2str(round(freedecay_c.results.zeta_quaddamp,3)),'$',...
            char(10),'$m \; = ',num2str(round(freedecay_c.results.m_quaddamp,3)),'$',...
            char(10),'$R^2 = ',num2str(round(freedecay_c.results.Rsq_quaddamp,3)),'$'],...
            'Interpreter','Latex','FontSize',12)
        pbaspect([1 1 1])
f = gcf;
% exportgraphics(f,'nonlineardampingID_c.png','Resolution',600)

% column w springs
figure
    x0=4; y0=4;
    width=4.0;
    height=4.0;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    plot([0 ceil(max(freedecay_cws.results.xk_combined))],...
        freedecay_cws.results.zeta_quaddamp +[0 ceil(max(freedecay_cws.results.xk_combined))]*freedecay_cws.results.m_quaddamp,...
        'Color',[200 200 200]./255,'LineWidth',1.5); hold on
    scatter(freedecay_cws.results.xk_combined,freedecay_cws.results.y_ax_combined,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_cws,'MarkerEdgeColor',markercolor_cws)
    set(gca,'FontSize',12)
        xlabel('$\phi_k$','Interpreter','Latex','FontSize',18)
        ylabel('$\frac{1}{2\pi} \ln \frac{\phi_{k-1}}{\phi_{k+1}}$','Interpreter','Latex','FontSize',18)
        %     set(gca,'TickLabelInterpreter','latex')
        ylim([round(0.7*min(freedecay_cws.results.y_ax_combined),1) round(1.2*max(freedecay_cws.results.y_ax_combined),1)])
        % xlim([0 round(1.2*max(freedecay_cws.results.xk_combined),3)])
        xlim([0 0.12])
        xticks(0:0.02:.12)
        xl = xlim; yl = ylim;
        text(0.7*xl(2),1.25*yl(1),...
            ['$\zeta \,\,\;= ',num2str(round(freedecay_cws.results.zeta_quaddamp,3)),'$',...
            char(10),'$m \; = ',num2str(round(freedecay_cws.results.m_quaddamp,3)),'$',...
            char(10),'$R^2 = ',num2str(round(freedecay_cws.results.Rsq_quaddamp,3)),'$'],...
            'Interpreter','Latex','FontSize',12)
        pbaspect([1 1 1])  
f = gcf;
% exportgraphics(f,'nonlineardampingID_cws.png','Resolution',600)


% freedecay sample c
figure
    x0=4; y0=4;
    width=6.0;
    height=3.0;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    plot(freedecay_c.PHIneg15_1.position.t,freedecay_c.PHIneg15_1.position.phi,...
        'LineWidth',1.25,'Color',markercolor_c,'DisplayName','Experiment')
    xlabel('time (s)')
    ylabel('pitch displacement (deg)')
    ylim([-30 30])
%     xlim([freedecay_c_wecsim.time(1) freedecay_c_wecsim.time(end)])
    xl = xlim; yl = ylim;
    xlabel(time_label,'Interpreter','Latex')
    ylabel(pitchresponse_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthEast')
    set(gca,'FontSize',10); box on
f = gcf;
% exportgraphics(f,'freedecay_c.png','Resolution',900)
% saveas(f,'freedecay_c.fig')


% freedecay sample cws
figure
    x0=4; y0=4;
    width=6.0;
    height=3.0;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    plot(freedecay_cws.PHIneg15_2.position.t,freedecay_cws.PHIneg15_2.position.phi,...
        'LineWidth',1.25,'Color',markercolor_cws,'DisplayName','Experiment')
    xlabel('time (s)')
    ylabel('pitch displacement (deg)')
    ylim([-30 30])
%     xlim([freedecay_c_wecsim.time(1) freedecay_c_wecsim.time(end)])
    xl = xlim; yl = ylim;
    xlabel(time_label,'Interpreter','Latex')
    ylabel(pitchresponse_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthEast')
    set(gca,'FontSize',10); box on
f = gcf;
% exportgraphics(f,'freedecay_cws.png','Resolution',900)
% saveas(f,'freedecay_cws.fig')


% freedecay sample VGM0
figure
    x0=4; y0=4;
    width=6.0;
    height=3.0;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    plot(freedecay_VGM0.PHIneg15_VGM0_1.position.t,freedecay_VGM0.PHIneg15_VGM0_1.position.phi,...
        'LineWidth',1.25,'Color',markercolor_VGM0,'DisplayName','VGM0')
    xlabel('time (s)')
    ylabel('pitch displacement (deg)')
    ylim([-30 30])
%     xlim([freedecay_c_wecsim.time(1) freedecay_c_wecsim.time(end)])
    xl = xlim; yl = ylim;
    xlabel(time_label,'Interpreter','Latex')
    ylabel(pitchresponse_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthEast')
    set(gca,'FontSize',10); box on
f = gcf;
% exportgraphics(f,'freedecay_cws.png','Resolution',900)
% saveas(f,'freedecay_cws.fig')


% freedecay sample VGM90
figure
    x0=4; y0=4;
    width=6.0;
    height=3.0;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    plot(freedecay_VGM90.PHIneg15_VGM90_1.position.t,freedecay_VGM90.PHIneg15_VGM90_1.position.phi,...
        'LineWidth',1.25,'Color',markercolor_VGM90,'DisplayName','VGM90')
    xlabel('time (s)')
    ylabel('pitch displacement (deg)')
    ylim([-30 30])
%     xlim([freedecay_c_wecsim.time(1) freedecay_c_wecsim.time(end)])
    xl = xlim; yl = ylim;
    xlabel(time_label,'Interpreter','Latex')
    ylabel(pitchresponse_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthEast')
    set(gca,'FontSize',10); box on
f = gcf;
% exportgraphics(f,'freedecay_cws.png','Resolution',900)
% saveas(f,'freedecay_cws.fig')


% freedecay sample superimposed
figure
    x0=4; y0=4;
    width=6.0;
    height=3.0;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    plot(freedecay_VGM0.PHIneg15_VGM0_1.position.t,...
        freedecay_VGM0.PHIneg15_VGM0_1.position.phi/freedecay_VGM0.PHIneg15_VGM0_1.position.phi0,...
        'LineWidth',1.25,'Color',markercolor_VGM0,'DisplayName','VGM0'); hold on
    plot(freedecay_VGM10.PHIneg15_VGM10_2.position.t,...
        freedecay_VGM10.PHIneg15_VGM10_2.position.phi/freedecay_VGM10.PHIneg15_VGM10_2.position.phi0,...
        'LineWidth',1.25,'Color',markercolor_VGM10,'DisplayName','VGM10'); hold on
    plot(freedecay_VGM20.PHIneg15_VGM20_1.position.t,...
        freedecay_VGM20.PHIneg15_VGM20_1.position.phi/freedecay_VGM20.PHIneg15_VGM20_1.position.phi0,...
        'LineWidth',1.25,'Color',markercolor_VGM20,'DisplayName','VGM20'); hold on
    plot(freedecay_VGM45.PHIneg15_VGM45_1.position.t,...
        freedecay_VGM45.PHIneg15_VGM45_1.position.phi/freedecay_VGM45.PHIneg15_VGM45_1.position.phi0,...
        'LineWidth',1.25,'Color',markercolor_VGM45,'DisplayName','VGM45'); hold on
    plot(freedecay_VGM90.PHIpos15_VGM90_1.position.t,...
        freedecay_VGM90.PHIpos15_VGM90_1.position.phi/freedecay_VGM90.PHIpos15_VGM90_1.position.phi0,...
        'LineWidth',1.25,'Color',markercolor_VGM90,'DisplayName','VGM90')
    xlabel('time (s)')
    xlim([0 20])
    xl = xlim; yl = ylim;
    xlabel(time_label,'Interpreter','Latex')
    ylabel('Normalized pitch displacement','Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthEast')
    set(gca,'FontSize',10); box on
f = gcf;
exportgraphics(f,'freedecay_VGM_comparison.png','Resolution',300)
saveas(f,'freedecay_VGM_comparison.fig')

%% ----------------------- Regular Waves, OSWEC ------------------------ %%
   load('data/NREL_OSWEC/_processed/designwaves_column_w_springs.mat')
   load('data\NREL_OSWEC\_processed\designwaves_column.mat')
   load('data\NREL_OSWEC\_processed\regularwaves_column_w_springs.mat')
   load('data\NREL_OSWEC\_processed\regularwaves_column.mat')

   
   % settings
   
   H_O= 0.5;
   g = 9.81;
   rho = 1000;
   w = 0.4;
   k_c = wave_disp(2*pi./designwaves_c.Results.eta_wp2.T_mean,1,9.81,0.001);
   k_cws = wave_disp(2*pi./designwaves_cws.Results.eta_wp2.T_mean,1,9.81,0.001);
   

   phi_norm = 1;
   pitchresponse_norm_c = 1;
   pitchresponse_norm_cws = 1;
   RAO_norm_c = 2*pi/180./(k_c.*designwaves_c.Results.eta_wp2.A_pks_mean);
   RAO_norm_cws = 2*pi/180./(k_cws.*designwaves_cws.Results.eta_wp2.A_pks_mean);
   RAO_norm_c = pi/180./(k_c.*designwaves_c.Results.eta_wp2.A_pks_mean);
   RAO_norm_cws = pi/180./(k_cws.*designwaves_cws.Results.eta_wp2.A_pks_mean);

%    fx_norm_c = 1./designwaves_c.Results.eta_wp2.A_pks_mean;
%    fx_norm_cws = 1./designwaves_cws.Results.eta_wp2.A_pks_mean;
   fx_norm_c = designwaves_c.Results.eta_wp2.A_pks_mean;
   fx_norm_cws =designwaves_cws.Results.eta_wp2.A_pks_mean; 
%    fz_norm = 1;
   my_norm_c = 1/6*rho*g*w*H_O^2*designwaves_c.Results.eta_wp2.A_pks_mean;
   my_norm_cws = 1/6*rho*g*w*H_O^2*designwaves_cws.Results.eta_wp2.A_pks_mean; 

%   designwaves_cws.Results.eta_wp2.k = k_cws;
%   designwaves_cws.Results.eta_wp2.L = 2*pi./k_cws;
%   designwaves_cws.Results.eta_wp2.hdivL = h./designwaves_cws.Results.eta_wp2.L;
%   designwaves_cws.Results.eta_wp2.HdivL = 2*designwaves_cws.Results.eta_wp2.A_fft_mean./designwaves_cws.Results.eta_wp2.L; 
displayname_c = 'No external springs';
displayname_cws = 'External springs';
period_label = 'Period $T$ (s)';
time_label = 'Time $t$ (s)';
angularfrequency_label = 'Angular Frequency $\omega$  (rad/s)';
waveamp_label = 'Wave Amplitude $a$ (mm)';
pitchresponse_label = 'Pitch Amplitude $|\phi|$ (deg)';
RAO_label = '$\mathrm{RAO*}$ (-)';
fx_label = ['Foundation Surge Reaction ',char(10),'Force Magnitude $|F_{fr1}|$ (N)'];
fz_label = ['Foundation Heave Reaction ',char(10),'Force Magnitude $|F_{fr3}|$ (N)'];
my_label = ['Foundation Pitch Reaction ',char(10),'Moment Magnitude $|M_{Mr5}|$ (N-m)'];
TAP_label = ['Time Averaged Power (W)'];
CWR_label = ['Capture Width (W/W)'];
PTO_torque_label = ['Power Takeoff Torque ',char(10),'Magnitude $|T_{PTO}|$ (N-m)'];
    % data
% Design wave conditions
figure(); hold on
    x0=4; y0=4;
    width=4; height=4;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter([designwaves_cws.Results.eta_wp2.T{:}],[designwaves_cws.Results.eta_wp2.A_fft{:}]*1000,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_cws,'MarkerEdgeColor',markercolor_cws,'DisplayName','External springs only')
    scatter([designwaves_c.Results.eta_wp2.T{:}],[designwaves_c.Results.eta_wp2.A_fft{:}]*1000,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','Both configurations')
    legend('Location','northwest')
    ylabel('foundation reaction moment (N-m)')
    xlabel('period  (s)')
    ylabel(waveamp_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    pbaspect([1 1 1])
    f = gcf;
%     exportgraphics(f,'designwaves.png','Resolution',600)
%     saveas(f,'designwaves.fig')

% Pitch response
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter([regularwaves_c.Results.phi.T{:}],[regularwaves_c.Results.phi.A_fft{:}]*pitchresponse_norm_c,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_c,'MarkerEdgeColor',markercolor_c,'DisplayName',displayname_c)
    scatter([regularwaves_cws.Results.phi.T{:}],[regularwaves_cws.Results.phi.A_fft{:}]*pitchresponse_norm_cws,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_cws,'MarkerEdgeColor',markercolor_cws,'DisplayName',displayname_cws)
    legend('Location','northwest')
    ylabel(pitchresponse_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
%     exportgraphics(f,'pitchresponse.png','Resolution',600)
%     saveas(f,'pitchresponse.fig')    
    
    
% Response amplitude operator
C1 = cellfun(@(x,y) x.*y, regularwaves_c.Results.phi.A_fft, num2cell(RAO_norm_c), 'UniformOutput',false);
C2 = cellfun(@(x,y) x.*y, regularwaves_cws.Results.phi.A_fft, num2cell(RAO_norm_cws), 'UniformOutput',false);
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter([regularwaves_c.Results.phi.T{:}],[C1{:}],...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_c,'MarkerEdgeColor',markercolor_c,'DisplayName',displayname_c)
    scatter([regularwaves_cws.Results.phi.T{:}],[C2{:}],...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_cws,'MarkerEdgeColor',markercolor_cws,'DisplayName',displayname_cws)
    legend('Location','northwest')
    ylim([0 40])
    ylabel(RAO_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
%     exportgraphics(f,'RAO.png','Resolution',600)
%     saveas(f,'RAO.fig')

% fx
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter([regularwaves_c.Results.phi.T{:}],[regularwaves_c.Results.fx.A_fft{:}],...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_c,'MarkerEdgeColor',markercolor_c,'DisplayName',displayname_c)
    scatter([regularwaves_cws.Results.phi.T{:}],[regularwaves_cws.Results.fx.A_fft{:}],...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_cws,'MarkerEdgeColor',markercolor_cws,'DisplayName',displayname_cws)
    legend('Location','northwest')
    ylabel(fx_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
%     exportgraphics(f,'fx.png','Resolution',600)
%     saveas(f,'fx.fig')

% fz
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter([regularwaves_c.Results.phi.T{:}],[regularwaves_c.Results.fz.A_fft{:}],...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_c,'MarkerEdgeColor',markercolor_c,'DisplayName',displayname_c)
    scatter([regularwaves_cws.Results.phi.T{:}],[regularwaves_cws.Results.fz.A_fft{:}],...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_cws,'MarkerEdgeColor',markercolor_cws,'DisplayName',displayname_cws)
    legend('Location','northwest')
    ylabel(fz_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
%     exportgraphics(f,'fz.png','Resolution',600)
%     saveas(f,'fz.fig')

% my
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter([regularwaves_c.Results.phi.T{:}],[regularwaves_c.Results.my.A_fft{:}],...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_c,'MarkerEdgeColor',markercolor_c,'DisplayName',displayname_c)
    scatter([regularwaves_cws.Results.phi.T{:}],[regularwaves_cws.Results.my.A_fft{:}],...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_cws,'MarkerEdgeColor',markercolor_cws,'DisplayName',displayname_cws)
    legend('Location','northwest')
    ylabel(my_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
%     exportgraphics(f,'my.png','Resolution',600)
%     saveas(f,'my.fig')


% fx, normalized
% C1 = cellfun(@(x,y) x.*y, regularwaves_c.Results.fx.A_fft, num2cell(fx_norm_c), 'UniformOutput',false);
% C2 = cellfun(@(x,y) x.*y, regularwaves_cws.Results.fx.A_fft, num2cell(fx_norm_cws), 'UniformOutput',false);
% figure(); hold on
% x0=4; y0=4;
% width=7; height=3;
% set(gcf,'units','inches','position',[x0,y0,width,height])
% scatter([regularwaves_c.Results.phi.T{:}],[C1{:}],...
%     25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_c,'MarkerEdgeColor',markercolor_c,'DisplayName',displayname_c)
% scatter([regularwaves_cws.Results.phi.T{:}],[C2{:}],...
%     25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_cws,'MarkerEdgeColor',markercolor_cws,'DisplayName',displayname_cws)
% legend('Location','northwest')
% ylabel(fx_label,'Interpreter','Latex');
% xlabel(period_label,'Interpreter','Latex')
% legend('Interpreter','Latex','Location','NorthWest')
% set(gca,'FontSize',10); box on
% f = gcf;
%     exportgraphics(f,'RAO.png','Resolution',600)
%     saveas(f,'RAO.fig')
    % sample responses
run = regularwaves_c.T20_A26_B2_1;
t_raw = run.ch1;
y_raw = run.ch9;
t0 = run.position.trim.t0; tf = run.position.trim.tf;
chlabel = 'Pitch Response $\phi(t)$';
t = run.position.t;
y = run.position.phi;
t_trim = run.position.trim.t_trim_prefilt;
y_trim = run.position.trim.y_trim_prefilt;

f_trim = run.position.fft.raw.f;
Ma_trim = run.position.fft.raw.Ma;
f = run.position.fft.pre.f;
Ma = run.position.fft.pre.Ma;
f_cutoff = run.position.filt.f_cutoff;
f_filt = run.position.filt.f_filt;
h_filt = run.position.filt.h_filt;
h_Ma_filt = abs(h_filt);
h_Ph_filt =  mod(angle(h_filt)*180/pi,360)-360;


f2 = regularwaves_c.T19_A20_B2_1.position.fft.pre.f;
Ma2 = regularwaves_c.T19_A20_B2_1.position.fft.pre.Ma;

f3 = regularwaves_c.T21_A32p5_B2_1.position.fft.pre.f;
Ma3 = regularwaves_c.T21_A32p5_B2_1.position.fft.pre.Ma;

%%% ft comparisons
figure; hold on
    x0=4; y0=4;
    width=7; height=3; %4
    set(gcf,'units','inches','position',[x0,y0,width,height])
    semilogx(f,Ma,'DisplayName','T20_A26','LineWidth',1.25)
    semilogx(f2,Ma2,'DisplayName','T19 A20','LineWidth',1.25)
    semilogx(f3,Ma3,'DisplayName','T21_A32p5_B2_1','LineWidth',1.25)
    xlim([min(f),2])
    legend('Interpreter','Latex')
    xlabel('Frequency $f$(Hz)','Interpreter','Latex')
    ylabel(chlabel,'Interpreter','Latex')


% raw response
figure
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    plot(t_raw,y_raw,'Color',markercolor_c); hold on
    xline(t0,'LineWidth',1.5); xline(tf,'LineWidth',1.5)
    xlabel('t(s)')
    ylabel(chlabel,'Interpreter','Latex')
    xlabel(time_label,'Interpreter','Latex')
%     ylim([-0.02 0.02])
    %legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
curfig = gcf;
exportgraphics(curfig,['sample_pitchresponse_raw_',run.file(1:end-4),'.png'],'Resolution',600)
saveas(curfig,['sample_pitchresponse_raw_',run.file(1:end-4),'.fig'])

% subplot grid 2: (left) fft of raw trimmed and filtered data;(right) filter response
figure
    x0=4; y0=4;
    width=7; height=3; %4
    subplot(2,1,1)
    set(gcf,'units','inches','position',[x0,y0,width,height])
    semilogx(f_trim,Ma_trim,'Color',markercolor_cws,'DisplayName','Original','LineWidth',2); hold on
    semilogx(f,Ma,'Color','k','DisplayName','Filtered','LineWidth',1.25)
    xline(f_cutoff,'DisplayName','Cutoff frequency')
    xlim([min(f),100])
    legend('Interpreter','Latex')
    xlabel('Frequency $f$(Hz)','Interpreter','Latex')
    ylabel(chlabel,'Interpreter','Latex')

    subplot(2,1,2)
    yyaxis left
    semilogx(f_filt,mag2db(h_Ma_filt),'-k','DisplayName','Ma','LineWidth',1.25); hold on
    ylabel('Magnitude (dB)','Interpreter','Latex')
    yyaxis right
    semilogx(f_filt,h_Ph_filt,':k','DisplayName','Ph','LineWidth',1.25);
    xlabel('Frequency $f$(Hz)','Interpreter','Latex')
    ylabel('Phase (deg)','Interpreter','Latex')
    legend('Interpreter','Latex')
    ax=gca; ax.YAxis(1).Color='k'; ax.YAxis(2).Color='k';
    xlim([min(f),100])
    set(gca,'FontSize',10); box on 
curfig = gcf;
exportgraphics(curfig,['sample_pitchresponse_freq_',run.file(1:end-4),'.png'],'Resolution',600)
saveas(curfig,['sample_pitchresponse_freq_',run.file(1:end-4),'.fig'])


% subplot grid 3: (left) trimmed and filtered signal;(right) filtered signal only
figure
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    plot(t_trim,y_trim,'Color',markercolor_cws,'DisplayName','Original','LineWidth',1); hold on
    plot(t,y,'Color','k','DisplayName','Filtered','LineWidth',1);
    legend()
    xlabel(time_label,'Interpreter','Latex')
    ylabel(chlabel,'Interpreter','Latex')
    ylim(round(1.5*abs(max(y_trim))*[-1 1],2))
    legend('Interpreter','Latex')
    set(gca,'FontSize',10); box on
curfig = gcf;
exportgraphics(curfig,['sample_pitchresponse_filtered_',run.file(1:end-4),'.png'],'Resolution',600)
saveas(curfig,['sample_pitchresponse_filtered_',run.file(1:end-4),'.fig'])

%% ------------------ Wave Energy Prize Waves, OSWEC ------------------- %%
load('data/NREL_OSWEC/_processed/waveenergyprize_column_w_springs.mat')
load('data/NREL_OSWEC/_processed/waveenergyprize_column.mat')

% settings
pitchresponse_norm_c = 1;
pitchresponse_norm_cws = 1;

fx_norm_c = 1;
fx_norm_cws = 1;
fz_norm = 1;
my_norm_c = 1;
my_norm_cws = 1;

displayname_c = 'No external springs';
displayname_cws = 'External springs';
period_label = 'Period $T$ (s)';
time_label = 'Time $t$ (s)';
angularfrequency_label = 'Angular Frequency $\omega$  (rad/s)';
waveamp_label = 'Wave Amplitude $a$ (mm)';
pitchresponse_label = 'Pitch Amplitude $|\phi|$ (deg)';
fx_label = ['Foundation Surge Reaction ',char(10),'Force Magnitude $|F_{fr1}|$ (N)'];
fz_label = ['Foundation Heave Reaction ',char(10),'Force Magnitude $|F_{fr3}|$ (N)'];
my_label = ['Foundation Pitch Reaction ',char(10),'Moment Magnitude $|M_{Mr5}|$ (N-m)'];


A_wep = [46.8	52.8	107.2	41.2	65.2]./2;
T_wep = [1.03	1.39	1.63	1.80	2.33];
% data
% Design wave conditions
figure(); hold on
    x0=4; y0=4;
    width=4; height=4;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter(T_wep,A_wep,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','All Configurations')
    legend('Location','northwest')
    ylabel(waveamp_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    ylim([10 80])
    legend('Interpreter','Latex','Location','NorthEast')
    set(gca,'FontSize',10); box on
    pbaspect([1 1 1])
    f = gcf;
    exportgraphics(f,'designwaves.png','Resolution',600)
    saveas(f,'designwaves.fig')

% Pitch response
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter(waveenergyprize_c.Results.phi.T_mean,waveenergyprize_c.Results.phi.A_pks_mean.*pitchresponse_norm_c,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_c,'MarkerEdgeColor',markercolor_c,'DisplayName',displayname_c)
    scatter(waveenergyprize_cws.Results.phi.T_mean,waveenergyprize_cws.Results.phi.A_pks_mean.*pitchresponse_norm_cws,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_cws,'MarkerEdgeColor',markercolor_cws,'DisplayName',displayname_cws)
    legend('Location','northwest')
    ylabel(pitchresponse_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
    exportgraphics(f,'pitchresponse.png','Resolution',600)
    saveas(f,'pitchresponse.fig')    

% fx
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter(waveenergyprize_c.Results.phi.T_mean,waveenergyprize_c.Results.fx.A_pks_mean,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_c,'MarkerEdgeColor',markercolor_c,'DisplayName',displayname_c)
    scatter(waveenergyprize_cws.Results.phi.T_mean,waveenergyprize_cws.Results.fx.A_pks_mean,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_cws,'MarkerEdgeColor',markercolor_cws,'DisplayName',displayname_cws)
    legend('Location','northwest')
    ylabel(fx_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
    exportgraphics(f,'fx.png','Resolution',600)
    saveas(f,'fx.fig')
    
% fz
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter(waveenergyprize_c.Results.phi.T_mean,waveenergyprize_c.Results.fz.A_pks_mean,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_c,'MarkerEdgeColor',markercolor_c,'DisplayName',displayname_c)
    scatter(waveenergyprize_cws.Results.phi.T_mean,waveenergyprize_cws.Results.fz.A_pks_mean,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_cws,'MarkerEdgeColor',markercolor_cws,'DisplayName',displayname_cws)
    legend('Location','northwest')
    ylabel(fz_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','SouthEast')
    set(gca,'FontSize',10); box on
    f = gcf;
    exportgraphics(f,'fz.png','Resolution',600)
    saveas(f,'fz.fig')

% my
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter(waveenergyprize_c.Results.phi.T_mean,waveenergyprize_c.Results.my.A_pks_mean,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_c,'MarkerEdgeColor',markercolor_c,'DisplayName',displayname_c)
    scatter(waveenergyprize_cws.Results.phi.T_mean,waveenergyprize_cws.Results.my.A_pks_mean,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_cws,'MarkerEdgeColor',markercolor_cws,'DisplayName',displayname_cws)
    legend('Location','northwest')
    ylabel(my_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
    exportgraphics(f,'my.png','Resolution',600)
    saveas(f,'my.fig')
   
%% ---------------------- Regular Waves, VGOSWEC ----------------------- %%
   load('data/NREL_VGOSWEC/_processed/designwaves.mat')
   load('data/NREL_VGOSWEC/_processed/regularwaves_VGM0.mat')
   load('data/NREL_VGOSWEC/_processed/regularwaves_VGM10.mat')
   load('data/NREL_VGOSWEC/_processed/regularwaves_VGM20.mat')
   load('data/NREL_VGOSWEC/_processed/regularwaves_VGM45.mat')
   load('data/NREL_VGOSWEC/_processed/regularwaves_VGM90.mat')
   
   
   H_O= 0.5;
   g = 9.81;
   rho = 1000;
   w = 0.4;
   k = wave_disp(2*pi./designwaves.Results.eta_wp2.T_mean,1,9.81,0.001);

   phi_norm = 1;
   pitchresponse_norm = 1;
   RAO_norm = pi/180./(k.*designwaves.Results.eta_wp2.A_pks_mean);
   
fx_norm = 1;
fz_norm = 1;
% my_norm = 1/6*rho*g*w*H_O^2*designwaves.Results.eta_wp2.A_pks_mean;
my_norm = 1;

period_label = 'Period $T$ (s)';
time_label = 'Time $t$ (s)';
angularfrequency_label = 'Angular Frequency $\omega$  (rad/s)';
waveamp_label = 'Wave Amplitude $a$ (mm)';
pitchresponse_label = 'Pitch Amplitude $|\phi|$ (deg)';
RAO_label = '$\mathrm{RAO*}$ (-)';
fx_label = ['Foundation Surge Reaction ',char(10),'Force Magnitude $|F_{fr1}|$ (N)'];
fz_label = ['Foundation Heave Reaction ',char(10),'Force Magnitude $|F_{fr3}|$ (N)'];
my_label = ['Foundation Pitch Reaction ',char(10),'Moment Magnitude $|M_{Mr5}|$ (N-m)'];
    
% Design wave conditions
figure(); hold on
    x0=4; y0=4;
    width=4; height=4;
    set(gcf,'units','inches','position',[x0,y0,width,height])
%     scatter([designwaves.Results.eta_wp2.T{:}],[designwaves.Results.eta_wp2.A_fft{:}]*1000,...
%         25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','VG Conditions')
    scatter(designwaves.Results.eta_wp2.T_mean,designwaves.Results.eta_wp2.A_fft_mean*1000,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','VG configurations')
    legend('Location','northwest')
    ylabel(waveamp_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    pbaspect([1 1 1])
    f = gcf;
%     exportgraphics(f,'designwaves.png','Resolution',600)
%     saveas(f,'designwaves.fig')
   
% Pitch response
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter(regularwaves_VGM0.Results.phi.T_mean,regularwaves_VGM0.Results.phi.A_fft_mean*pitchresponse_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM0,'MarkerEdgeColor',markercolor_VGM0,'DisplayName','VGM0')
    scatter(regularwaves_VGM10.Results.phi.T_mean,regularwaves_VGM10.Results.phi.A_fft_mean*pitchresponse_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM10,'MarkerEdgeColor',markercolor_VGM10,'DisplayName','VGM10')
    scatter(regularwaves_VGM20.Results.phi.T_mean,regularwaves_VGM20.Results.phi.A_fft_mean*pitchresponse_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM20,'MarkerEdgeColor',markercolor_VGM20,'DisplayName','VGM20')
    scatter(regularwaves_VGM45.Results.phi.T_mean,regularwaves_VGM45.Results.phi.A_fft_mean*pitchresponse_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM45,'MarkerEdgeColor',markercolor_VGM45,'DisplayName','VGM45')
    scatter(regularwaves_VGM90.Results.phi.T_mean,regularwaves_VGM90.Results.phi.A_fft_mean*pitchresponse_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM90,'MarkerEdgeColor',markercolor_VGM90,'DisplayName','VGM90')
    legend('Location','northwest')
    ylabel(pitchresponse_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
%     exportgraphics(f,'pitchresponse.png','Resolution',600)
%     saveas(f,'pitchresponse.fig')    
    
    
% Response amplitude operator
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter(regularwaves_VGM0.Results.phi.T_mean,regularwaves_VGM0.Results.phi.A_fft_mean.*RAO_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM0,'MarkerEdgeColor',markercolor_VGM0,'DisplayName','VGM0')
    scatter(regularwaves_VGM10.Results.phi.T_mean,regularwaves_VGM10.Results.phi.A_fft_mean.*RAO_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM10,'MarkerEdgeColor',markercolor_VGM10,'DisplayName','VGM10')
    scatter(regularwaves_VGM20.Results.phi.T_mean,regularwaves_VGM20.Results.phi.A_fft_mean.*RAO_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM20,'MarkerEdgeColor',markercolor_VGM20,'DisplayName','VGM20')
    scatter(regularwaves_VGM45.Results.phi.T_mean,regularwaves_VGM45.Results.phi.A_fft_mean.*RAO_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM45,'MarkerEdgeColor',markercolor_VGM45,'DisplayName','VGM45')
    scatter(regularwaves_VGM90.Results.phi.T_mean,regularwaves_VGM90.Results.phi.A_fft_mean.*RAO_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM90,'MarkerEdgeColor',markercolor_VGM90,'DisplayName','VGM90')
    legend('Location','northwest')
    ylim([0 40])
    ylabel(RAO_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
%     exportgraphics(f,'RAO.png','Resolution',600)
%     saveas(f,'RAO.fig')


% fx
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter(regularwaves_VGM0.Results.fx.T_mean,regularwaves_VGM0.Results.fx.A_fft_mean*fx_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM0,'MarkerEdgeColor',markercolor_VGM0,'DisplayName','VGM0')
    scatter(regularwaves_VGM10.Results.fx.T_mean,regularwaves_VGM10.Results.fx.A_fft_mean*fx_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM10,'MarkerEdgeColor',markercolor_VGM10,'DisplayName','VGM10')
    scatter(regularwaves_VGM20.Results.fx.T_mean,regularwaves_VGM20.Results.fx.A_fft_mean*fx_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM20,'MarkerEdgeColor',markercolor_VGM20,'DisplayName','VGM20')
    scatter(regularwaves_VGM45.Results.fx.T_mean,regularwaves_VGM45.Results.fx.A_fft_mean*fx_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM45,'MarkerEdgeColor',markercolor_VGM45,'DisplayName','VGM45')
    scatter(regularwaves_VGM90.Results.fx.T_mean,regularwaves_VGM90.Results.fx.A_fft_mean*fx_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM90,'MarkerEdgeColor',markercolor_VGM90,'DisplayName','VGM90')
    legend('Location','northwest')
    ylabel(fx_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
%     exportgraphics(f,'fx.png','Resolution',600)
%     saveas(f,'fx.fig')

% fz
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter(regularwaves_VGM0.Results.fz.T_mean,regularwaves_VGM0.Results.fz.A_fft_mean*fz_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM0,'MarkerEdgeColor',markercolor_VGM0,'DisplayName','VGM0')
    scatter(regularwaves_VGM10.Results.fz.T_mean,regularwaves_VGM10.Results.fz.A_fft_mean*fz_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM10,'MarkerEdgeColor',markercolor_VGM10,'DisplayName','VGM10')
    scatter(regularwaves_VGM20.Results.fz.T_mean,regularwaves_VGM20.Results.fz.A_fft_mean*fz_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM20,'MarkerEdgeColor',markercolor_VGM20,'DisplayName','VGM20')
    scatter(regularwaves_VGM45.Results.fz.T_mean,regularwaves_VGM45.Results.fz.A_fft_mean*fz_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM45,'MarkerEdgeColor',markercolor_VGM45,'DisplayName','VGM45')
    scatter(regularwaves_VGM90.Results.fz.T_mean,regularwaves_VGM90.Results.fz.A_fft_mean*fz_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM90,'MarkerEdgeColor',markercolor_VGM90,'DisplayName','VGM90')
    legend('Location','northwest')
    ylabel(fz_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
%     exportgraphics(f,'fz.png','Resolution',600)
%     saveas(f,'fz.fig')

% my
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter(regularwaves_VGM0.Results.my.T_mean,regularwaves_VGM0.Results.my.A_fft_mean*my_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM0,'MarkerEdgeColor',markercolor_VGM0,'DisplayName','VGM0')
    scatter(regularwaves_VGM10.Results.my.T_mean,regularwaves_VGM10.Results.my.A_fft_mean*my_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM10,'MarkerEdgeColor',markercolor_VGM10,'DisplayName','VGM10')
    scatter(regularwaves_VGM20.Results.my.T_mean,regularwaves_VGM20.Results.my.A_fft_mean*my_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM20,'MarkerEdgeColor',markercolor_VGM20,'DisplayName','VGM20')
    scatter(regularwaves_VGM45.Results.my.T_mean,regularwaves_VGM45.Results.my.A_fft_mean*my_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM45,'MarkerEdgeColor',markercolor_VGM45,'DisplayName','VGM45')
    scatter(regularwaves_VGM90.Results.my.T_mean,regularwaves_VGM90.Results.my.A_fft_mean*my_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM90,'MarkerEdgeColor',markercolor_VGM90,'DisplayName','VGM90')
    legend('Location','northwest')
    ylabel(my_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
%     exportgraphics(f,'my.png','Resolution',600)
%     saveas(f,'my.fig')


%%% sample responses
run = regularwaves_VGM90.T18_A18p75_B2_VGM90_1;
t_raw = run.ch1;
y_raw = run.ch9;
t0 = run.position.trim.t0; tf = run.position.trim.tf;
chlabel = 'Pitch Response $\phi(t)$';
t = run.position.t;
y = run.position.phi;
t_trim = run.position.trim.t_trim_prefilt;
y_trim = run.position.trim.y_trim_prefilt;

f_trim = run.position.fft.raw.f;
Ma_trim = run.position.fft.raw.Ma;
f = run.position.fft.pre.f;
Ma = run.position.fft.pre.Ma;
f_cutoff = run.position.filt.f_cutoff;
f_filt = run.position.filt.f_filt;
h_filt = run.position.filt.h_filt;
h_Ma_filt = abs(h_filt);
h_Ph_filt =  mod(angle(h_filt)*180/pi,360)-360;


% f2 = regularwaves_c.T19_A20_B2_1.position.fft.pre.f;
% Ma2 = regularwaves_c.T19_A20_B2_1.position.fft.pre.Ma;
% 
% f3 = regularwaves_c.T21_A32p5_B2_1.position.fft.pre.f;
% Ma3 = regularwaves_c.T21_A32p5_B2_1.position.fft.pre.Ma;

% %%% ft comparisons
% figure; hold on
%     x0=4; y0=4;
%     width=7; height=3; %4
%     set(gcf,'units','inches','position',[x0,y0,width,height])
%     semilogx(f,Ma,'DisplayName','T20_A26','LineWidth',1.25)
% %     semilogx(f2,Ma2,'DisplayName','T19 A20','LineWidth',1.25)
% %     semilogx(f3,Ma3,'DisplayName','T21_A32p5_B2_1','LineWidth',1.25)
%     xlim([min(f),2])
%     legend('Interpreter','Latex')
%     xlabel('Frequency $f$(Hz)','Interpreter','Latex')
%     ylabel(chlabel,'Interpreter','Latex')
% 
% 
% % raw response
% figure
%     x0=4; y0=4;
%     width=7; height=3;
%     set(gcf,'units','inches','position',[x0,y0,width,height])
%     plot(t_raw,y_raw,'Color',markercolor_VGM0); hold on
%     xline(t0,'LineWidth',1.5); xline(tf,'LineWidth',1.5)
%     xlabel('t(s)')
%     ylabel(chlabel,'Interpreter','Latex')
%     xlabel(time_label,'Interpreter','Latex')
% %     ylim([-0.02 0.02])
%     %legend('Interpreter','Latex','Location','NorthWest')
%     set(gca,'FontSize',10); box on
% curfig = gcf;
% exportgraphics(curfig,['sample_pitchresponse_raw_',run.file(1:end-4),'.png'],'Resolution',600)
% saveas(curfig,['sample_pitchresponse_raw_',run.file(1:end-4),'.fig'])

% subplot grid 2: (left) fft of raw trimmed and filtered data;(right) filter response
% figure
%     x0=4; y0=4;
%     width=7; height=3; %4
%     subplot(2,1,1)
%     set(gcf,'units','inches','position',[x0,y0,width,height])
%     semilogx(f_trim,Ma_trim,'Color',markercolor_cws,'DisplayName','Original','LineWidth',2); hold on
%     semilogx(f,Ma,'Color','k','DisplayName','Filtered','LineWidth',1.25)
%     xline(f_cutoff,'DisplayName','Cutoff frequency')
%     xlim([min(f),100])
%     legend('Interpreter','Latex')
%     xlabel('Frequency $f$(Hz)','Interpreter','Latex')
%     ylabel(chlabel,'Interpreter','Latex')
% 
%     subplot(2,1,2)
%     yyaxis left
%     semilogx(f_filt,mag2db(h_Ma_filt),'-k','DisplayName','Ma','LineWidth',1.25); hold on
%     ylabel('Magnitude (dB)','Interpreter','Latex')
%     yyaxis right
%     semilogx(f_filt,h_Ph_filt,':k','DisplayName','Ph','LineWidth',1.25);
%     xlabel('Frequency $f$(Hz)','Interpreter','Latex')
%     ylabel('Phase (deg)','Interpreter','Latex')
%     legend('Interpreter','Latex')
%     ax=gca; ax.YAxis(1).Color='k'; ax.YAxis(2).Color='k';
%     xlim([min(f),100])
%     set(gca,'FontSize',10); box on 
% curfig = gcf;
% exportgraphics(curfig,['sample_pitchresponse_freq_',run.file(1:end-4),'.png'],'Resolution',600)
% saveas(curfig,['sample_pitchresponse_freq_',run.file(1:end-4),'.fig'])


% subplot grid 3: (left) trimmed and filtered signal;(right) filtered signal only
figure
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    plot(t_trim,y_trim,'Color',markercolor_VGM90,'DisplayName','Original','LineWidth',1); hold on
    plot(t,y,'Color',[.5 .5 .5],'DisplayName','Filtered','LineWidth',1);
    legend()
    xlabel(time_label,'Interpreter','Latex')
    ylabel(chlabel,'Interpreter','Latex')
    ylim(round(1.5*abs(max(y_trim))*[-1 1],2))
    legend('Interpreter','Latex')
    set(gca,'FontSize',10); box on
curfig = gcf;
% exportgraphics(curfig,['sample_pitchresponse_filtered_',run.file(1:end-4),'.png'],'Resolution',600)
% saveas(curfig,['sample_pitchresponse_filtered_',run.file(1:end-4),'.fig'])
   
%% ----------------- Wave Energy Prize Waves, VGOSWEC ------------------ %%
load('data/NREL_VGOSWEC/_processed/waveenergyprize_VGM0.mat')
load('data/NREL_VGOSWEC/_processed/waveenergyprize_VGM10.mat')
load('data/NREL_VGOSWEC/_processed/waveenergyprize_VGM20.mat')
load('data/NREL_VGOSWEC/_processed/waveenergyprize_VGM45.mat')
load('data/NREL_VGOSWEC/_processed/waveenergyprize_VGM90.mat')

pitchresponse_norm = 1;
fx_norm = 1;
fz_norm = 1;
my_norm = 1;

period_label = 'Period $T$ (s)';
time_label = 'Time $t$ (s)';
angularfrequency_label = 'Angular Frequency $\omega$  (rad/s)';
waveamp_label = 'Wave Amplitude $a$ (mm)';
pitchresponse_label = 'Pitch Amplitude $|\phi|$ (deg)';
RAO_label = '$\mathrm{RAO*}$ (-)';
fx_label = ['Foundation Surge Reaction ',char(10),'Force Magnitude $|F_{fr1}|$ (N)'];
fz_label = ['Foundation Heave Reaction ',char(10),'Force Magnitude $|F_{fr3}|$ (N)'];
my_label = ['Foundation Pitch Reaction ',char(10),'Moment Magnitude $|M_{Mr5}|$ (N-m)'];
       
% Design wave conditions
A_wep = [46.8	52.8	107.2	41.2	65.2]./2;
T_wep = [1.03	1.39	1.63	1.80	2.33];

% Pitch response
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter(T_wep,waveenergyprize_VGM0.Results.phi.A_pks_mean*pitchresponse_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM0,'MarkerEdgeColor',markercolor_VGM0,'DisplayName','VGM0')
    scatter(T_wep,waveenergyprize_VGM10.Results.phi.A_pks_mean*pitchresponse_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM10,'MarkerEdgeColor',markercolor_VGM10,'DisplayName','VGM10')
    scatter(T_wep,waveenergyprize_VGM20.Results.phi.A_pks_mean*pitchresponse_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM20,'MarkerEdgeColor',markercolor_VGM20,'DisplayName','VGM20')
    scatter(T_wep,waveenergyprize_VGM45.Results.phi.A_pks_mean*pitchresponse_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM45,'MarkerEdgeColor',markercolor_VGM45,'DisplayName','VGM45')
    scatter(T_wep,waveenergyprize_VGM90.Results.phi.A_pks_mean*pitchresponse_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM90,'MarkerEdgeColor',markercolor_VGM90,'DisplayName','VGM90')
    legend('Location','northwest')
    ylabel(pitchresponse_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
    exportgraphics(f,'pitchresponse.png','Resolution',600)
    saveas(f,'pitchresponse.fig')    
    
% fx
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter(T_wep,waveenergyprize_VGM0.Results.fx.A_pks_mean*fx_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM0,'MarkerEdgeColor',markercolor_VGM0,'DisplayName','VGM0')
    scatter(T_wep,waveenergyprize_VGM10.Results.fx.A_pks_mean*fx_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM10,'MarkerEdgeColor',markercolor_VGM10,'DisplayName','VGM10')
    scatter(T_wep,waveenergyprize_VGM20.Results.fx.A_pks_mean*fx_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM20,'MarkerEdgeColor',markercolor_VGM20,'DisplayName','VGM20')
    scatter(T_wep,waveenergyprize_VGM45.Results.fx.A_pks_mean*fx_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM45,'MarkerEdgeColor',markercolor_VGM45,'DisplayName','VGM45')
    scatter(T_wep,waveenergyprize_VGM90.Results.fx.A_pks_mean*fx_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM90,'MarkerEdgeColor',markercolor_VGM90,'DisplayName','VGM90')
    legend('Location','northwest')
    ylabel(fx_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
    exportgraphics(f,'fx.png','Resolution',600)
    saveas(f,'fx.fig')

% fz
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter(T_wep,waveenergyprize_VGM0.Results.fz.A_pks_mean*fz_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM0,'MarkerEdgeColor',markercolor_VGM0,'DisplayName','VGM0')
    scatter(T_wep,waveenergyprize_VGM10.Results.fz.A_pks_mean*fz_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM10,'MarkerEdgeColor',markercolor_VGM10,'DisplayName','VGM10')
    scatter(T_wep,waveenergyprize_VGM20.Results.fz.A_pks_mean*fz_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM20,'MarkerEdgeColor',markercolor_VGM20,'DisplayName','VGM20')
    scatter(T_wep,waveenergyprize_VGM45.Results.fz.A_pks_mean*fz_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM45,'MarkerEdgeColor',markercolor_VGM45,'DisplayName','VGM45')
    scatter(T_wep,waveenergyprize_VGM90.Results.fz.A_pks_mean*fz_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM90,'MarkerEdgeColor',markercolor_VGM90,'DisplayName','VGM90')
    legend('Location','northwest')
    ylabel(fz_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
    exportgraphics(f,'fz.png','Resolution',600)
    saveas(f,'fz.fig')

% my
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter(T_wep,waveenergyprize_VGM0.Results.my.A_pks_mean*my_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM0,'MarkerEdgeColor',markercolor_VGM0,'DisplayName','VGM0')
    scatter(T_wep,waveenergyprize_VGM10.Results.my.A_pks_mean*my_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM10,'MarkerEdgeColor',markercolor_VGM10,'DisplayName','VGM10')
    scatter(T_wep,waveenergyprize_VGM20.Results.my.A_pks_mean*my_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM20,'MarkerEdgeColor',markercolor_VGM20,'DisplayName','VGM20')
    scatter(T_wep,waveenergyprize_VGM45.Results.my.A_pks_mean*my_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM45,'MarkerEdgeColor',markercolor_VGM45,'DisplayName','VGM45')
    scatter(T_wep,waveenergyprize_VGM90.Results.my.A_pks_mean*my_norm,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM90,'MarkerEdgeColor',markercolor_VGM90,'DisplayName','VGM90')
    legend('Location','northwest')
    ylabel(my_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
    exportgraphics(f,'my.png','Resolution',600)
    saveas(f,'my.fig')

% % Pitch response
% figure(); hold on
%     x0=4; y0=4;
%     width=7; height=3;
%     set(gcf,'units','inches','position',[x0,y0,width,height])
%     scatter(waveenergyprize_VGM0.Results.phi.T_mean,waveenergyprize_VGM0.Results.phi.A_fft_mean*pitchresponse_norm,...
%         25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM0,'MarkerEdgeColor',markercolor_VGM0,'DisplayName','VGM0')
%     scatter(waveenergyprize_VGM10.Results.phi.T_mean,waveenergyprize_VGM10.Results.phi.A_fft_mean*pitchresponse_norm,...
%         25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM10,'MarkerEdgeColor',markercolor_VGM10,'DisplayName','VGM10')
%     scatter(waveenergyprize_VGM20.Results.phi.T_mean,waveenergyprize_VGM20.Results.phi.A_fft_mean*pitchresponse_norm,...
%         25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM20,'MarkerEdgeColor',markercolor_VGM20,'DisplayName','VGM20')
%     scatter(waveenergyprize_VGM45.Results.phi.T_mean,waveenergyprize_VGM45.Results.phi.A_fft_mean*pitchresponse_norm,...
%         25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM45,'MarkerEdgeColor',markercolor_VGM45,'DisplayName','VGM45')
%     scatter(waveenergyprize_VGM90.Results.phi.T_mean,waveenergyprize_VGM90.Results.phi.A_fft_mean*pitchresponse_norm,...
%         25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM90,'MarkerEdgeColor',markercolor_VGM90,'DisplayName','VGM90')
%     legend('Location','northwest')
%     ylabel(pitchresponse_label,'Interpreter','Latex');
%     xlabel(period_label,'Interpreter','Latex')
%     legend('Interpreter','Latex','Location','NorthWest')
%     set(gca,'FontSize',10); box on
%     f = gcf;
% %     exportgraphics(f,'pitchresponse.png','Resolution',600)
% %     saveas(f,'pitchresponse.fig')    
%     
% % fx
% figure(); hold on
%     x0=4; y0=4;
%     width=7; height=3;
%     set(gcf,'units','inches','position',[x0,y0,width,height])
%     scatter(waveenergyprize_VGM0.Results.fx.T_mean,waveenergyprize_VGM0.Results.fx.A_fft_mean*fx_norm,...
%         25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM0,'MarkerEdgeColor',markercolor_VGM0,'DisplayName','VGM0')
%     scatter(waveenergyprize_VGM10.Results.fx.T_mean,waveenergyprize_VGM10.Results.fx.A_fft_mean*fx_norm,...
%         25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM10,'MarkerEdgeColor',markercolor_VGM10,'DisplayName','VGM10')
%     scatter(waveenergyprize_VGM20.Results.fx.T_mean,waveenergyprize_VGM20.Results.fx.A_fft_mean*fx_norm,...
%         25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM20,'MarkerEdgeColor',markercolor_VGM20,'DisplayName','VGM20')
%     scatter(waveenergyprize_VGM45.Results.fx.T_mean,waveenergyprize_VGM45.Results.fx.A_fft_mean*fx_norm,...
%         25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM45,'MarkerEdgeColor',markercolor_VGM45,'DisplayName','VGM45')
%     scatter(waveenergyprize_VGM90.Results.fx.T_mean,waveenergyprize_VGM90.Results.fx.A_fft_mean*fx_norm,...
%         25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM90,'MarkerEdgeColor',markercolor_VGM90,'DisplayName','VGM90')
%     legend('Location','northwest')
%     ylabel(fx_label,'Interpreter','Latex');
%     xlabel(period_label,'Interpreter','Latex')
%     legend('Interpreter','Latex','Location','NorthWest')
%     set(gca,'FontSize',10); box on
%     f = gcf;
% %     exportgraphics(f,'fx.png','Resolution',600)
% %     saveas(f,'fx.fig')
% 
% % fz
% figure(); hold on
%     x0=4; y0=4;
%     width=7; height=3;
%     set(gcf,'units','inches','position',[x0,y0,width,height])
%     scatter(waveenergyprize_VGM0.Results.fz.T_mean,waveenergyprize_VGM0.Results.fz.A_fft_mean*fz_norm,...
%         25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM0,'MarkerEdgeColor',markercolor_VGM0,'DisplayName','VGM0')
%     scatter(waveenergyprize_VGM10.Results.fz.T_mean,waveenergyprize_VGM10.Results.fz.A_fft_mean*fz_norm,...
%         25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM10,'MarkerEdgeColor',markercolor_VGM10,'DisplayName','VGM10')
%     scatter(waveenergyprize_VGM20.Results.fz.T_mean,waveenergyprize_VGM20.Results.fz.A_fft_mean*fz_norm,...
%         25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM20,'MarkerEdgeColor',markercolor_VGM20,'DisplayName','VGM20')
%     scatter(waveenergyprize_VGM45.Results.fz.T_mean,waveenergyprize_VGM45.Results.fz.A_fft_mean*fz_norm,...
%         25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM45,'MarkerEdgeColor',markercolor_VGM45,'DisplayName','VGM45')
%     scatter(waveenergyprize_VGM90.Results.fz.T_mean,waveenergyprize_VGM90.Results.fz.A_fft_mean*fz_norm,...
%         25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM90,'MarkerEdgeColor',markercolor_VGM90,'DisplayName','VGM90')
%     legend('Location','northwest')
%     ylabel(fz_label,'Interpreter','Latex');
%     xlabel(period_label,'Interpreter','Latex')
%     legend('Interpreter','Latex','Location','NorthWest')
%     set(gca,'FontSize',10); box on
%     f = gcf;
% %     exportgraphics(f,'fz.png','Resolution',600)
% %     saveas(f,'fz.fig')
% 
% % my
% figure(); hold on
%     x0=4; y0=4;
%     width=7; height=3;
%     set(gcf,'units','inches','position',[x0,y0,width,height])
%     scatter(waveenergyprize_VGM0.Results.my.T_mean,waveenergyprize_VGM0.Results.my.A_fft_mean*my_norm,...
%         25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM0,'MarkerEdgeColor',markercolor_VGM0,'DisplayName','VGM0')
%     scatter(waveenergyprize_VGM10.Results.my.T_mean,waveenergyprize_VGM10.Results.my.A_fft_mean*my_norm,...
%         25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM10,'MarkerEdgeColor',markercolor_VGM10,'DisplayName','VGM10')
%     scatter(waveenergyprize_VGM20.Results.my.T_mean,waveenergyprize_VGM20.Results.my.A_fft_mean*my_norm,...
%         25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM20,'MarkerEdgeColor',markercolor_VGM20,'DisplayName','VGM20')
%     scatter(waveenergyprize_VGM45.Results.my.T_mean,waveenergyprize_VGM45.Results.my.A_fft_mean*my_norm,...
%         25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM45,'MarkerEdgeColor',markercolor_VGM45,'DisplayName','VGM45')
%     scatter(waveenergyprize_VGM90.Results.my.T_mean,waveenergyprize_VGM90.Results.my.A_fft_mean*my_norm,...
%         25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_VGM90,'MarkerEdgeColor',markercolor_VGM90,'DisplayName','VGM90')
%     legend('Location','northwest')
%     ylabel(my_label,'Interpreter','Latex');
%     xlabel(period_label,'Interpreter','Latex')
%     legend('Interpreter','Latex','Location','NorthWest')
%     set(gca,'FontSize',10); box on
%     f = gcf;
% %     exportgraphics(f,'my.png','Resolution',600)
% %     saveas(f,'my.fig')

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