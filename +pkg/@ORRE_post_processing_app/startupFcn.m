function startupFcn(app)
app.DesiredSampleFrequencyEditField.Editable = 'off';
app.NoneButton.Value = true;
app.SelectDatatoAnalyzeListBox.Items = {};
%%this might need to be changed^
app.SelectDatatoAnalyzeListBox.ItemsData = 1:numel(app.SelectDatatoAnalyzeListBox.Items);
%app.SelectDatatoAnalyzeListBox.Value = [];

app.OverwriteCheckBox.Enable = 'off';
end

