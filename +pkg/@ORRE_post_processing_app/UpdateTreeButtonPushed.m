function UpdateTreeButtonPushed(app, event)

infolder = dir ('+output');
app.Node.Text = 'output';
%files = [];
for i = 1:length(infolder)
    if infolder(i).isdir==0
        %files{end+1,1} = infolder(i).name;
        files = char(infolder(i).name);
        uitreenode(app.Node,'Text',files);
    end
end
            
end