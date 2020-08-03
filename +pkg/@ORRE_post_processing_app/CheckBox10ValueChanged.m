function CheckBox10ValueChanged(app, event)
if app.CheckBox10.Value
    cla(app.UIAxes)
    app.UITable2.Data = [];
    app.SelectDatatoAnalyzeListBox.Value = [];
    app.CheckBox10.Value = false;
end
end
