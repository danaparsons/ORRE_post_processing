function UpdateTreeButtonPushed(app, event)

%%% work in progress %%%

infolder = dir ('+output');
app.Node.Text = 'output';
%files = [];

ext = 'png';
pkg.fun.export_figs.export_figs(ext);
for i = 1:length(infolder)
    if infolder(i).isdir==0
        %files{end+1,1} = infolder(i).name;
        files = char(infolder(i).name);
        pictures = strcat(files,'.fig');
%         ImageData = frame2im(pictures);
%         app.Report_Images = ImageData;
        uitreenode(app.Node,'Text',files,'NodeData',pictures);
        %graphfilename = strcat(files,app.gsuffix);
        %exportgraphics(app.FilterAxes,graphfilename);
        %exportgraphics(app.FilterAxes,pictures);
    end
end
end
% selectednodes = app.Tree.SelectedNodes;
% node = event.Node; 
% for j = 1:length(selectednodes)
%     app.Node(j).NodeData
% end