function CheckBox10ValueChanged(app, event)
if app.ClearButton.Value
    cla(app.TimeHistoryAxes)
    app.StatsTable.Data = [];
    app.SelectDatatoAnalyzeListBox.Value = [];
    app.ClearButton.Value = false;
end
end
