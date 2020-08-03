function SIVTListBoxValueChanged(app, event)
app.SelectIndependentVariableTimeListBox.ItemsData = 1:numel(app.SelectIndependentVariableTimeListBox.Items);
value = app.SelectIndependentVariableTimeListBox.Value;
end
