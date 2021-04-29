function startupFcn(app)
app.DesiredSampleFrequencyEditField.Editable = 'off';
app.NoneButton.Value = true;
app.SelectDatatoAnalyzeListBox.Items = {};
app.SelectDatatoAnalyzeListBox.ItemsData = 1:numel(app.SelectDatatoAnalyzeListBox.Items);
app.OverwriteCheckBox.Enable = 'off';
format short e;

end

