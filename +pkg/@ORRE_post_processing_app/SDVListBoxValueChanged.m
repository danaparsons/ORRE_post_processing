function SDVListBoxValueChanged(app, event)
app.SelectDependentVariableListBox.ItemsData = 1:numel(app.SelectDependentVariableListBox.Items);
value = app.SelectDependentVariableListBox.Value;
end