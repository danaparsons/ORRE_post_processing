function DataFilterListBoxValueChanged(app, event)

app.OverwriteCheckBox.Value = 0;
app.OverwriteCheckBox.Enable = 'off';
app.NoneButton.Value = 1;
app.LowPassButton.Value = 0;
app.HighPassButton.Value = 0;

app.DataFilterListBox.ItemsData = 1:numel(app.DataFilterListBox.Items);
value = app.DataFilterListBox.Value;

FilteringOptionsButtonGroupSelectionChanged(app);
OverwriteCheckBoxValueChanged(app);
end

