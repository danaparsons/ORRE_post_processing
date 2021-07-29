%% ------------------------------ Header ------------------------------- %%
% Filename:     JDavis_MSThesis.m
% Description:  MS Thesis figures from OSWEC data
% Author:       J. Davis
% Created on:   7-9-21
% Last updated: 7-9-21 by J. Davis
%% ------------------------------ Inputs ------------------------------- %%
systemID = 1;

% markercolor = [70, 139, 176]./255;
markercolor_c = [135, 0, 0]./255;
% markercolor_cws = [4, 99, 140]./255;
markercolor_cws = [6, 62, 117]./255;
markeralpha = 0.65;
linecolor_analytical = [0, 82, 22 255/2]./255;
%% ----------------------------- System ID ----------------------------- %%
load('data\NREL_OSWEC\_processed\freedecay_column.mat')
load('data\NREL_OSWEC\_processed\freedecay_column_w_springs.mat')
load('data\NREL_OSWEC\WEC-Sim\freedecay_c_wecsim_PHIneg15_1.mat')

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


% freedecay comparison
figure
    x0=4; y0=4;
    width=6.0;
    height=3.0;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    plot(freedecay_c_wecsim.time,freedecay_c_wecsim.resp*180/pi,...
        'LineWidth',1.25,'Color','k','DisplayName','WEC-Sim'); hold on
    plot(freedecay_c_wecsim.time_exp,freedecay_c_wecsim.resp_exp,...
        'LineWidth',1.25,'Color',markercolor_c,'DisplayName','Experiment')
    xlabel('time (s)')
    ylabel('pitch displacement (deg)')
    ylim([-20 20])
    xlim([freedecay_c_wecsim.time(1) freedecay_c_wecsim.time(end)])
    xl = xlim; yl = ylim;
    text(0.78*xl(2),0.7*yl(1),...
        ['$B_v \,\,\;= ',num2str(round(freedecay_c_wecsim.viscdamp,3)),'$',...
        char(10),'$C_D \; = ',num2str(round(freedecay_c_wecsim.quaddamp,3)),'$',...
        char(10),'$\phi_0 = ',num2str(round(freedecay_c_wecsim.initialpos_exp,3)),'$'],...
        'Interpreter','Latex','FontSize',12)
    xlabel(time_label,'Interpreter','Latex')
    ylabel(pitchresponse_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthEast')
    set(gca,'FontSize',10); box on
f = gcf;
% exportgraphics(f,'freedecay_comparison_c.png','Resolution',900)
% saveas(f,'freedecay_comparison_c.fig')

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
exportgraphics(f,'freedecay_comparison_cws.png','Resolution',900)
saveas(f,'freedecay_comparison_cws.fig')

%% --------------------------- Regular Waves --------------------------- %%
   load('data\NREL_OSWEC\_processed\designwaves_column_w_springs.mat')
   load('data\NREL_OSWEC\_processed\designwaves_column.mat')
   load('data\NREL_OSWEC\_processed\regularwaves_column_w_springs_updated.mat')
   load('data\NREL_OSWEC\_processed\regularwaves_column.mat')
   
   load('data\NREL_OSWEC\WEC-Sim\mcr_c_output.mat')
   nodamp_sim = load('data\NREL_OSWEC\WEC-Sim\mcr_c_output_nodamping.mat')
   load('data\NREL_OSWEC\WEC-Sim\mcr_cws_output.mat')

   load('data\NREL_OSWEC\analytical\analytical_c.mat')
   load('data\NREL_OSWEC\analytical\analytical_c_interp.mat')
   nodamp_analytical = load('data\NREL_OSWEC\analytical\analytical_c_nodamping_interp.mat')
   
   load('data\NREL_OSWEC\analytical\analytical_cws.mat')
   load('data\NREL_OSWEC\analytical\analytical_cws_interp.mat')
   
   load('data\NREL_OSWEC\WEC-Sim\mcr_c_output_PTO.mat')
   load('data\NREL_OSWEC\analytical\analytical_c_PTO.mat')
    

    %% settings
   
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
    %% data
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
    %% sample responses
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
%     subplot(2,1,1)
    set(gcf,'units','inches','position',[x0,y0,width,height])
    semilogx(f_trim,Ma_trim,'Color',markercolor_cws,'DisplayName','Original','LineWidth',2); hold on
    semilogx(f,Ma,'Color','k','DisplayName','Filtered','LineWidth',1.25)
    xline(f_cutoff,'DisplayName','Cutoff frequency')
    xlim([min(f),100])
    legend('Interpreter','Latex')
    xlabel('Frequency $f$(Hz)','Interpreter','Latex')
    ylabel(chlabel,'Interpreter','Latex')

%     subplot(2,1,2)
%     yyaxis left
%     semilogx(f_filt,mag2db(h_Ma_filt),'-k','DisplayName','Ma','LineWidth',1.25); hold on
%     ylabel('Magnitude (dB)','Interpreter','Latex')
%     yyaxis right
%     semilogx(f_filt,h_Ph_filt,':k','DisplayName','Ph','LineWidth',1.25);
%     xlabel('Frequency $f$(Hz)','Interpreter','Latex')
%     ylabel('Phase (deg)','Interpreter','Latex')
    legend('Interpreter','Latex')
%     ax=gca; ax.YAxis(1).Color='k'; ax.YAxis(2).Color='k';
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
    %% WEC-Sim + Analytical Model

    % Pitch response
    figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter([regularwaves_c.Results.phi.T{:}],[regularwaves_c.Results.phi.A_fft{:}],...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_c,'MarkerEdgeColor',markercolor_c,'DisplayName','Experiment')
    plot(analytical_c.env.T,abs(analytical_c.out.xi5{1})*180/pi,...
        'Color',linecolor_analytical,'LineWidth',3,'DisplayName','Analytical')
    plot(nodamp_analytical.analytical_c.env.T,abs(nodamp_analytical.analytical_c.out.xi5{1})*180/pi,...
        ':','Color',linecolor_analytical,'LineWidth',3,'DisplayName','Analytical, no damping')
    scatter(mcr_c_output.Results.Tw,mcr_c_output.Results.xi5Amp*180/pi,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','WEC-Sim')
    h=plot(mcr_c_output.Results.Tw,mcr_c_output.Results.xi5Amp*180/pi,...
        ':','Color',[0,0,0,0.25],'LineWidth',2);     h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    scatter(nodamp_sim.mcr_c_output.Results.Tw,nodamp_sim.mcr_c_output.Results.xi5Amp*180/pi,...
        25,'^','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','WEC-Sim, no damping')
    h=plot(mcr_c_output.Results.Tw,mcr_c_output.Results.xi5Amp*180/pi,...
        ':','Color',[0,0,0,0.25],'LineWidth',2);     h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    legend('Location','northwest')
    ylabel(pitchresponse_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
    exportgraphics(f,'pitchresponse_comparison_nosprings_nodamping.png','Resolution',600)
    saveas(f,'pitchresponse_comparison_nosprings_nodamping.fig')
    
% Response amplitude operator
C1 = cellfun(@(x,y) x.*y, regularwaves_c.Results.phi.A_fft, num2cell(RAO_norm_c), 'UniformOutput',false);
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter([regularwaves_c.Results.phi.T{:}],[C1{:}],...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_c,'MarkerEdgeColor',markercolor_c,'DisplayName','Experiment')
    plot(analytical_c.env.T,abs(analytical_c.out.RAO{1})./analytical_c.env.k,...
        'Color',linecolor_analytical,'LineWidth',3,'DisplayName','Analytical')
    scatter(mcr_c_output.Results.Tw,mcr_c_output.Results.xi5Amp*180/pi.*RAO_norm_c,...
       25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','WEC-Sim')
    h=plot(mcr_c_output.Results.Tw,mcr_c_output.Results.xi5Amp*180/pi.*RAO_norm_c,...
        ':','Color',[0,0,0,0.25],'LineWidth',2);     h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    legend('Location','northwest')
    ylim([0 40])
    ylabel(RAO_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
%     exportgraphics(f,'RAO_comparison_nosprings.png','Resolution',600)
%     saveas(f,'RAO_comparison_nosprings.fig')
   
% fx
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter([regularwaves_c.Results.fx.T{:}],[regularwaves_c.Results.fx.A_fft{:}],...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_c,'MarkerEdgeColor',markercolor_c,'DisplayName','Experiment')
    plot(analytical_c.env.T,abs(analytical_c.out.Fr1{1}),...
        'Color',linecolor_analytical,'LineWidth',3,'DisplayName','Analytical')
    scatter(mcr_c_output.Results.Tw,mcr_c_output.Results.Fr1_fdn_Amp,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','WEC-Sim')
    h=plot(mcr_c_output.Results.Tw,mcr_c_output.Results.Fr1_fdn_Amp,...
        ':','Color',[0,0,0,0.25],'LineWidth',2); h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    legend('Location','northwest')
    ylabel(fx_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
%     exportgraphics(f,'fx_comparison_nosprings.png','Resolution',600)
%     saveas(f,'fx_comparison_nosprings.fig')
  
%fz
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter([regularwaves_c.Results.fz.T{:}],[regularwaves_c.Results.fz.A_fft{:}],...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_c,'MarkerEdgeColor',markercolor_c,'DisplayName','Experiment')
    scatter(mcr_c_output.Results.Tw,mcr_c_output.Results.Fr3_fdn_Amp,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','WEC-Sim')
    h=plot(mcr_c_output.Results.Tw,mcr_c_output.Results.Fr3_fdn_Amp,...
        ':','Color',[0,0,0,0.25],'LineWidth',2);     h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    legend('Location','northwest')
    ylabel(fz_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
%     exportgraphics(f,'fz_comparison_nosprings.png','Resolution',600)
%     saveas(f,'fz_comparison_nosprings.fig')

%my
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter([regularwaves_c.Results.my.T{:}],[regularwaves_c.Results.my.A_fft{:}],...
       25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_c,'MarkerEdgeColor',markercolor_c,'DisplayName','Experiment')
    plot(analytical_c.env.T,abs(analytical_c.out.Fr1{1})*.5,...
        'Color',linecolor_analytical,'LineWidth',3,'DisplayName','Analytical') 
    scatter(mcr_c_output.Results.Tw,mcr_c_output.Results.Fr5_fdn_Amp,...
       25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','WEC-Sim')
    h=plot(mcr_c_output.Results.Tw,mcr_c_output.Results.Fr5_fdn_Amp,...
        ':','Color',[0,0,0,0.25],'LineWidth',2);     h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    legend('Location','northwest')
    ylabel(my_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
%     exportgraphics(f,'my_comparison_nosprings.png','Resolution',600)
%     saveas(f,'my_comparison_nosprings.fig')

%%%%

% Pitch response
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter([regularwaves_cws.Results.phi.T{:}],[regularwaves_cws.Results.phi.A_fft{:}],...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_cws,'MarkerEdgeColor',markercolor_cws,'DisplayName','Experiment')
    plot(analytical_cws.env.T,abs(analytical_cws.out.xi5{1})*180/pi,...
        'Color',linecolor_analytical,'LineWidth',3,'DisplayName','Analytical')
    scatter(mcr_cws_output.Results.Tw,mcr_cws_output.Results.xi5Amp*180/pi,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','WEC-Sim')
    h=plot(mcr_cws_output.Results.Tw,mcr_cws_output.Results.xi5Amp*180/pi,...
        ':','Color',[0,0,0,0.25],'LineWidth',2);     h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    legend('Location','northwest')
    ylabel(pitchresponse_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
%     exportgraphics(f,'pitchresponse_comparison_springs.png','Resolution',600)
%     saveas(f,'pitchresponse_comparison_springs.fig')
    
% Response amplitude operator
C1 = cellfun(@(x,y) x.*y, regularwaves_cws.Results.phi.A_fft, num2cell(RAO_norm_cws), 'UniformOutput',false);
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter([regularwaves_cws.Results.phi.T{:}],[C1{:}],...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_cws,'MarkerEdgeColor',markercolor_cws,'DisplayName','Experiment')
    plot(analytical_cws.env.T,abs(analytical_cws.out.RAO{1})./analytical_cws.env.k,...
        'Color',linecolor_analytical,'LineWidth',3,'DisplayName','Analytical')
    scatter(mcr_cws_output.Results.Tw,mcr_cws_output.Results.xi5Amp*180/pi.*RAO_norm_cws,...
       25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','WEC-Sim')
    h=plot(mcr_cws_output.Results.Tw,mcr_cws_output.Results.xi5Amp*180/pi.*RAO_norm_cws,...
        ':','Color',[0,0,0,0.25],'LineWidth',2);     h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    legend('Location','northwest')
    ylim([0 40])
    ylabel(RAO_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
%     exportgraphics(f,'RAO_comparison_springs.png','Resolution',600)
%     saveas(f,'RAO_comparison_springs.fig')
   
%fx
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter([regularwaves_cws.Results.fx.T{:}],[regularwaves_cws.Results.fx.A_fft{:}],...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_cws,'MarkerEdgeColor',markercolor_cws,'DisplayName','Experiment')
    plot(analytical_cws.env.T,abs(analytical_cws.out.Fr1{1}),...
        'Color',linecolor_analytical,'LineWidth',3,'DisplayName','Analytical')
    scatter(mcr_cws_output.Results.Tw,mcr_cws_output.Results.Fr1_fdn_Amp./mcr_cws_output.Results.A,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','WEC-Sim')
    h=plot(mcr_cws_output.Results.Tw,mcr_cws_output.Results.Fr1_fdn_Amp,...
        ':','Color',[0,0,0,0.25],'LineWidth',2);     h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    legend('Location','northwest')
    ylabel(fx_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
%     exportgraphics(f,'fx_comparison_springs.png','Resolution',600)
%     saveas(f,'fx_comparison_springs.fig')

% fz    
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter([regularwaves_cws.Results.fz.T{:}],[regularwaves_cws.Results.fz.A_fft{:}],...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_cws,'MarkerEdgeColor',markercolor_cws,'DisplayName','Experiment')
    scatter(mcr_cws_output.Results.Tw,mcr_cws_output.Results.Fr3_fdn_Amp,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','WEC-Sim')
    h=plot(mcr_cws_output.Results.Tw,mcr_cws_output.Results.Fr3_fdn_Amp,...
        ':','Color',[0,0,0,0.25],'LineWidth',2);     h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    legend('Location','northwest')
    ylabel(fz_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
%     exportgraphics(f,'fz_comparison_springs.png','Resolution',600)
%     saveas(f,'fz_comparison_springs.fig')


figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter([regularwaves_cws.Results.my.T{:}],[regularwaves_cws.Results.my.A_fft{:}],...
       25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_cws,'MarkerEdgeColor',markercolor_cws,'DisplayName','Experiment')
    plot(analytical_cws.env.T,abs(analytical_cws.out.Fr1{1})*0.5,...
        'Color',linecolor_analytical,'LineWidth',3,'DisplayName','Analytical')
    scatter(mcr_cws_output.Results.Tw,mcr_cws_output.Results.Fr5_fdn_Amp,...
       25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','WEC-Sim')
    h=plot(mcr_cws_output.Results.Tw,mcr_cws_output.Results.Fr5_fdn_Amp,...
        ':','Color',[0,0,0,0.25],'LineWidth',2);     h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    legend('Location','northwest')
    ylabel(my_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
%     exportgraphics(f,'my_comparison_springs.png','Resolution',600)
%     saveas(f,'my_comparison_springs.fig')
    %% Power Production
    
    % Pitch response
    figure(); hold on
    x0=4; y0=4;
    width=7; height=2.5;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    plot(analytical_c_PTO.env.T,analytical_c_PTO.body.pto.nu_g{:},...
        'Color','k','LineWidth',1.5,'DisplayName','Analytical, no PTO')
    xlim([0.5 3])
    ylabel('PTO Damping $B_{PTO}$ (kg-m\textsuperscript{2}s\textsuperscript{-1})','Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    set(gca,'FontSize',10); box on
    f = gcf;
    exportgraphics(f,'damping_PTO.png','Resolution',600)
    saveas(f,'damping_PTO.fig')
    
    % Pitch response
    figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter([regularwaves_c.Results.phi.T{:}],[regularwaves_c.Results.phi.A_fft{:}],...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_c,'MarkerEdgeColor',markercolor_c,'DisplayName','Experiment, no PTO')
    plot(analytical_c.env.T,abs(analytical_c.out.xi5{1})*180/pi,...
        'Color',linecolor_analytical,'LineWidth',3,'DisplayName','Analytical, no PTO')
    plot(analytical_c_PTO.env.T,abs(analytical_c_PTO.out.xi5{1})*180/pi,...
        ':','Color',linecolor_analytical,'LineWidth',3,'DisplayName','Analytical, PTO')
    scatter(mcr_c_output.Results.Tw,mcr_c_output.Results.xi5Amp*180/pi,...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','WEC-Sim, no PTO')
    h=plot(mcr_c_output.Results.Tw,mcr_c_output.Results.xi5Amp*180/pi,...
        ':','Color',[0,0,0,0.25],'LineWidth',2);     h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    scatter(mcr_c_PTO_output.Results.Tw,mcr_c_PTO_output.Results.xi5Amp*180/pi,...
        25,'^','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','WEC-Sim, PTO')
    h=plot(mcr_c_PTO_output.Results.Tw,mcr_c_PTO_output.Results.xi5Amp*180/pi,...
        ':','Color',[0,0,0,0.25],'LineWidth',2);     h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    legend('Location','northwest')
    xlim([0.5 3])
    ylabel(pitchresponse_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
%     exportgraphics(f,'pitchresponse_comparison_PTO.png','Resolution',600)
%     saveas(f,'pitchresponse_comparison_PTO.fig')
    
% Response amplitude operator
C1 = cellfun(@(x,y) x.*y, regularwaves_c.Results.phi.A_fft, num2cell(RAO_norm_c), 'UniformOutput',false);
figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    scatter([regularwaves_c.Results.phi.T{:}],[C1{:}],...
        25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor',markercolor_c,'MarkerEdgeColor',markercolor_c,'DisplayName','Experiment, no PTO')
    plot(analytical_c.env.T,abs(analytical_c.out.RAO{1})./analytical_c.env.k,...
        'Color',linecolor_analytical,'LineWidth',3,'DisplayName','Analytical, no PTO')
    plot(analytical_c_PTO.env.T,abs(analytical_c_PTO.out.xi5{1})*180/pi.*RAO_norm_c,...
        ':','Color',linecolor_analytical,'LineWidth',3,'DisplayName','Analytical, PTO')
    scatter(mcr_c_output.Results.Tw,mcr_c_output.Results.xi5Amp*180/pi.*RAO_norm_c,...
       25,'o','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','WEC-Sim, no PTO')
    h=plot(mcr_c_output.Results.Tw,mcr_c_output.Results.xi5Amp*180/pi.*RAO_norm_c,...
           ':','Color',[0,0,0,0.25],'LineWidth',2);     h.Annotation.LegendInformation.IconDisplayStyle = 'off'; 
    scatter(mcr_c_PTO_output.Results.Tw,mcr_c_PTO_output.Results.xi5Amp*180/pi.*RAO_norm_c,...
       25,'^','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','WEC-Sim, PTO')
    h=plot(mcr_c_PTO_output.Results.Tw,mcr_c_PTO_output.Results.xi5Amp*180/pi.*RAO_norm_c,...
           ':','Color',[0,0,0,0.25],'LineWidth',2);     h.Annotation.LegendInformation.IconDisplayStyle = 'off'; 
    legend('Location','northwest')
    xlim([0.5 3])
    ylim([0 30])
    ylabel(RAO_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf;
%     exportgraphics(f,'RAO_comparison_PTO.png','Resolution',600)
%     saveas(f,'RAO_comparison_PTO.fig')
    
  
    % TAP
    figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    plot(analytical_c_PTO.env.T,analytical_c_PTO.out.TAP{1},...
        ':','Color',linecolor_analytical,'LineWidth',3,'DisplayName','Analytical')
    scatter(mcr_c_PTO_output.Results.Tw,mcr_c_PTO_output.Results.TAP,...
        25,'^','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','WEC-Sim')
    h=plot(mcr_c_PTO_output.Results.Tw,mcr_c_PTO_output.Results.TAP,...
        ':','Color',[0,0,0,0.25],'LineWidth',2);     h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    legend('Location','northwest')
    xlim([0.5 3])
    ylabel(TAP_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf; 
    ylim([0 0.175])
%     exportgraphics(f,'TAP_comparison.png','Resolution',600)
%     saveas(f,'TAP_comparison.fig')

     % TAP Wave
    figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    plot(analytical_c_PTO.env.T,analytical_c_PTO.env.TAPwave*analytical_c_PTO.body.dim.w,...
        '-','Color','k','LineWidth',1.25,'DisplayName','Wave Power')
     plot(analytical_c_PTO.env.T,analytical_c_PTO.out.TAP{1},...
        ':','Color',linecolor_analytical,'LineWidth',3,'DisplayName','Analytical')
    scatter(mcr_c_PTO_output.Results.Tw,mcr_c_PTO_output.Results.TAP,...
        25,'^','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','WEC-Sim')
    h=plot(mcr_c_PTO_output.Results.Tw,mcr_c_PTO_output.Results.TAP,...
        ':','Color',[0,0,0,0.25],'LineWidth',2);     h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    legend('Interpreter','Latex','Location','NorthWest')
    xlim([0.5 3])
    ylabel([TAP_label],'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
%     legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf; 
%     ylim([0 3])
    exportgraphics(f,'TAP_comparison_w_wave.png','Resolution',600)
    saveas(f,'TAP_comparison_w_wave.fig')

    % CWR
    figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    plot(analytical_c_PTO.env.T,analytical_c_PTO.out.TAP{1}./(analytical_c_PTO.env.TAPwave*analytical_c_PTO.body.dim.w),...
        ':','Color',linecolor_analytical,'LineWidth',3,'DisplayName','Analytical')
    scatter(mcr_c_PTO_output.Results.Tw,mcr_c_PTO_output.Results.TAP./(analytical_c_PTO.env.TAPwave*analytical_c_PTO.body.dim.w),...
        25,'^','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','WEC-Sim')
    h=plot(mcr_c_PTO_output.Results.Tw,mcr_c_PTO_output.Results.TAP./(analytical_c_PTO.env.TAPwave*analytical_c_PTO.body.dim.w),...
        ':','Color',[0,0,0,0.25],'LineWidth',2);     h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    legend('Location','northwest')
    xlim([0.5 3])
    ylabel(CWR_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthEast')
    set(gca,'FontSize',10); box on
    f = gcf; 
    exportgraphics(f,'CWR_comparison.png','Resolution',600)
    saveas(f,'CWR_comparison.fig')

    % PTO torque
    figure(); hold on
    x0=4; y0=4;
    width=7; height=3;
    set(gcf,'units','inches','position',[x0,y0,width,height])
    plot(analytical_c_PTO.env.T,abs(1i*analytical_c_PTO.env.omega.*analytical_c_PTO.out.xi5{:}).*analytical_c_PTO.body.pto.nu_g{:} ,...
        ':','Color',linecolor_analytical,'LineWidth',3,'DisplayName','Analytical')
    scatter(mcr_c_PTO_output.Results.Tw,mcr_c_PTO_output.Results.PTO_torque_Amp,...
        25,'^','MarkerFaceAlpha',markeralpha,'MarkerEdgeAlpha',0.9,'MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','WEC-Sim')
    h=plot(mcr_c_PTO_output.Results.Tw,mcr_c_PTO_output.Results.PTO_torque_Amp,...
        ':','Color',[0,0,0,0.25],'LineWidth',2);     h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    legend('Location','northwest')
    xlim([0.5 3])
    ylabel(PTO_torque_label,'Interpreter','Latex');
    xlabel(period_label,'Interpreter','Latex')
    legend('Interpreter','Latex','Location','NorthWest')
    set(gca,'FontSize',10); box on
    f = gcf; 
%     exportgraphics(f,'PTO_torque_comparison.png','Resolution',600)
%     saveas(f,'PTO_torque_comparison.fig')

%% ---------------------------- Hydro Coeff ---------------------------- %%


load('data\NREL_OSWEC\\WEC-Sim\hydro_OSWEC.mat');

    omega = transpose(hydro.w);
    I55     = 0.4142; % [kg-m2]
    mass    = 14.324;             % [kg] Device mass
    h       = 1;              % [m]
    rho = hydro.rho;  % [kg/m^3]
    g   = hydro.g; % [m/s^2]
    A11 = squeeze(hydro.A(1,1,:))*rho;
    A15 = squeeze(hydro.A(1,5,:))*rho;
    A55 = squeeze(hydro.A(5,5,:))*rho;
    B55 = squeeze(hydro.B(5,5,:))*rho.*omega;
    B15 = squeeze(hydro.B(1,5,:))*rho.*omega;
    C55 = hydro.C(5,5)*rho.*g;
    X5ma = squeeze(hydro.ex_ma(5,1,:))*rho.*g;
    X5ph = squeeze(hydro.ex_ph(5,1,:));
    X1ma = squeeze(hydro.ex_ma(1,1,:))*rho.*g;
    X1ph = squeeze(hydro.ex_ph(1,1,:));        
    
%     omega_norm  = 1;                omega_label = 'Angular Frequency $\omega \: [rad/s]$';
%     omega_norm = sqrt(h/g);         omega_label = {'$\omega^*$'};
%     A11_norm    = (mass)^-1;        A11_label   = 'Surge Added Mass $A^*_{11}$ (kg)';
%     A55_norm    = (I55)^-1;         A55_label   = 'Pitch Added Inertia $A^*_{55}$ ';
%     B55_norm    = (omega*I55).^-1;  B55_label   = 'Pitch Radiation Damping $B^*_{55}$';
%     X5ma_norm    = 1;   X5ma_label   = 'Ex. Torque Mag. $|X^*_{5}|\cdot10^3 \: (-)$';
%     X5ph_norm    = 1;              X5ph_label   = 'Ex. Torque Phase $\angle \: (-)$';
%     X1ma_norm    = (rho*g*omega).^-1;       X1ma_label   = 'Ex. Force Mag. $|X^*_{1}| \: (-)$';
%     X1ph_norm    = (3.14).^-1;              X1ph_label   = 'Ex. Force Phase $\varphi^*_{1} \: (-)$';
    
    omega_norm = 1;         omega_label = {'$\omega$ (rad/s)'};
    A15_norm    = 1;        A15_label   = 'Surge-Pitch Added Mass $A_{15}$ (kg-m)';
    B15_norm    = 1;        B15_label   = 'Surge-Pitch Rad. Damping $B_{15}$ (kg-m s\textsuperscript{-1})';
    A55_norm    = 1;         A55_label   = 'Pitch Added Inertia $A_{55}$ (kg-m\textsuperscript{2})';
    B55_norm    = 1;  B55_label   = 'Pitch Radiation Damping $B_{55}$ (kg-m\textsuperscript{2}s\textsuperscript{-1})';
    X5ma_norm    = 10^(-3);   X5ma_label   = 'Pitch Ex. Torque Mag. $|X_{5}|$ (kN-m)';
    X5ph_norm    = 1;              X5ph_label   = 'Pitch Ex. Torque Phase $\angle |X_{5}|$ (rad)';
    X1ma_norm    = 10^(-3);       X1ma_label   = 'Surge Ex. Force Mag. $|X_{1}|$ (kN)';
    X1ph_norm    = 1;              X1ph_label   = 'Surge Ex. Force Phase $\angle |X_{1}|$ (rad)';
    
        % combined surge-pitch added mass and rad damp
        figure()
        x0=4; y0=4;
        width=4; height=3.25;
        set(gcf,'units','inches','position',[x0,y0,width,height])
        yyaxis left
            plot(omega*omega_norm,A15.*A15_norm,'-','Color','k','LineWidth',1.25,'DisplayName','$A_{15}$');hold on
            ylabel(A15_label,'Interpreter','Latex');
            xlabel(omega_label,'Interpreter','Latex')
            %ylim([0 60]); yticks(10*(0:6))
            set(gca,'FontSize',12)
            legend(han,'Interpreter','Latex','Location','NorthEast')
        yyaxis right
            % B11
            plot(omega*omega_norm,B15.*B15_norm,':','Color','k','LineWidth',1.5,'DisplayName','$B_{15}$');hold on
            ylabel(B15_label,'Interpreter','Latex');
            xlabel(omega_label,'Interpreter','Latex')
%             xlim([min(omega) max(omega)]*omega_norm);
            ylim([0 120]);  %ytickformat('%.1f')
            set(gca,'FontSize',10)
        ax=gca; ax.YAxis(1).Color='k'; ax.YAxis(2).Color='k';
        legend('Interpreter','Latex','Location','NorthEast')
        f = gcf;
        exportgraphics(f,'WAMIT_combined_surge-pitch_added_mass_and_radiation_damping.png','Resolution',600)
        saveas(f,'WAMIT_combined_surge-pitch_added_mass_and_radiation_damping.fig')



        % combined pitch added mass and rad damp
        figure()
        x0=4; y0=4;
        width=4; height=3.25;
        set(gcf,'units','inches','position',[x0,y0,width,height])
        yyaxis left
            plot(omega*omega_norm,A55.*A55_norm,'-','Color','k','LineWidth',1.25,'DisplayName','$A_{55}$');hold on
            ylabel(A55_label,'Interpreter','Latex');
            xlabel(omega_label,'Interpreter','Latex')
            %ylim([0 60]); yticks(10*(0:6))
            set(gca,'FontSize',12)
            legend(han,'Interpreter','Latex','Location','NorthEast')
        yyaxis right
            % B55
            plot(omega*omega_norm,B55.*B55_norm,':','Color','k','LineWidth',1.5,'DisplayName','$B_{55}$');hold on
            ylabel(B55_label,'Interpreter','Latex');
            xlabel(omega_label,'Interpreter','Latex')
%             xlim([min(omega) max(omega)]*omega_norm);
            ylim([0 25]);  %ytickformat('%.1f')
            set(gca,'FontSize',10)
        ax=gca; ax.YAxis(1).Color='k'; ax.YAxis(2).Color='k';
        legend('Interpreter','Latex','Location','NorthEast')
        f = gcf;
        exportgraphics(f,'WAMIT_combined_pitch_added_mass_and_radiation_damping.png','Resolution',600)
        saveas(f,'WAMIT_combined_pitch_added_mass_and_radiation_damping.fig')

        % Excitation torque magnitude and phase
        figure()
        x0=4; y0=4;
        width=4; height=3.25;
        set(gcf,'units','inches','position',[x0,y0,width,height])
        yyaxis left
            % X5ma
            plot(omega*omega_norm,X5ma.*X5ma_norm,'-','Color','k','LineWidth',1.25,'DisplayName','$|X_5|$');hold on
            ylabel(X5ma_label,'Interpreter','Latex');
            xlabel(omega_label,'Interpreter','Latex')
%             xlim([min(omega) max(omega)]*omega_norm);  ytickformat('%.1f')
            set(gca,'FontSize',12)
            legend(han,'Interpreter','Latex','Location','NorthEast')
        yyaxis right
            % X5ph
            plot(omega*omega_norm,X5ph.*X5ph_norm,':','Color','k','LineWidth',1.5,'DisplayName','$\angle|X_5|$');hold on
            ylabel(X5ph_label,'Interpreter','Latex');
            xlabel(omega_label,'Interpreter','Latex')
%             xlim([min(omega) max(omega)]*omega_norm);
%             ylim([0.075 0.525]);  ytickformat('%.1f')
            set(gca,'FontSize',10)
        ax=gca; ax.YAxis(1).Color='k'; ax.YAxis(2).Color='k';
        legend('Interpreter','Latex','Location','NorthEast')
        f = gcf;
        exportgraphics(f,'WAMIT_pitch_ex_magnitude_and_phase.png','Resolution',600)
        saveas(f,'WAMIT_pitch_ex_magnitude_and_phase.fig')

        
        % Excitation force magnitude and phase
        figure()
        x0=4; y0=4;
        width=4; height=3.25;
        set(gcf,'units','inches','position',[x0,y0,width,height])
        yyaxis left
        % Create dummy legend entries:
            % X1ma
            plot(omega*omega_norm,X1ma.*X1ma_norm,'-','Color','k','LineWidth',1.25,'DisplayName','$|X_1|$');hold on
            ylabel(X1ma_label,'Interpreter','Latex');
            xlabel(omega_label,'Interpreter','Latex')
%             xlim([min(omega) max(omega)]*omega_norm);  ytickformat('%.1f')
            set(gca,'FontSize',12)
            legend(han,'Interpreter','Latex','Location','NorthEast')
        yyaxis right
            % X1ph
            plot(omega*omega_norm,X1ph.*X1ph_norm,':','Color','k','LineWidth',1.5,'DisplayName','$\angle|X_1|$');hold on
            ylabel(X1ph_label,'Interpreter','Latex');
            xlabel(omega_label,'Interpreter','Latex')
%             xlim([min(omega) max(omega)]*omega_norm)
%             ylim([0.075 0.525]);  ytickformat('%.1f')
            set(gca,'FontSize',10)
        ax=gca; ax.YAxis(1).Color='k'; ax.YAxis(2).Color='k';
        legend('Interpreter','Latex','Location','NorthEast')
        f = gcf;
        exportgraphics(f,'WAMIT_surge_ex_magnitude_and_phase.png','Resolution',600)
        saveas(f,'WAMIT_surge_ex_magnitude_and_phase.fig')
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