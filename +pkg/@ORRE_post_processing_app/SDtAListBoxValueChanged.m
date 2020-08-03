function SDtAListBoxValueChanged (app, event)
app.UITable2.Data = [];
cla(app.UIAxes);
hold(app.UIAxes);
%app.UIAxes.Legend.Visible = 'on';
app.SelectDatatoAnalyzeListBox.Multiselect = 'on';
app.SelectDatatoAnalyzeListBox.ItemsData = 1:numel(app.SelectDatatoAnalyzeListBox.Items);
value = app.SelectDatatoAnalyzeListBox.Value;
%             number_selections = length(app.SelectDatatoAnalyzeListBox.ItemsData);
%app.Wavedata.(strcat('ch',(num2str(1)))) = sqrt(app.Wavedata.(strcat('ch',(num2str(1)))));

rowname = {};
value = sort(value);
for lbvalue = value(1:end)
    %y = app.Filtered_Channels(:,lbvalue);
    y = app.Wavedata.(strcat('ch',(num2str(lbvalue))));
    hold(app.UIAxes,'on');
    %timehistory = plot(app.UIAxes,app.Filtered_Channels(:,app.EnterNumericTimeChannelEditField.Value),y);
    timehistory = plot(app.UIAxes,app.Wavedata.(strcat('ch',(num2str(app.EnterNumericTimeChannelEditField.Value)))),y);
    hold(app.UIAxes,'off');
    %analysisrow = [lbvalue,timehistory.Color(1,1),mean(app.Combined_Channels(:,lbvalue)), min(app.Combined_Channels(:,lbvalue)),max(app.Combined_Channels(:,lbvalue)),std(app.Combined_Channels(:,lbvalue))];
    analysisrow = [lbvalue,cell(1),mean(y), min(y),max(y),std(y)];
    app.UITable2.Data = [app.UITable2.Data;analysisrow];
    
    rowname{value==lbvalue} = app.Wavedata.headers{lbvalue};
    s = uistyle('BackgroundColor',timehistory.Color);
    addStyle(app.UITable2,s,'cell',[find(value==lbvalue),2]);
end
app.UITable2.RowName = rowname;
end