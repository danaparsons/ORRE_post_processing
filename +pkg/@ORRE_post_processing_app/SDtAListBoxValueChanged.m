function SDtAListBoxValueChanged (app, event)
app.StatsTable.Data = [];
cla(app.TimeHistoryAxes);
hold(app.TimeHistoryAxes);
%app.TimeHistoryAxes.Legend.Visible = 'on';
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
    hold(app.TimeHistoryAxes,'on');
    %timehistory = plot(app.TimeHistoryAxes,app.Filtered_Channels(:,app.EnterNumericTimeChannelEditField.Value),y);
    timehistory = plot(app.TimeHistoryAxes,app.Wavedata.(strcat('ch',(num2str(app.EnterNumericTimeChannelEditField.Value)))),y);
    hold(app.TimeHistoryAxes,'off');
    %analysisrow = [lbvalue,timehistory.Color(1,1),mean(app.Combined_Channels(:,lbvalue)), min(app.Combined_Channels(:,lbvalue)),max(app.Combined_Channels(:,lbvalue)),std(app.Combined_Channels(:,lbvalue))];
    analysisrow = [lbvalue,cell(1),mean(y), min(y),max(y),std(y)];
    app.StatsTable.Data = [app.StatsTable.Data;analysisrow];
    
    rowname{value==lbvalue} = app.Wavedata.headers{lbvalue};
    s = uistyle('BackgroundColor',timehistory.Color);
    addStyle(app.StatsTable,s,'cell',[find(value==lbvalue),2]);
end
app.StatsTable.RowName = rowname;
end
