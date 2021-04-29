function CreateReportButtonPushed(app,event)
selectednodes = app.Tree.SelectedNodes;

cd +output;
w = dir('*.png');
ReportImages = [];
for i = 1:length(w)
    reportimage = {char(w(i).name)};
    ReportImages = [ReportImages;cell2table(reportimage)];
    %app.StatsTable.Data = [app.StatsTable.Data;analysisrow];
end

% % figs = openfig('TheFigFile.fig');
% figs = selectednodes(1:end).Text;
% for K = 1 : length(figs)
%    filename = strcat('figure_',K,'.png');
%    saveas(figs(K), filename);
% end

import mlreportgen.report.* 
import mlreportgen.dom.* 
%import rptgen.cform_docx_page_layout
rpt = Report('Sample','docx');

add(rpt,TitlePage('Title','ORRE Sample Data'));
add(rpt,TableOfContents);
chap = Chapter('Figures');

%%%%%%%
% figures = figure(selectednodes);
for i = 1:length(w)
    figure = Image(w(i).name);
    figure.Style = {ScaleToFit};
    add(chap, figure);
end

% figures = Image('TimeHistory_ East Wave Probe (m).png');
% figures.Style = {ScaleToFit};
% add(chap,figures);

add(rpt,chap);

%%%%%%%%%%%%%%%%%%%%%%% chapter 2 %%%%%%%%%%%%%%%%%%%%%%%%%
chap2 = Chapter(); 
chap2.Title = sprintf('Statistics'); 

% Stats Table 
app.ReportStatsTable = app.StatsTable.Data;
% fmt=['%5d %10.2E\n'];
% app.ReportStatsTable = (fmt,app.StatsTable.Data);
%app.ReportStatsTable(:,2) = cell(length(app.StatsTable(:,2)),1);
otoprow = app.StatsTable.ColumnName;
toprow = otoprow.';
app.ReportStatsTable = [toprow;app.ReportStatsTable];
%tbl = Table(app.ReportStatsTable);


% app.TheTable = app.StatsTable.Data;
% app.TheTable(:,2) = [0,0,0,0];
% Statsdata_str = string(app.TheTable);
% %round to 2 decimal places
% for i = 1:numel(Statsdata_str)
% Statsdata_str(i) = sprintf('%.2f',Statsdata_str(i));
% end
% %add formatted strings to table
% % t = array2table(Statsdata_str,'VariableNames',{'Ch','Color'},'RowNames',{'c','d'});
% tbl = array2table(Statsdata_str,'VariableNames',{'Ch','Color','Mean','Min','Max','Std Dev'},'RowNames',app.Wavedata.headers);


tbl = FormalTable('Statistics Table',app.ReportStatsTable);

tbl.Style = {... 
    RowSep('solid','black','1px'),... 
    ColSep('solid','black','1px'),}; 
tbl.Border = 'double'; 
tbl.TableEntriesStyle = {HAlign('center')}; 
%tbl.Title = ('Statistics');

add(chap2,tbl); 
add(rpt,chap2); 
%End stats table

close(rpt);
rptview(rpt);

% sec(2) = Section;
% sec(2).Title = ['Graphs'];
% fig1 = Image('+output\FilterTimeHistory_ West Wave Probe (m).png');
% add(sec(2),fig1);
% add(rpt,sec(2));

% %FilterImage = load('pkg/output/FilterTimeHistory.fig');
% FilterImage = load(which('pkg/output/FilterTimeHistory_ West Wave Probe (m).fig'),'-fig'); 
% figure('Units','Pixels','Position',... 
% [200 200 size(FilterImage.X,2)*.5 ... 
% size(FilterImage.X,1)*.5 ]); 
% image(FilterImage.X);

% 
% add(chap,Section('Title','Filter Time History', ...
%     'Content',Image(which('FilterData_TimeHistory.png'))));


% exportgraphics(app.TimeHistoryAxes,'TimeHistory_WaveProbe_B(m).jpg');
% import mlreportgen.dom.*
% import mlreportgen.report.*
% rpt = Report("myreport","pdf");
% open(rpt);
% imgPath = which('TimeHistory_WaveProbe_B(m).jpg');
% heading = Heading1("Unscaled Image");
% add(rpt,heading);
% img1 = Image(imgPath);
% add(rpt,img1);


% add(chap,Section('Title','Wavedata', ...
%     'Content',Image(which("ORRE.png"))));


% add(chap,Section('Title','Wavedata', ...
%     'Content',Image(which('FilterTimeHistory_WaveProbe_B(m).png'))));


% %Title Page%
% tp = TitlePage; 
% tp.Title = 'Sample Report'; 
% tp.Subtitle = 'ORRE Sample Data Analysis'; 
% tp.Author = 'Devon Lukas'; 
% add(rpt,tp);
% 
% %chapters%
% ch1 = Chapter; 
% ch1.Title = 'Time History'; 
% sec1 = Section; 
% sec1.Title = 'Tables'; 
% para = Paragraph([...
%     'Description'...
%     'here']); 
% add(sec1,para) 
% add(ch1,sec1) 
% sec2 = Section; 
% sec2.Title = 'Figures'; 
% para = Paragraph([ ... 
%     'Description'...
%     'here']); 
% add(sec2,para) 
% add(ch1,sec2) 

end

%%old idea:
% project_dir = pwd();
% files = dir( fullfile(project_dir, '*.png'));
% a = actxserver('Word.application');
% a.Visible = 1;
% Document = a.Document;
% 
% [fn, dn] = uigetfile('*.docx', 'Select Word File To Amend');
% filename = fullfile(dn, fn);                                %changed
% Document = invoke(Document, 'open', filename);
% 
% for i=1:length(files)
%     page_count = int32(double(slide_count)+1);
%     page = invoke(Document.Pages, 'Add', page_count{i}, 11);
%     pagefile = fullfile(project_dir, files(i).name);
%     Image{i} = page.AddPicture(pagefile);
% end
% outfile = fullfile(project_dir, 'DRAFT.docx');
% Document.SaveAs(outfile);
% 
% a.Quit;
% a.delete;
    
